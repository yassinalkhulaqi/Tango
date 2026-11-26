import { HttpStatus, Injectable } from '@nestjs/common';
import { FriendRequestStatus, NotificationType } from '@prisma/client';
import { ApiError } from '../../common/api-error';
import { paginate, Paginated } from '../../common/pagination';
import { PrismaService } from '../../prisma/prisma.service';
import { LeaderboardService } from '../leaderboard/leaderboard.service';
import {
  CreateCommentDto,
  CreateFriendRequestDto,
  CreatePostDto,
  ListCommentsDto,
  ListFriendRequestsDto,
  ListPostsDto,
} from './dto/social.dto';

const PROFILE_SELECT = {
  id: true,
  displayName: true,
  avatarUrl: true,
  xp: true,
  level: true,
  streakCount: true,
} as const;

@Injectable()
export class SocialService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly leaderboard: LeaderboardService,
  ) {}

  async sendRequest(userId: string, dto: CreateFriendRequestDto) {
    if (userId === dto.receiverId) {
      throw new ApiError(HttpStatus.BAD_REQUEST, 'CANNOT_FRIEND_SELF', 'Cannot friend yourself');
    }
    const receiver = await this.prisma.user.findUnique({
      where: { id: dto.receiverId },
      select: { id: true },
    });
    if (!receiver) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'USER_NOT_FOUND', 'User not found');
    }
    const existingFriend = await this.prisma.friendship.findFirst({
      where: {
        OR: [
          { userId, friendId: dto.receiverId },
          { userId: dto.receiverId, friendId: userId },
        ],
      },
      select: { id: true },
    });
    if (existingFriend) {
      throw new ApiError(HttpStatus.CONFLICT, 'ALREADY_FRIENDS', 'Already friends');
    }
    const pending = await this.prisma.friendRequest.findFirst({
      where: {
        status: FriendRequestStatus.PENDING,
        OR: [
          { senderId: userId, receiverId: dto.receiverId },
          { senderId: dto.receiverId, receiverId: userId },
        ],
      },
      select: { id: true },
    });
    if (pending) {
      throw new ApiError(HttpStatus.CONFLICT, 'REQUEST_PENDING', 'A friend request is already pending');
    }
    const request = await this.prisma.friendRequest.create({
      data: {
        senderId: userId,
        receiverId: dto.receiverId,
        ...(dto.message ? { message: dto.message } : {}),
      },
    });
    await this.prisma.notification.create({
      data: {
        userId: dto.receiverId,
        type: NotificationType.FRIEND_REQUEST,
        title: 'New friend request',
        body: dto.message ?? 'Someone wants to be your friend.',
        data: { requestId: request.id, senderId: userId },
      },
    });
    return request;
  }

  async requests(
    userId: string,
    query: ListFriendRequestsDto,
  ): Promise<Paginated<any>> {
    const limit = query.limit ?? 20;
    const direction = query.direction ?? 'incoming';
    const rows = await this.prisma.friendRequest.findMany({
      where: {
        ...(direction === 'incoming' ? { receiverId: userId } : { senderId: userId }),
        ...(query.status ? { status: query.status } : {}),
      },
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: { createdAt: 'desc' },
      include: {
        sender: { select: PROFILE_SELECT },
        receiver: { select: PROFILE_SELECT },
      },
    });
    return paginate(rows, limit);
  }

  async accept(userId: string, requestId: string) {
    const request = await this.prisma.friendRequest.findUnique({
      where: { id: requestId },
    });
    if (!request) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'REQUEST_NOT_FOUND', 'Friend request not found');
    }
    if (request.receiverId !== userId) {
      throw new ApiError(HttpStatus.FORBIDDEN, 'FORBIDDEN', 'Only the receiver can accept');
    }
    if (request.status !== FriendRequestStatus.PENDING) {
      throw new ApiError(HttpStatus.CONFLICT, 'REQUEST_ALREADY_HANDLED', 'Request was already handled');
    }
    await this.prisma.$transaction([
      this.prisma.friendRequest.update({
        where: { id: requestId },
        data: { status: FriendRequestStatus.ACCEPTED },
      }),
      this.prisma.friendship.upsert({
        where: {
          userId_friendId: { userId, friendId: request.senderId },
        },
        create: { userId, friendId: request.senderId },
        update: {},
      }),
      this.prisma.friendship.upsert({
        where: {
          userId_friendId: { userId: request.senderId, friendId: userId },
        },
        create: { userId: request.senderId, friendId: userId },
        update: {},
      }),
      this.prisma.notification.create({
        data: {
          userId: request.senderId,
          type: NotificationType.FRIEND_ACCEPTED,
          title: 'Friend request accepted',
          body: 'You are now friends on CodeBro.',
          data: { userId },
        },
      }),
    ]);
    await this.leaderboard.syncFriendLeaderboards(userId).catch(() => undefined);
    await this.leaderboard.syncFriendLeaderboards(request.senderId).catch(() => undefined);
    return { requestId, status: FriendRequestStatus.ACCEPTED, friendId: request.senderId };
  }

  async reject(userId: string, requestId: string) {
    const request = await this.prisma.friendRequest.findUnique({
      where: { id: requestId },
    });
    if (!request) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'REQUEST_NOT_FOUND', 'Friend request not found');
    }
    if (request.receiverId !== userId) {
      throw new ApiError(HttpStatus.FORBIDDEN, 'FORBIDDEN', 'Only the receiver can reject');
    }
    if (request.status !== FriendRequestStatus.PENDING) {
      throw new ApiError(HttpStatus.CONFLICT, 'REQUEST_ALREADY_HANDLED', 'Request was already handled');
    }
    await this.prisma.friendRequest.update({
      where: { id: requestId },
      data: { status: FriendRequestStatus.REJECTED },
    });
    return { requestId, status: FriendRequestStatus.REJECTED };
  }

  async friends(userId: string, query: ListFriendRequestsDto): Promise<Paginated<any>> {
    const limit = query.limit ?? 20;
    const rows = await this.prisma.friendship.findMany({
      where: { userId },
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: { createdAt: 'desc' },
      select: { friend: { select: PROFILE_SELECT } },
    });
    return paginate(
      rows.map((row) => ({ ...row.friend, id: row.friend.id })),
      limit,
    );
  }

  async removeFriend(userId: string, friendId: string) {
    const result = await this.prisma.friendship.deleteMany({
      where: {
        OR: [
          { userId, friendId },
          { userId: friendId, friendId: userId },
        ],
      },
    });
    await this.leaderboard.syncFriendLeaderboards(userId).catch(() => undefined);
    return { removed: result.count > 0 };
  }

  async createPost(userId: string, dto: CreatePostDto) {
    if (dto.courseId) {
      const course = await this.prisma.course.findUnique({
        where: { id: dto.courseId },
        select: { id: true },
      });
      if (!course) {
        throw new ApiError(HttpStatus.NOT_FOUND, 'COURSE_NOT_FOUND', 'Course not found');
      }
    }
    return this.prisma.socialPost.create({
      data: {
        authorId: userId,
        content: dto.content,
        ...(dto.imageUrl ? { imageUrl: dto.imageUrl } : {}),
        ...(dto.codeSnippet ? { codeSnippet: dto.codeSnippet } : {}),
        ...(dto.language ? { language: dto.language } : {}),
        ...(dto.courseId ? { courseId: dto.courseId } : {}),
      },
    });
  }

  async posts(userId: string, query: ListPostsDto): Promise<Paginated<any>> {
    const limit = query.limit ?? 20;
    const rows = await this.prisma.socialPost.findMany({
      where: {
        ...(query.authorId ? { authorId: query.authorId } : {}),
        ...(query.courseId ? { courseId: query.courseId } : {}),
      },
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: { createdAt: 'desc' },
      include: {
        author: { select: PROFILE_SELECT },
        _count: { select: { likes: true, comments: true } },
        likes: { where: { userId }, select: { id: true } },
      },
    });
    return paginate(
      rows.map((post) => ({
        id: post.id,
        author: post.author,
        content: post.content,
        codeSnippet: post.codeSnippet,
        language: post.language,
        imageUrl: post.imageUrl,
        courseId: post.courseId,
        createdAt: post.createdAt,
        likeCount: post._count.likes,
        commentCount: post._count.comments,
        likedByMe: post.likes.length > 0,
      })),
      limit,
    );
  }

  async post(userId: string, postId: string) {
    const post = await this.prisma.socialPost.findUnique({
      where: { id: postId },
      include: {
        author: { select: PROFILE_SELECT },
        _count: { select: { likes: true, comments: true } },
        likes: { where: { userId }, select: { id: true } },
      },
    });
    if (!post) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'POST_NOT_FOUND', 'Post not found');
    }
    return {
      id: post.id,
      author: post.author,
      content: post.content,
      codeSnippet: post.codeSnippet,
      language: post.language,
      imageUrl: post.imageUrl,
      courseId: post.courseId,
      createdAt: post.createdAt,
      likeCount: post._count.likes,
      commentCount: post._count.comments,
      likedByMe: post.likes.length > 0,
    };
  }

  async deletePost(userId: string, postId: string) {
    const post = await this.prisma.socialPost.findUnique({
      where: { id: postId },
      select: { authorId: true },
    });
    if (!post) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'POST_NOT_FOUND', 'Post not found');
    }
    if (post.authorId !== userId) {
      throw new ApiError(HttpStatus.FORBIDDEN, 'FORBIDDEN', 'Only the author can delete a post');
    }
    await this.prisma.socialPost.delete({ where: { id: postId } });
    return { deleted: true };
  }

  async like(userId: string, postId: string) {
    const post = await this.prisma.socialPost.findUnique({
      where: { id: postId },
      select: { authorId: true },
    });
    if (!post) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'POST_NOT_FOUND', 'Post not found');
    }
    await this.prisma.postLike.upsert({
      where: { postId_userId: { postId, userId } },
      create: { postId, userId },
      update: {},
    });
    if (post.authorId !== userId) {
      await this.prisma.notification.create({
        data: {
          userId: post.authorId,
          type: NotificationType.POST_LIKE,
          title: 'Someone liked your post',
          data: { postId, userId },
        },
      });
    }
    return { liked: true };
  }

  async unlike(userId: string, postId: string) {
    await this.prisma.postLike.deleteMany({ where: { postId, userId } });
    return { liked: false };
  }

  async comment(userId: string, postId: string, dto: CreateCommentDto) {
    const post = await this.prisma.socialPost.findUnique({
      where: { id: postId },
      select: { authorId: true },
    });
    if (!post) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'POST_NOT_FOUND', 'Post not found');
    }
    const comment = await this.prisma.postComment.create({
      data: { postId, authorId: userId, content: dto.content },
      include: { author: { select: PROFILE_SELECT } },
    });
    if (post.authorId !== userId) {
      await this.prisma.notification.create({
        data: {
          userId: post.authorId,
          type: NotificationType.POST_COMMENT,
          title: 'New comment on your post',
          body: dto.content,
          data: { postId, commentId: comment.id, userId },
        },
      });
    }
    return comment;
  }

  async comments(postId: string, query: ListCommentsDto): Promise<Paginated<any>> {
    const limit = query.limit ?? 20;
    const rows = await this.prisma.postComment.findMany({
      where: { postId },
      take: limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      orderBy: { createdAt: 'asc' },
      include: { author: { select: PROFILE_SELECT } },
    });
    return paginate(rows, limit);
  }

  async deleteComment(userId: string, commentId: string) {
    const comment = await this.prisma.postComment.findUnique({
      where: { id: commentId },
      select: { authorId: true },
    });
    if (!comment) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'COMMENT_NOT_FOUND', 'Comment not found');
    }
    if (comment.authorId !== userId) {
      throw new ApiError(HttpStatus.FORBIDDEN, 'FORBIDDEN', 'Only the author can delete a comment');
    }
    await this.prisma.postComment.delete({ where: { id: commentId } });
    return { deleted: true };
  }
}
