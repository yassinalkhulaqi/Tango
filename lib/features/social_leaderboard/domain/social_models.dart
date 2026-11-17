import 'package:flutter/material.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final int level;
  final int xp;
  final int rank;
  final int streak;
  final int lessonsCompleted;
  final int quizzesCompleted;
  final int badgesEarned;
  final double accuracy;
  final DateTime joinedAt;
  final DateTime lastActive;
  final bool isOnline;
  final List<String> friends;
  final List<String> badges;
  final Map<String, dynamic> stats;
  final String bio;
  final String location;
  final String website;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.level,
    required this.xp,
    required this.rank,
    required this.streak,
    required this.lessonsCompleted,
    required this.quizzesCompleted,
    required this.badgesEarned,
    required this.accuracy,
    required this.joinedAt,
    required this.lastActive,
    this.isOnline = false,
    this.friends = const [],
    this.badges = const [],
    this.stats = const {},
    this.bio = '',
    this.location = '',
    this.website = '',
  });

  double get xpToNextLevel {
    final nextLevelXp = (level * 1000).toDouble();
    return nextLevelXp - xp;
  }

  double get levelProgress {
    final currentLevelXp = ((level - 1) * 1000).toDouble();
    final nextLevelXp = (level * 1000).toDouble();
    final currentProgress = xp - currentLevelXp;
    return currentProgress / (nextLevelXp - currentLevelXp);
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    int? level,
    int? xp,
    int? rank,
    int? streak,
    int? lessonsCompleted,
    int? quizzesCompleted,
    int? badgesEarned,
    double? accuracy,
    DateTime? joinedAt,
    DateTime? lastActive,
    bool? isOnline,
    List<String>? friends,
    List<String>? badges,
    Map<String, dynamic>? stats,
    String? bio,
    String? location,
    String? website,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      rank: rank ?? this.rank,
      streak: streak ?? this.streak,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
      badgesEarned: badgesEarned ?? this.badgesEarned,
      accuracy: accuracy ?? this.accuracy,
      joinedAt: joinedAt ?? this.joinedAt,
      lastActive: lastActive ?? this.lastActive,
      isOnline: isOnline ?? this.isOnline,
      friends: friends ?? this.friends,
      badges: badges ?? this.badges,
      stats: stats ?? this.stats,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      website: website ?? this.website,
    );
  }
}

class LeaderboardEntry {
  final String userId;
  final String name;
  final String avatar;
  final int level;
  final int xp;
  final int rank;
  final int streak;
  final bool isCurrentUser;
  final bool isFriend;
  final DateTime lastActive;

  const LeaderboardEntry({
    required this.userId,
    required this.name,
    required this.avatar,
    required this.level,
    required this.xp,
    required this.rank,
    required this.streak,
    this.isCurrentUser = false,
    this.isFriend = false,
    required this.lastActive,
  });

  LeaderboardEntry copyWith({
    String? userId,
    String? name,
    String? avatar,
    int? level,
    int? xp,
    int? rank,
    int? streak,
    bool? isCurrentUser,
    bool? isFriend,
    DateTime? lastActive,
  }) {
    return LeaderboardEntry(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      rank: rank ?? this.rank,
      streak: streak ?? this.streak,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isFriend: isFriend ?? this.isFriend,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}

class Friend {
  final String id;
  final String name;
  final String avatar;
  final int level;
  final int xp;
  final int streak;
  final bool isOnline;
  final DateTime lastActive;
  final FriendStatus status;

  const Friend({
    required this.id,
    required this.name,
    required this.avatar,
    required this.level,
    required this.xp,
    required this.streak,
    this.isOnline = false,
    required this.lastActive,
    this.status = FriendStatus.active,
  });

  Friend copyWith({
    String? id,
    String? name,
    String? avatar,
    int? level,
    int? xp,
    int? streak,
    bool? isOnline,
    DateTime? lastActive,
    FriendStatus? status,
  }) {
    return Friend(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      status: status ?? this.status,
    );
  }
}

enum FriendStatus {
  active,
  away,
  offline,
  pending,
  blocked,
}

class Badge {
  final String id;
  final String name;
  final String description;
  final String icon;
  final Color color;
  final int xpReward;
  final String category;
  final DateTime? earnedAt;
  final bool isRare;
  final int rarityLevel;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.xpReward,
    required this.category,
    this.earnedAt,
    this.isRare = false,
    this.rarityLevel = 1,
  });

