import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/providers.dart';
import 'social_dto.dart';

class SocialRepository {
  SocialRepository(this._api);

  final ApiClient _api;

  Future<List<SocialPost>> fetchPosts() async {
    try {
      final body = await _api.get('/social/posts');
      final raw = body['data'];
      if (raw is! List) return const <SocialPost>[];
      return raw
          .whereType<Map>()
          .map((row) => SocialPost.fromJson(Map<String, dynamic>.from(row)))
          .toList();
    } on Object {
      return const <SocialPost>[];
    }
  }

  Future<List<Friend>> fetchFriends() async {
    try {
      final body = await _api.get('/social/friends');
      final raw = body['data'];
      if (raw is! List) return const <Friend>[];
      return raw
          .whereType<Map>()
          .map((row) => Friend.fromJson(Map<String, dynamic>.from(row)))
          .toList();
    } on Object {
      return const <Friend>[];
    }
  }

  Future<bool> toggleLike(String postId, bool liked) async {
    try {
      if (liked) {
        await _api.delete('/social/posts/$postId/like');
      } else {
        await _api.post('/social/posts/$postId/like');
      }
      return true;
    } on Object {
      return false;
    }
  }

  Future<bool> sendFriendRequest(String userId) async {
    try {
      await _api.post('/social/friends/requests', data: {'userId': userId});
      return true;
    } on Object {
      return false;
    }
  }
}

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepository(ref.watch(apiClientProvider));
});

final socialPostsProvider = FutureProvider<List<SocialPost>>((ref) async {
  return ref.watch(socialRepositoryProvider).fetchPosts();
});

final socialFriendsProvider = FutureProvider<List<Friend>>((ref) async {
  return ref.watch(socialRepositoryProvider).fetchFriends();
});
