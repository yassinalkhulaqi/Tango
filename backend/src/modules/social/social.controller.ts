import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthUser } from '../../common/types';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import {
  CreateCommentDto,
  CreateFriendRequestDto,
  CreatePostDto,
  ListCommentsDto,
  ListFriendRequestsDto,
  ListPostsDto,
} from './dto/social.dto';
import { SocialService } from './social.service';

@ApiTags('social')
@ApiBearerAuth()
@Controller('social')
export class SocialController {
  constructor(private readonly social: SocialService) {}

  @Post('friend-requests')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Send a friend request' })
  async sendRequest(@CurrentUser() user: AuthUser, @Body() dto: CreateFriendRequestDto) {
    return { data: await this.social.sendRequest(user.id, dto) };
  }

  @Get('friend-requests')
  @ApiOperation({ summary: 'List incoming or outgoing friend requests' })
  async requests(@CurrentUser() user: AuthUser, @Query() query: ListFriendRequestsDto) {
    return this.social.requests(user.id, query);
  }

  @Post('friend-requests/:id/accept')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Accept an incoming friend request' })
  async accept(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return { data: await this.social.accept(user.id, id) };
  }

  @Post('friend-requests/:id/reject')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Reject an incoming friend request' })
  async reject(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return { data: await this.social.reject(user.id, id) };
  }

  @Get('friends')
  @ApiOperation({ summary: 'List friends' })
  async friends(@CurrentUser() user: AuthUser, @Query() query: ListFriendRequestsDto) {
    return this.social.friends(user.id, query);
  }

  @Delete('friends/:id')
  @ApiOperation({ summary: 'Remove a friendship' })
  async removeFriend(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return { data: await this.social.removeFriend(user.id, id) };
  }

  @Post('posts')
  @ApiOperation({ summary: 'Create a social post' })
  async createPost(@CurrentUser() user: AuthUser, @Body() dto: CreatePostDto) {
    return { data: await this.social.createPost(user.id, dto) };
  }

  @Get('posts')
  @ApiOperation({ summary: 'Paginated social feed' })
  async posts(@CurrentUser() user: AuthUser, @Query() query: ListPostsDto) {
    return this.social.posts(user.id, query);
  }

  @Get('posts/:id')
  @ApiOperation({ summary: 'Get one social post' })
  async post(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return { data: await this.social.post(user.id, id) };
  }

  @Delete('posts/:id')
  @ApiOperation({ summary: 'Delete own social post' })
  async deletePost(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return { data: await this.social.deletePost(user.id, id) };
  }

  @Post('posts/:id/like')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Like a post' })
  async like(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return { data: await this.social.like(user.id, id) };
  }

  @Delete('posts/:id/like')
  @ApiOperation({ summary: 'Unlike a post' })
  async unlike(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return { data: await this.social.unlike(user.id, id) };
  }

  @Post('posts/:id/comments')
  @ApiOperation({ summary: 'Comment on a post' })
  async comment(
    @CurrentUser() user: AuthUser,
    @Param('id') id: string,
    @Body() dto: CreateCommentDto,
  ) {
    return { data: await this.social.comment(user.id, id, dto) };
  }

  @Get('posts/:id/comments')
  @ApiOperation({ summary: 'List comments of a post' })
  async comments(@Param('id') id: string, @Query() query: ListCommentsDto) {
    return this.social.comments(id, query);
  }

  @Delete('comments/:id')
  @ApiOperation({ summary: 'Delete own comment' })
  async deleteComment(@CurrentUser() user: AuthUser, @Param('id') id: string) {
    return { data: await this.social.deleteComment(user.id, id) };
  }
}
