class SocialUser {
  const SocialUser({
    required this.id,
    required this.name,
    this.avatar = '',
    this.level = 1,
    this.xp = 0,
  });

  final String id;
  final String name;
  final String avatar;
  final int level;
  final int xp;

  String get initials {
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.map((p) => p[0]).take(2).join().toUpperCase();
  }

  factory SocialUser.fromJson(Map<String, dynamic> json) {
    final name = '${json['displayName'] ?? json['name'] ?? 'Learner'}';
    return SocialUser(
      id: '${json['id'] ?? ''}',
      name: name,
      avatar: '${json['avatarUrl'] ?? json['avatar'] ?? ''}',
      level: (json['level'] as num?)?.toInt() ?? 1,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
    );
  }
}

class SocialPost {
  const SocialPost({
    required this.id,
    required this.author,
    required this.body,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.likedByMe = false,
  });

  final String id;
  final SocialUser author;
  final String body;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final bool likedByMe;

  SocialPost copyWith({bool? likedByMe, int? likes}) => SocialPost(
    id: id,
    author: author,
    body: body,
    createdAt: createdAt,
    likes: likes ?? this.likes,
    comments: comments,
    likedByMe: likedByMe ?? this.likedByMe,
  );

  factory SocialPost.fromJson(Map<String, dynamic> json) {
    final authorJson = json['author'] is Map
        ? Map<String, dynamic>.from(json['author'] as Map)
        : <String, dynamic>{
            'displayName': '${json['authorName'] ?? 'Learner'}',
          };
    return SocialPost(
      id: '${json['id'] ?? ''}',
      author: SocialUser.fromJson(authorJson),
      body: '${json['content'] ?? json['body'] ?? ''}',
      createdAt: DateTime.tryParse('${json['createdAt']}') ?? DateTime.now(),
      likes:
          (json['likeCount'] as num?)?.toInt() ??
          (json['likes'] as num?)?.toInt() ??
          0,
      comments:
          (json['commentCount'] as num?)?.toInt() ??
          (json['comments'] as num?)?.toInt() ??
          0,
      likedByMe: json['likedByMe'] == true,
    );
  }
}

class Friend {
  const Friend({required this.user, this.online = false});

  final SocialUser user;
  final bool online;

  factory Friend.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'] as Map)
        : json;
    return Friend(
      user: SocialUser.fromJson(userJson),
      online: json['online'] == true || json['isOnline'] == true,
    );
  }
}
