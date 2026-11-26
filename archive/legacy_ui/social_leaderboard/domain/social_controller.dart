import 'package:flutter/material.dart';
import '../domain/social_models.dart';

class LeaderboardController extends ChangeNotifier {
  List<LeaderboardEntry> _entries = [];
  List<Friend> _friends = [];
  List<FriendRequest> _friendRequests = [];
  UserProfile? _currentUserProfile;
  SocialStats? _socialStats;
  List<SocialPost> _socialPosts = [];
  List<AchievementProgress> _achievementProgress = [];
  LeaderboardFilter _filter = const LeaderboardFilter(
    period: 'Weekly',
    scope: 'Global',
    sortBy: 'XP',
  );
  bool _isLoading = false;
  bool _isLoadingFriends = false;
  bool _isLoadingPosts = false;
  String? _errorMessage;
  int _selectedTab = 0;

  List<LeaderboardEntry> get entries => List.unmodifiable(_entries);
  List<Friend> get friends => List.unmodifiable(_friends);
  List<FriendRequest> get friendRequests => List.unmodifiable(_friendRequests);
  UserProfile? get currentUserProfile => _currentUserProfile;
  SocialStats? get socialStats => _socialStats;
  List<SocialPost> get socialPosts => List.unmodifiable(_socialPosts);
  List<AchievementProgress> get achievementProgress =>
      List.unmodifiable(_achievementProgress);
  LeaderboardFilter get filter => _filter;
  bool get isLoading => _isLoading;
  bool get isLoadingFriends => _isLoadingFriends;
  bool get isLoadingPosts => _isLoadingPosts;
  String? get errorMessage => _errorMessage;
  int get selectedTab => _selectedTab;

  UserProfile get currentUser => _currentUserProfile ??
      const UserProfile(
        id: 'user_1',
        name: 'Alex Rivera',
        email: 'alex@codebro.dev',
        avatar: 'U1',
        level: 7,
        xp: 8900,
        rank: 42,
        streak: 12,
        lessonsCompleted: 48,
        quizzesCompleted: 24,
        badgesEarned: 6,
        accuracy: 85.5,
        joinedAt: DateTime(2024, 1, 15),
        lastActive: DateTime.now(),
        isOnline: true,
        friends: ['user_2', 'user_3', 'user_4'],
        badges: ['first_commit', 'bug_squasher', 'week_warrior'],
        stats: {'total_time_spent': 1200, 'favorite_language': 'Dart'},
        bio: 'Flutter developer passionate about clean code',
        location: 'San Francisco, CA',
        website: 'https://codebro.dev',
      );

  LeaderboardEntry? get currentUserEntry {
    try {
      return _entries.firstWhere((e) => e.isCurrentUser);
    } catch (_) {
      return null;
    }
  }

  int get pendingFriendRequests =>
      _friendRequests.where((r) => r.status == FriendRequestStatus.pending).length;

  List<LeaderboardEntry> get filteredEntries {
    var filtered = List<LeaderboardEntry>.from(_entries);

    switch (_filter.sortBy) {
      case 'XP':
        filtered.sort((a, b) => b.xp.compareTo(a.xp));
        break;
      case 'Level':
        filtered.sort((a, b) => b.level.compareTo(a.level));
        break;
      case 'Streak':
        filtered.sort((a, b) => b.streak.compareTo(a.streak));
        break;
      case 'Lessons':
        filtered.sort((a, b) =>
            _getLessonsForUser(b.userId).compareTo(_getLessonsForUser(a.userId)));
        break;
    }

    if (_filter.scope == 'Friends') {
      final friendIds = _friends.map((f) => f.id).toList()..add(currentUser.id);
      filtered = filtered.where((e) => friendIds.contains(e.userId)).toList();
    }

    return filtered;
  }

  int _getLessonsForUser(String userId) {
    return _socialStats?.totalFriends ?? 0;
  }

