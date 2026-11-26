import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/social/data/social_dto.dart';

void main() {
  test('parses a post with nested author and like counts', () {
    final post = SocialPost.fromJson({
      'id': 'p1',
      'content': 'Just finished the Flutter course!',
      'author': {'id': 'u1', 'displayName': 'Alex Rivera', 'level': 9},
      'likeCount': 12,
      'commentCount': 3,
      'likedByMe': true,
      'createdAt': '2026-01-01T10:00:00.000Z',
    });

    expect(post.author.name, 'Alex Rivera');
    expect(post.likes, 12);
    expect(post.comments, 3);
    expect(post.likedByMe, isTrue);
    expect(post.createdAt.year, 2026);
  });

  test('copyWith toggles the like state', () {
    final post = SocialPost(
      id: 'p2',
      author: SocialUser(id: 'u2', name: 'Sam Chen'),
      body: 'Hello',
      createdAt: DateTime(2026),
      likes: 4,
    );
    final liked = post.copyWith(likedByMe: true, likes: 5);

    expect(liked.likedByMe, isTrue);
    expect(liked.likes, 5);
    expect(liked.body, 'Hello');
  });

  test('friend parses online status from either key', () {
    final friend = Friend.fromJson({
      'user': {'id': 'u3', 'displayName': 'Jordan Lee'},
      'isOnline': true,
    });

    expect(friend.user.initials, 'JL');
    expect(friend.online, isTrue);
  });

  test('default initials come from the user name', () {
    const user = SocialUser(id: 'u4', name: 'Ada Lovelace');
    expect(user.initials, 'AL');
  });
}