  Badge copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    Color? color,
    int? xpReward,
    String? category,
    DateTime? earnedAt,
    bool? isRare,
    int? rarityLevel,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      xpReward: xpReward ?? this.xpReward,
      category: category ?? this.category,
      earnedAt: earnedAt ?? this.earnedAt,
      isRare: isRare ?? this.isRare,
      rarityLevel: rarityLevel ?? this.rarityLevel,
    );
  }

  String get rarityLabel {
    switch (rarityLevel) {
      case 1:
        return 'Common';
      case 2:
        return 'Uncommon';
      case 3:
        return 'Rare';
      case 4:
        return 'Epic';
      case 5:
        return 'Legendary';
      default:
        return 'Common';
    }
  }
}

class ShareContent {
  final String type;
  final String title;
  final String description;
  final String imageUrl;
  final String shareUrl;
  final Map<String, dynamic> metadata;

  const ShareContent({
    required this.type,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.shareUrl,
    this.metadata = const {},
  });
}

class SocialStats {
  final int totalFriends;
  final int onlineFriends;
  final int pendingRequests;
  final int totalBadges;
  final int rareBadges;
  final int totalXP;
  final int averageXPPerFriend;
  final int rankAmongFriends;

  const SocialStats({
    required this.totalFriends,
    required this.onlineFriends,
    required this.pendingRequests,
    required this.totalBadges,
    required this.rareBadges,
    required this.totalXP,
    required this.averageXPPerFriend,
    required this.rankAmongFriends,
  });
}

class LeaderboardFilter {
  final String period;
  final String scope;
  final String sortBy;

  const LeaderboardFilter({
    required this.period,
    required this.scope,
    required this.sortBy,
  });

  static List<String> get periods => ['Weekly', 'Monthly', 'All-time'];
  static List<String> get scopes => ['Global', 'Friends', 'Country'];
  static List<String> get sortBy => ['XP', 'Level', 'Streak', 'Lessons'];

  LeaderboardFilter copyWith({
    String? period,
    String? scope,
    String? sortBy,
  }) {
    return LeaderboardFilter(
      period: period ?? this.period,
      scope: scope ?? this.scope,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class FriendRequest {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String fromUserAvatar;
  final DateTime sentAt;
  final FriendRequestStatus status;

  const FriendRequest({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    required this.fromUserAvatar,
    required this.sentAt,
    this.status = FriendRequestStatus.pending,
  });
}

enum FriendRequestStatus {
  pending,
  accepted,
  rejected,
  cancelled,
}

class SocialPost {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final bool isLiked;
  final DateTime createdAt;
  final List<SocialComment> comments;

  const SocialPost({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    required this.createdAt,
    this.comments = const [],
  });

  SocialPost copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    String? imageUrl,
    int? likes,
    int? comments,
    bool? isLiked,
    DateTime? createdAt,
    List<SocialComment>? comments,
  }) {
    return SocialPost(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
    );
  }
}

class SocialComment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createdAt;

  const SocialComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createdAt,
  });
}

class AchievementProgress {
  final String achievementId;
  final String name;
  final String description;
  final String icon;
  final Color color;
  final int currentProgress;
  final int targetProgress;
  final int xpReward;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const AchievementProgress({
    required this.achievementId,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.currentProgress,
    required this.targetProgress,
    required this.xpReward,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  double get progressPercent {
    return currentProgress / targetProgress.clamp(1, targetProgress);
  }

  AchievementProgress copyWith({
    String? achievementId,
    String? name,
    String? description,
    String? icon,
    Color? color,
    int? currentProgress,
    int? targetProgress,
    int? xpReward,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return AchievementProgress(
      achievementId: achievementId ?? this.achievementId,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      currentProgress: currentProgress ?? this.currentProgress,
      targetProgress: targetProgress ?? this.targetProgress,
      xpReward: xpReward ?? this.xpReward,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}