  void setFilter(LeaderboardFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setPeriod(String period) {
    _filter = _filter.copyWith(period: period);
    notifyListeners();
  }

  void setScope(String scope) {
    _filter = _filter.copyWith(scope: scope);
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _filter = _filter.copyWith(sortBy: sortBy);
    notifyListeners();
  }

  void loadLeaderboard() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _entries = _generateMockEntries();
      _isLoading = false;
      notifyListeners();
    });
  }

  void loadFriends() {
    _isLoadingFriends = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 800), () {
      _friends = _generateMockFriends();
      _socialStats = _generateSocialStats();
      _isLoadingFriends = false;
      notifyListeners();
    });
  }

  void loadSocialPosts() {
    _isLoadingPosts = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _socialPosts = _generateMockPosts();
      _isLoadingPosts = false;
      notifyListeners();
    });
  }

  void loadAchievementProgress() {
    _achievementProgress = _generateAchievementProgress();
    notifyListeners();
  }

  void loadCurrentUserProfile() {
    _currentUserProfile = currentUser;
    notifyListeners();
  }

  void loadFriendRequests() {
    _friendRequests = _generateMockFriendRequests();
    notifyListeners();
  }

  void setSelectedTab(int tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void sendFriendRequest(String userId) {
    _friendRequests.add(FriendRequest(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      fromUserId: currentUser.id,
      fromUserName: currentUser.name,
      fromUserAvatar: currentUser.avatar,
      sentAt: DateTime.now(),
      status: FriendRequestStatus.pending,
    ));
    notifyListeners();
  }

  void acceptFriendRequest(String requestId) {
    final index = _friendRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      final request = _friendRequests[index];
      _friendRequests[index] = request.copyWith(
        status: FriendRequestStatus.accepted,
      );
      _friends.add(Friend(
        id: request.fromUserId,
        name: request.fromUserName,
        avatar: request.fromUserAvatar,
        level: 5,
        xp: 3200,
        streak: 5,
        isOnline: true,
        lastActive: DateTime.now(),
        status: FriendStatus.active,
      ));
      notifyListeners();
    }
  }

  void rejectFriendRequest(String requestId) {
    final index = _friendRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _friendRequests[index] = _friendRequests[index].copyWith(
        status: FriendRequestStatus.rejected,
      );
      notifyListeners();
    }
  }

  void removeFriend(String friendId) {
    _friends.removeWhere((f) => f.id == friendId);
    notifyListeners();
  }

  void toggleLikePost(String postId) {
    final index = _socialPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _socialPosts[index];
      _socialPosts[index] = post.copyWith(
        isLiked: !post.isLiked,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
      );
      notifyListeners();
    }
  }

  void addComment(String postId, String content) {
    final index = _socialPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _socialPosts[index];
      _socialPosts[index] = post.copyWith(
        comments: post.comments + 1,
        comments: [
          ...post.comments,
          SocialComment(
            id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
            postId: postId,
            userId: currentUser.id,
            userName: currentUser.name,
            userAvatar: currentUser.avatar,
            content: content,
            createdAt: DateTime.now(),
          ),
        ],
      );
      notifyListeners();
    }
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  List<LeaderboardEntry> _generateMockEntries() {
    return [
      LeaderboardEntry(
        userId: 'user_1',
        name: 'Alex Rivera',
        avatar: 'U1',
        level: 12,
        xp: 18400,
        rank: 1,
        streak: 15,
        isCurrentUser: true,
        isFriend: false,
        lastActive: DateTime.now(),
      ),
      LeaderboardEntry(
        userId: 'user_2',
        name: 'Sam Chen',
        avatar: 'U2',
        level: 11,
        xp: 16200,
        rank: 2,
        streak: 12,
        isCurrentUser: false,
        isFriend: true,
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      LeaderboardEntry(
        userId: 'user_3',
        name: 'Jordan Lee',
        avatar: 'U3',
        level: 10,
        xp: 14800,
        rank: 3,
        streak: 8,
        isCurrentUser: false,
        isFriend: false,
        lastActive: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      LeaderboardEntry(
        userId: 'user_4',
        name: 'Taylor Kim',
        avatar: 'U4',
        level: 9,
        xp: 12400,
        rank: 4,
        streak: 6,
        isCurrentUser: false,
        isFriend: true,
        lastActive: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      LeaderboardEntry(
        userId: 'user_5',
        name: 'Morgan Davis',
        avatar: 'U5',
        level: 8,
        xp: 11100,
        rank: 5,
        streak: 3,
        isCurrentUser: false,
        isFriend: false,
        lastActive: DateTime.now().subtract(const Duration(days: 1)),
      ),
      LeaderboardEntry(
        userId: 'user_6',
        name: 'Casey Wu',
        avatar: 'U6',
        level: 7,
        xp: 9500,
        rank: 6,
        streak: 1,
        isCurrentUser: false,
        isFriend: false,
        lastActive: DateTime.now().subtract(const Duration(days: 2)),
      ),
      LeaderboardEntry(
        userId: 'user_7',
        name: 'Riley Ortiz',
        avatar: 'U7',
        level: 7,
        xp: 9200,
        rank: 7,
        streak: 2,
        isCurrentUser: false,
        isFriend: false,
        lastActive: DateTime.now().subtract(const Duration(days: 3)),
      ),
      LeaderboardEntry(
        userId: 'user_8',
        name: 'Quinn Martinez',
        avatar: 'U8',
        level: 6,
        xp: 7800,
        rank: 8,
        streak: 1,
        isCurrentUser: false,
        isFriend: false,
        lastActive: DateTime.now().subtract(const Duration(days: 4)),
      ),
      LeaderboardEntry(
        userId: 'user_9',
        name: 'Parker Sullivan',
        avatar: 'U9',
        level: 6,
        xp: 7500,
        rank: 9,
        streak: 0,
        isCurrentUser: false,
        isFriend: false,
        lastActive: DateTime.now().subtract(const Duration(days: 5)),
      ),
      LeaderboardEntry(
        userId: 'user_10',
        name: 'Jordan Hayes',
        avatar: 'U10',
        level: 5,
        xp: 6200,
        rank: 10,
        streak: 1,
        isCurrentUser: false,
        isFriend: false,
        lastActive: DateTime.now().subtract(const Duration(days: 6)),
      ),
    ];
  }

  List<Friend> _generateMockFriends() {
    return [
      Friend(
        id: 'user_2',
        name: 'Sam Chen',
        avatar: 'U2',
        level: 11,
        xp: 16200,
        streak: 12,
        isOnline: true,
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
        status: FriendStatus.active,
      ),
      Friend(
        id: 'user_4',
        name: 'Taylor Kim',
        avatar: 'U4',
        level: 9,
        xp: 12400,
        streak: 6,
        isOnline: false,
        lastActive: DateTime.now().subtract(const Duration(hours: 1)),
        status: FriendStatus.away,
      ),
      Friend(
        id: 'user_11',
        name: 'Drew Foster',
        avatar: 'U11',
        level: 8,
        xp: 10500,
        streak: 4,
        isOnline: true,
        lastActive: DateTime.now(),
        status: FriendStatus.active,
      ),
      Friend(
        id: 'user_12',
        name: 'Skyler Reed',
        avatar: 'U12',
        level: 7,
        xp: 8800,
        streak: 3,
        isOnline: false,
        lastActive: DateTime.now().subtract(const Duration(days: 1)),
        status: FriendStatus.offline,
      ),
    ];
  }

  SocialStats _generateSocialStats() {
    return const SocialStats(
      totalFriends: 4,
      onlineFriends: 2,
      pendingRequests: 3,
      totalBadges: 6,
      rareBadges: 1,
      totalXP: 8900,
      averageXPPerFriend: 11250,
      rankAmongFriends: 1,
    );
  }

  List<SocialPost> _generateMockPosts() {
    return [
      SocialPost(
        id: 'post_1',
        userId: 'user_2',
        userName: 'Sam Chen',
        userAvatar: 'U2',
        content: 'Just completed the Flutter State Management lesson! Feeling confident with Provider and Riverpod now 🚀',
        likes: 12,
        comments: 3,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        comments: [
          SocialComment(
            id: 'c1',
            postId: 'post_1',
            userId: 'user_1',
            userName: 'Alex Rivera',
            userAvatar: 'U1',
            content: 'Nice work! Which one do you prefer?',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ],
      ),
      SocialPost(
        id: 'post_2',
        userId: 'user_4',
        userName: 'Taylor Kim',
        userAvatar: 'U4',
        content: 'My streak is at 6 days! Going strong for the week warrior badge 🔥',
        likes: 8,
        comments: 1,
        isLiked: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      SocialPost(
        id: 'post_3',
        userId: 'user_3',
        userName: 'Jordan Lee',
        userAvatar: 'U3',
        content: 'Finally solved the cybersecurity challenge. That SQL injection trick was tricky!',
        likes: 15,
        comments: 5,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  List<AchievementProgress> _generateAchievementProgress() {
    return [
      AchievementProgress(
        achievementId: 'first_commit',
        name: 'First Commit',
        description: 'Complete your very first lesson',
        icon: '🚀',
        color: AppColors.primaryBlue,
        currentProgress: 1,
        targetProgress: 1,
        xpReward: 100,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      AchievementProgress(
        achievementId: 'bug_squasher',
        name: 'Bug Squasher',
        description: 'Solve 10 challenge quizzes',
        icon: '🐛',
        color: AppColors.primaryGreen,
        currentProgress: 7,
        targetProgress: 10,
        xpReward: 200,
        isUnlocked: false,
      ),
      AchievementProgress(
        achievementId: 'week_warrior',
        name: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        icon: '🔥',
        color: AppColors.primaryOrange,
        currentProgress: 6,
        targetProgress: 7,
        xpReward: 200,
        isUnlocked: false,
      ),
      AchievementProgress(
        achievementId: 'polyglot',
        name: 'Polyglot',
        description: 'Learn 3 different categories',
        icon: '🌐',
        color: AppColors.primaryPurple,
        currentProgress: 2,
        targetProgress: 3,
        xpReward: 300,
        isUnlocked: false,
      ),
      AchievementProgress(
        achievementId: 'speed_runner',
        name: 'Speed Runner',
        description: 'Complete a quiz in under 5 minutes',
        icon: '⚡',
        color: AppColors.primaryYellow,
        currentProgress: 0,
        targetProgress: 1,
        xpReward: 150,
        isUnlocked: false,
      ),
      AchievementProgress(
        achievementId: 'monthly_master',
        name: 'Monthly Master',
        description: 'Stay active for 30 days',
        icon: '🏆',
        color: AppColors.primaryCyan,
        currentProgress: 12,
        targetProgress: 30,
        xpReward: 500,
        isUnlocked: false,
      ),
    ];
  }

  List<Badge> get userBadges => _achievementProgress
      .where((a) => a.isUnlocked)
      .map((a) => Badge(
        id: a.achievementId,
        name: a.name,
        description: a.description,
        icon: a.icon,
        color: a.color,
        xpReward: a.xpReward,
        category: 'Learning',
        earnedAt: a.unlockedAt,
        isRare: a.xpReward >= 300,
        rarityLevel: a.xpReward >= 500 ? 5 : a.xpReward >= 300 ? 4 : 1,
      ))
      .toList();

  @override
  void dispose() {
    super.dispose();
  }
}

class SocialDataService {
  static List<UserProfile> get suggestedUsers => [
    UserProfile(
      id: 'user_13',
      name: 'Jordan Hayes',
      email: 'jordan@codebro.dev',
      avatar: 'U13',
      level: 5,
      xp: 6200,
      rank: 10,
      streak: 1,
      lessonsCompleted: 24,
      quizzesCompleted: 12,
      badgesEarned: 2,
      accuracy: 78.0,
      joinedAt: DateTime(2024, 3, 1),
      lastActive: DateTime.now().subtract(const Duration(hours: 4)),
      isOnline: true,
      bio: 'Learning Python and Web Dev',
      location: 'Austin, TX',
      website: 'https://jordan.dev',
    ),
    UserProfile(
      id: 'user_14',
      name: 'Parker Sullivan',
      email: 'parker@codebro.dev',
      avatar: 'U14',
      level: 6,
      xp: 7500,
      rank: 9,
      streak: 0,
      lessonsCompleted: 32,
      quizzesCompleted: 18,
      badgesEarned: 3,
      accuracy: 82.5,
      joinedAt: DateTime(2024, 2, 20),
      lastActive: DateTime.now().subtract(const Duration(days: 2)),
      bio: 'Cybersecurity enthusiast',
      location: 'New York, NY',
      website: 'https://parker.security',
    ),
    UserProfile(
      id: 'user_15',
      name: 'Skyler Reed',
      email: 'skyler@codebro.dev',
      avatar: 'U15',
      level: 7,
      xp: 8800,
      rank: 8,
      streak: 3,
      lessonsCompleted: 40,
      quizzesCompleted: 22,
      badgesEarned: 4,
      accuracy: 88.0,
      joinedAt: DateTime(2024, 1, 10),
      lastActive: DateTime.now().subtract(const Duration(days: 1)),
      bio: 'Full-stack developer',
      location: 'Seattle, WA',
      website: 'https://skyler.codes',
    ),
  ];

  static List<String> get shareMessages => [
    'I just earned +50 XP on CodeBro! Join me in learning to code 🚀',
    'My streak is at 12 days! CodeBro keeps me motivated 🔥',
    'Just unlocked the Bug Squasher badge! 10 challenges down 🐛',
    'Completed Flutter Basics lesson! Ready for the next challenge 💻',
    'Level 7 Senior Developer on CodeBro! The journey continues 📈',
  ];

  static ShareContent createShareContent({
    required String type,
    required String title,
    required String description,
  }) {
    return ShareContent(
      type: type,
      title: title,
      description: description,
      imageUrl: 'https://codebro.dev/share-preview.png',
      shareUrl: 'https://codebro.dev/share',
      metadata: {
        'shared_at': DateTime.now().toIso8601String(),
        'platform': 'mobile',
      },
    );
  }
}
