class CourseModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String thumbnail;
  final int lessonsCount;
  final int level;
  final double rating;
  final int enrolledCount;
  final bool isFeatured;
  final bool isNew;
  final bool isLocked;
  final String unlockRequirement;
  final int xpReward;
  final int estimatedMinutes;
  final List<String> tags;
  final List<String> prerequisites;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String instructorId;
  final String instructorName;
  final Map<String, dynamic> metadata;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.lessonsCount,
    required this.level,
    required this.rating,
    required this.enrolledCount,
    this.isFeatured = false,
    this.isNew = false,
    this.isLocked = false,
    this.unlockRequirement = '',
    required this.xpReward,
    required this.estimatedMinutes,
    this.tags = const [],
    this.prerequisites = const [],
    required this.createdAt,
    required this.updatedAt,
    required this.instructorId,
    required this.instructorName,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'thumbnail': thumbnail,
        'lessonsCount': lessonsCount,
        'level': level,
        'rating': rating,
        'enrolledCount': enrolledCount,
        'isFeatured': isFeatured,
        'isNew': isNew,
        'isLocked': isLocked,
        'unlockRequirement': unlockRequirement,
        'xpReward': xpReward,
        'estimatedMinutes': estimatedMinutes,
        'tags': tags,
        'prerequisites': prerequisites,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'instructorId': instructorId,
        'instructorName': instructorName,
        'metadata': metadata,
      };

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        category: json['category'] as String,
        thumbnail: json['thumbnail'] as String? ?? '',
        lessonsCount: json['lessonsCount'] as int? ?? 0,
        level: json['level'] as int? ?? 1,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        enrolledCount: json['enrolledCount'] as int? ?? 0,
        isFeatured: json['isFeatured'] as bool? ?? false,
        isNew: json['isNew'] as bool? ?? false,
        isLocked: json['isLocked'] as bool? ?? false,
        unlockRequirement: json['unlockRequirement'] as String? ?? '',
        xpReward: json['xpReward'] as int? ?? 0,
        estimatedMinutes: json['estimatedMinutes'] as int? ?? 0,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        prerequisites: (json['prerequisites'] as List<dynamic>?)?.cast<String>() ?? [],
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        instructorId: json['instructorId'] as String? ?? '',
        instructorName: json['instructorName'] as String? ?? '',
        metadata: (json['metadata'] as Map<String, dynamic>?)?.cast<String, dynamic>() ?? {},
      );

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? thumbnail,
    int? lessonsCount,
    int? level,
    double? rating,
    int? enrolledCount,
    bool? isFeatured,
    bool? isNew,
    bool? isLocked,
    String? unlockRequirement,
    int? xpReward,
    int? estimatedMinutes,
    List<String>? tags,
    List<String>? prerequisites,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? instructorId,
    String? instructorName,
    Map<String, dynamic>? metadata,
  }) =>
      CourseModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        thumbnail: thumbnail ?? this.thumbnail,
        lessonsCount: lessonsCount ?? this.lessonsCount,
        level: level ?? this.level,
        rating: rating ?? this.rating,
        enrolledCount: enrolledCount ?? this.enrolledCount,
        isFeatured: isFeatured ?? this.isFeatured,
        isNew: isNew ?? this.isNew,
        isLocked: isLocked ?? this.isLocked,
        unlockRequirement: unlockRequirement ?? this.unlockRequirement,
        xpReward: xpReward ?? this.xpReward,
        estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
        tags: tags ?? this.tags,
        prerequisites: prerequisites ?? this.prerequisites,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        instructorId: instructorId ?? this.instructorId,
        instructorName: instructorName ?? this.instructorName,
        metadata: metadata ?? this.metadata,
      );
}

class LessonModel {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String content;
  final String codeExample;
  final String explanation;
  final int order;
  final int xpReward;
  final int estimatedMinutes;
  final bool isLocked;
  final bool isCompleted;
  final LessonType type;
  final List<String> tags;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.content,
    required this.codeExample,
    required this.explanation,
    required this.order,
    required this.xpReward,
    required this.estimatedMinutes,
    this.isLocked = false,
    this.isCompleted = false,
    required this.type,
    this.tags = const [],
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'title': title,
        'description': description,
        'content': content,
        'codeExample': codeExample,
        'explanation': explanation,
        'order': order,
        'xpReward': xpReward,
        'estimatedMinutes': estimatedMinutes,
        'isLocked': isLocked,
        'isCompleted': isCompleted,
        'type': type.name,
        'tags': tags,
        'metadata': metadata,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
        id: json['id'] as String,
        courseId: json['courseId'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        content: json['content'] as String? ?? '',
        codeExample: json['codeExample'] as String? ?? '',
        explanation: json['explanation'] as String? ?? '',
        order: json['order'] as int? ?? 0,
        xpReward: json['xpReward'] as int? ?? 0,
        estimatedMinutes: json['estimatedMinutes'] as int? ?? 0,
        isLocked: json['isLocked'] as bool? ?? false,
        isCompleted: json['isCompleted'] as bool? ?? false,
        type: LessonType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => LessonType.theory,
        ),
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        metadata: (json['metadata'] as Map<String, dynamic>?)?.cast<String, dynamic>() ?? {},
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

enum LessonType { theory, code, interactive, quiz, challenge, summary }

class QuizModel {
  final String id;
  final String lessonId;
  final String courseId;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  final int xpReward;
  final int timeLimit;
  final bool isCompleted;
  final double score;
  final int attempts;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuizModel({
    required this.id,
    required this.lessonId,
    required this.courseId,
    required this.title,
    required this.description,
    required this.questions,
    required this.xpReward,
    required this.timeLimit,
    this.isCompleted = false,
    this.score = 0.0,
    this.attempts = 0,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'lessonId': lessonId,
        'courseId': courseId,
        'title': title,
        'description': description,
        'questions': questions.map((q) => q.toJson()).toList(),
        'xpReward': xpReward,
        'timeLimit': timeLimit,
        'isCompleted': isCompleted,
        'score': score,
        'attempts': attempts,
        'completedAt': completedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        id: json['id'] as String,
        lessonId: json['lessonId'] as String,
        courseId: json['courseId'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        questions: (json['questions'] as List<dynamic>?)
                ?.map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
                .toList() ??
            [],
        xpReward: json['xpReward'] as int? ?? 0,
        timeLimit: json['timeLimit'] as int? ?? 0,
        isCompleted: json['isCompleted'] as bool? ?? false,
        score: (json['score'] as num?)?.toDouble() ?? 0.0,
        attempts: json['attempts'] as int? ?? 0,
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final int points;
  final QuestionType type;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.points,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'options': options,
        'correctIndex': correctIndex,
        'explanation': explanation,
        'points': points,
        'type': type.name,
      };

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
        id: json['id'] as String,
        question: json['question'] as String,
        options: (json['options'] as List<dynamic>).cast<String>(),
        correctIndex: json['correctIndex'] as int,
        explanation: json['explanation'] as String? ?? '',
        points: json['points'] as int? ?? 0,
        type: QuestionType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => QuestionType.multipleChoice,
        ),
      );
}

enum QuestionType { multipleChoice, trueFalse, fillBlank, codeOutput, codeFix }

class ProgressModel {
  final String id;
  final String userId;
  final String courseId;
  final String lessonId;
  final double progress;
  final int xpEarned;
  final int timeSpentMinutes;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime startedAt;
  final DateTime updatedAt;

  ProgressModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.lessonId,
    required this.progress,
    required this.xpEarned,
    required this.timeSpentMinutes,
    this.isCompleted = false,
    this.completedAt,
    required this.startedAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'courseId': courseId,
        'lessonId': lessonId,
        'progress': progress,
        'xpEarned': xpEarned,
        'timeSpentMinutes': timeSpentMinutes,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
        'startedAt': startedAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ProgressModel.fromJson(Map<String, dynamic> json) => ProgressModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        courseId: json['courseId'] as String,
        lessonId: json['lessonId'] as String,
        progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
        xpEarned: json['xpEarned'] as int? ?? 0,
        timeSpentMinutes: json['timeSpentMinutes'] as int? ?? 0,
        isCompleted: json['isCompleted'] as bool? ?? false,
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
        startedAt: DateTime.parse(json['startedAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

class LeaderboardEntryModel {
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

  LeaderboardEntryModel({
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

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'avatar': avatar,
        'level': level,
        'xp': xp,
        'rank': rank,
        'streak': streak,
        'isCurrentUser': isCurrentUser,
        'isFriend': isFriend,
        'lastActive': lastActive.toIso8601String(),
      };

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) => LeaderboardEntryModel(
        userId: json['userId'] as String,
        name: json['name'] as String,
        avatar: json['avatar'] as String,
        level: json['level'] as int,
        xp: json['xp'] as int,
        rank: json['rank'] as int,
        streak: json['streak'] as int,
        isCurrentUser: json['isCurrentUser'] as bool? ?? false,
        isFriend: json['isFriend'] as bool? ?? false,
        lastActive: DateTime.parse(json['lastActive'] as String),
      );
}

class AchievementModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String category;
  final int xpReward;
  final int rarityLevel;
  final bool isRare;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int currentProgress;
  final int targetProgress;

  AchievementModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.xpReward,
    required this.rarityLevel,
    this.isRare = false,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.currentProgress,
    required this.targetProgress,
  });

  double get progressPercent => currentProgress / targetProgress.clamp(1, targetProgress);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'icon': icon,
        'category': category,
        'xpReward': xpReward,
        'rarityLevel': rarityLevel,
        'isRare': isRare,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
        'currentProgress': currentProgress,
        'targetProgress': targetProgress,
      };

  factory AchievementModel.fromJson(Map<String, dynamic> json) => AchievementModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        icon: json['icon'] as String? ?? '',
        category: json['category'] as String? ?? '',
        xpReward: json['xpReward'] as int? ?? 0,
        rarityLevel: json['rarityLevel'] as int? ?? 1,
        isRare: json['isRare'] as bool? ?? false,
        isUnlocked: json['isUnlocked'] as bool? ?? false,
        unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt'] as String) : null,
        currentProgress: json['currentProgress'] as int? ?? 0,
        targetProgress: json['targetProgress'] as int? ?? 1,
      );
}

class SocialPostModel {
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
  final List<SocialCommentModel> commentList;

  SocialPostModel({
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
    this.commentList = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'userName': userName,
        'userAvatar': userAvatar,
        'content': content,
        'imageUrl': imageUrl,
        'likes': likes,
        'comments': comments,
        'isLiked': isLiked,
        'createdAt': createdAt.toIso8601String(),
        'commentList': commentList.map((c) => c.toJson()).toList(),
      };

  factory SocialPostModel.fromJson(Map<String, dynamic> json) => SocialPostModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        userAvatar: json['userAvatar'] as String,
        content: json['content'] as String,
        imageUrl: json['imageUrl'] as String?,
        likes: json['likes'] as int? ?? 0,
        comments: json['comments'] as int? ?? 0,
        isLiked: json['isLiked'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        commentList: (json['commentList'] as List<dynamic>?)
                ?.map((c) => SocialCommentModel.fromJson(c as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class SocialCommentModel {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createdAt;

  SocialCommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'postId': postId,
        'userId': userId,
        'userName': userName,
        'userAvatar': userAvatar,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SocialCommentModel.fromJson(Map<String, dynamic> json) => SocialCommentModel(
        id: json['id'] as String,
        postId: json['postId'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        userAvatar: json['userAvatar'] as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class FriendModel {
  final String id;
  final String name;
  final String avatar;
  final int level;
  final int xp;
  final int streak;
  final bool isOnline;
  final DateTime lastActive;
  final FriendStatus status;

  FriendModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.level,
    required this.xp,
    required this.streak,
    this.isOnline = false,
    required this.lastActive,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
        'level': level,
        'xp': xp,
        'streak': streak,
        'isOnline': isOnline,
        'lastActive': lastActive.toIso8601String(),
        'status': status.name,
      };

  factory FriendModel.fromJson(Map<String, dynamic> json) => FriendModel(
        id: json['id'] as String,
        name: json['name'] as String,
        avatar: json['avatar'] as String,
        level: json['level'] as int,
        xp: json['xp'] as int,
        streak: json['streak'] as int,
        isOnline: json['isOnline'] as bool? ?? false,
        lastActive: DateTime.parse(json['lastActive'] as String),
        status: FriendStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => FriendStatus.active,
        ),
      );
}

enum FriendStatus { active, away, offline, pending, blocked }

class FriendRequestModel {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String fromUserAvatar;
  final DateTime sentAt;
  final FriendRequestStatus status;

  FriendRequestModel({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    required this.fromUserAvatar,
    required this.sentAt,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fromUserId': fromUserId,
        'fromUserName': fromUserName,
        'fromUserAvatar': fromUserAvatar,
        'sentAt': sentAt.toIso8601String(),
        'status': status.name,
      };

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) => FriendRequestModel(
        id: json['id'] as String,
        fromUserId: json['fromUserId'] as String,
        fromUserName: json['fromUserName'] as String,
        fromUserAvatar: json['fromUserAvatar'] as String,
        sentAt: DateTime.parse(json['sentAt'] as String),
        status: FriendRequestStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => FriendRequestStatus.pending,
        ),
      );
}

enum FriendRequestStatus { pending, accepted, rejected, cancelled }

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final Map<String, dynamic> data;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    this.data = const {},
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
        'type': type.name,
        'isRead': isRead,
        'data': data,
        'createdAt': createdAt.toIso8601String(),
      };

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        type: NotificationType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => NotificationType.general,
        ),
        isRead: json['isRead'] as bool? ?? false,
        data: (json['data'] as Map<String, dynamic>?)?.cast<String, dynamic>() ?? {},
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

enum NotificationType {
  general,
  achievement,
  streak,
  friendRequest,
  courseUpdate,
  quizResult,
  leaderboard,
  system,
  reminder,
  challenge,
  levelUp,
  badge,
  comment,
  like,
  share,
}

class CourseEnrollmentModel {
  final String id;
  final String userId;
  final String courseId;
  final double progress;
  final int xpEarned;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime enrolledAt;
  final DateTime updatedAt;

  CourseEnrollmentModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.progress,
    required this.xpEarned,
    this.isCompleted = false,
    this.completedAt,
    required this.enrolledAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'courseId': courseId,
        'progress': progress,
        'xpEarned': xpEarned,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
        'enrolledAt': enrolledAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CourseEnrollmentModel.fromJson(Map<String, dynamic> json) => CourseEnrollmentModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        courseId: json['courseId'] as String,
        progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
        xpEarned: json['xpEarned'] as int? ?? 0,
        isCompleted: json['isCompleted'] as bool? ?? false,
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
        enrolledAt: DateTime.parse(json['enrolledAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

class CourseReviewModel {
  final String id;
  final String courseId;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseReviewModel({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'userId': userId,
        'userName': userName,
        'userAvatar': userAvatar,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CourseReviewModel.fromJson(Map<String, dynamic> json) => CourseReviewModel(
        id: json['id'] as String,
        courseId: json['courseId'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        userAvatar: json['userAvatar'] as String,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        comment: json['comment'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

class CodeSubmissionModel {
  final String id;
  final String userId;
  final String lessonId;
  final String code;
  final bool isCorrect;
  final String output;
  final int attempts;
  final DateTime submittedAt;

  CodeSubmissionModel({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.code,
    required this.isCorrect,
    required this.output,
    required this.attempts,
    required this.submittedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'lessonId': lessonId,
        'code': code,
        'isCorrect': isCorrect,
        'output': output,
        'attempts': attempts,
        'submittedAt': submittedAt.toIso8601String(),
      };

  factory CodeSubmissionModel.fromJson(Map<String, dynamic> json) => CodeSubmissionModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        lessonId: json['lessonId'] as String,
        code: json['code'] as String,
        isCorrect: json['isCorrect'] as bool? ?? false,
        output: json['output'] as String? ?? '',
        attempts: json['attempts'] as int? ?? 0,
        submittedAt: DateTime.parse(json['submittedAt'] as String),
      );
}

class CodeRunResult {
  final bool success;
  final String output;
  final String? error;
  final int executionTimeMs;
  final int memoryUsedKb;

  CodeRunResult({
    required this.success,
    required this.output,
    this.error,
    required this.executionTimeMs,
    required this.memoryUsedKb,
  });

  Map<String, dynamic> toJson() => {
        'success': success,
        'output': output,
        'error': error,
        'executionTimeMs': executionTimeMs,
        'memoryUsedKb': memoryUsedKb,
      };

  factory CodeRunResult.fromJson(Map<String, dynamic> json) => CodeRunResult(
        success: json['success'] as bool,
        output: json['output'] as String? ?? '',
        error: json['error'] as String?,
        executionTimeMs: json['executionTimeMs'] as int? ?? 0,
        memoryUsedKb: json['memoryUsedKb'] as int? ?? 0,
      );
}

class XPTransactionModel {
  final String id;
  final String userId;
  final int amount;
  final XPTransactionType type;
  final String source;
  final String description;
  final DateTime createdAt;

  XPTransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.source,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'amount': amount,
        'type': type.name,
        'source': source,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
      };

  factory XPTransactionModel.fromJson(Map<String, dynamic> json) => XPTransactionModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        amount: json['amount'] as int,
        type: XPTransactionType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => XPTransactionType.earned,
        ),
        source: json['source'] as String,
        description: json['description'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

enum XPTransactionType { earned, spent, bonus, penalty, refund }

class StreakModel {
  final String userId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final int streakFreezes;
  final bool isActive;

  StreakModel({
    required this.userId,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
    this.streakFreezes = 0,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastActivityDate': lastActivityDate?.toIso8601String(),
        'streakFreezes': streakFreezes,
        'isActive': isActive,
      };

  factory StreakModel.fromJson(Map<String, dynamic> json) => StreakModel(
        userId: json['userId'] as String,
        currentStreak: json['currentStreak'] as int? ?? 0,
        longestStreak: json['longestStreak'] as int? ?? 0,
        lastActivityDate: json['lastActivityDate'] != null ? DateTime.parse(json['lastActivityDate'] as String) : null,
        streakFreezes: json['streakFreezes'] as int? ?? 0,
        isActive: json['isActive'] as bool? ?? true,
      );

  bool get isAtRisk {
    if (lastActivityDate == null) return false;
    final now = DateTime.now();
    final diff = now.difference(lastActivityDate!).inHours;
    return diff >= 24 && diff < 48;
  }

  bool get isBroken {
    if (lastActivityDate == null) return false;
    final now = DateTime.now();
    final diff = now.difference(lastActivityDate!).inHours;
    return diff >= 48;
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final int courseCount;
  final int lessonCount;
  final bool isLocked;
  final int requiredLevel;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.courseCount,
    required this.lessonCount,
    this.isLocked = false,
    this.requiredLevel = 1,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'icon': icon,
        'color': color,
        'courseCount': courseCount,
        'lessonCount': lessonCount,
        'isLocked': isLocked,
        'requiredLevel': requiredLevel,
      };

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        icon: json['icon'] as String? ?? '',
        color: json['color'] as String? ?? '',
        courseCount: json['courseCount'] as int? ?? 0,
        lessonCount: json['lessonCount'] as int? ?? 0,
        isLocked: json['isLocked'] as bool? ?? false,
        requiredLevel: json['requiredLevel'] as int? ?? 1,
      );
}

class TagModel {
  final String id;
  final String name;
  final String color;
  final int usageCount;

  TagModel({
    required this.id,
    required this.name,
    required this.color,
    required this.usageCount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color,
        'usageCount': usageCount,
      };

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
        id: json['id'] as String,
        name: json['name'] as String,
        color: json['color'] as String? ?? '',
        usageCount: json['usageCount'] as int? ?? 0,
      );
}

class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final int difficulty;
  final int xpReward;
  final int timeLimit;
  final String starterCode;
  final String solution;
  final List<String> testCases;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.xpReward,
    required this.timeLimit,
    required this.starterCode,
    required this.solution,
    required this.testCases,
    this.isCompleted = false,
    this.completedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'difficulty': difficulty,
        'xpReward': xpReward,
        'timeLimit': timeLimit,
        'starterCode': starterCode,
        'solution': solution,
        'testCases': testCases,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory ChallengeModel.fromJson(Map<String, dynamic> json) => ChallengeModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        category: json['category'] as String? ?? '',
        difficulty: json['difficulty'] as int? ?? 1,
        xpReward: json['xpReward'] as int? ?? 0,
        timeLimit: json['timeLimit'] as int? ?? 0,
        starterCode: json['starterCode'] as String? ?? '',
        solution: json['solution'] as String? ?? '',
        testCases: (json['testCases'] as List<dynamic>?)?.cast<String>() ?? [],
        isCompleted: json['isCompleted'] as bool? ?? false,
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class DailyChallengeModel {
  final String id;
  final String challengeId;
  final String title;
  final String description;
  final int xpReward;
  final DateTime date;
  final bool isCompleted;
  final int participantCount;

  DailyChallengeModel({
    required this.id,
    required this.challengeId,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.date,
    this.isCompleted = false,
    required this.participantCount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'challengeId': challengeId,
        'title': title,
        'description': description,
        'xpReward': xpReward,
        'date': date.toIso8601String(),
        'isCompleted': isCompleted,
        'participantCount': participantCount,
      };

  factory DailyChallengeModel.fromJson(Map<String, dynamic> json) => DailyChallengeModel(
        id: json['id'] as String,
        challengeId: json['challengeId'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        xpReward: json['xpReward'] as int? ?? 0,
        date: DateTime.parse(json['date'] as String),
        isCompleted: json['isCompleted'] as bool? ?? false,
        participantCount: json['participantCount'] as int? ?? 0,
      );
}

class QuestModel {
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final QuestType type;
  final int target;
  final int progress;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime date;

  QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.type,
    required this.target,
    required this.progress,
    this.isCompleted = false,
    this.completedAt,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'xpReward': xpReward,
        'type': type.name,
        'target': target,
        'progress': progress,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
        'date': date.toIso8601String(),
      };

  factory QuestModel.fromJson(Map<String, dynamic> json) => QuestModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        xpReward: json['xpReward'] as int? ?? 0,
        type: QuestType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => QuestType.lesson,
        ),
        target: json['target'] as int? ?? 1,
        progress: json['progress'] as int? ?? 0,
        isCompleted: json['isCompleted'] as bool? ?? false,
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
        date: DateTime.parse(json['date'] as String),
      );
}

enum QuestType { lesson, quiz, challenge, streak, social, code }

class LessonPathModel {
  final String id;
  final String userId;
  final String courseId;
  final List<LessonPathStep> steps;
  final int currentStep;
  final double progress;

  LessonPathModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.steps,
    required this.currentStep,
    required this.progress,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'courseId': courseId,
        'steps': steps.map((s) => s.toJson()).toList(),
        'currentStep': currentStep,
        'progress': progress,
      };

  factory LessonPathModel.fromJson(Map<String, dynamic> json) => LessonPathModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        courseId: json['courseId'] as String,
        steps: (json['steps'] as List<dynamic>?)
                ?.map((s) => LessonPathStep.fromJson(s as Map<String, dynamic>))
                .toList() ??
            [],
        currentStep: json['currentStep'] as int? ?? 0,
        progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      );
}

class LessonPathStep {
  final String id;
  final String lessonId;
  final String title;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;
  final int order;

  LessonPathStep({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLocked,
    required this.order,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'lessonId': lessonId,
        'title': title,
        'isCompleted': isCompleted,
        'isCurrent': isCurrent,
        'isLocked': isLocked,
        'order': order,
      };

  factory LessonPathStep.fromJson(Map<String, dynamic> json) => LessonPathStep(
        id: json['id'] as String,
        lessonId: json['lessonId'] as String,
        title: json['title'] as String,
        isCompleted: json['isCompleted'] as bool? ?? false,
        isCurrent: json['isCurrent'] as bool? ?? false,
        isLocked: json['isLocked'] as bool? ?? false,
        order: json['order'] as int? ?? 0,
      );
}

class CertificateModel {
  final String id;
  final String userId;
  final String courseId;
  final String courseName;
  final String userName;
  final DateTime issuedAt;
  final String certificateUrl;
  final String verificationCode;

  CertificateModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseName,
    required this.userName,
    required this.issuedAt,
    required this.certificateUrl,
    required this.verificationCode,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'courseId': courseId,
        'courseName': courseName,
        'userName': userName,
        'issuedAt': issuedAt.toIso8601String(),
        'certificateUrl': certificateUrl,
        'verificationCode': verificationCode,
      };

  factory CertificateModel.fromJson(Map<String, dynamic> json) => CertificateModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        courseId: json['courseId'] as String,
        courseName: json['courseName'] as String,
        userName: json['userName'] as String,
        issuedAt: DateTime.parse(json['issuedAt'] as String),
        certificateUrl: json['certificateUrl'] as String? ?? '',
        verificationCode: json['verificationCode'] as String? ?? '',
      );
}

class CourseModuleModel {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int order;
  final List<String> lessonIds;
  final bool isCompleted;
  final DateTime createdAt;

  CourseModuleModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.order,
    required this.lessonIds,
    this.isCompleted = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'title': title,
        'description': description,
        'order': order,
        'lessonIds': lessonIds,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
      };

  factory CourseModuleModel.fromJson(Map<String, dynamic> json) => CourseModuleModel(
        id: json['id'] as String,
        courseId: json['courseId'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        order: json['order'] as int? ?? 0,
        lessonIds: (json['lessonIds'] as List<dynamic>?)?.cast<String>() ?? [],
        isCompleted: json['isCompleted'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class CourseAssignmentModel {
  final String id;
  final String courseId;
  final String moduleId;
  final String title;
  final String description;
  final String instructions;
  final int xpReward;
  final DateTime? dueDate;
  final bool isCompleted;
  final double? grade;
  final String? feedback;
  final DateTime createdAt;

  CourseAssignmentModel({
    required this.id,
    required this.courseId,
    required this.moduleId,
    required this.title,
    required this.description,
    required this.instructions,
    required this.xpReward,
    this.dueDate,
    this.isCompleted = false,
    this.grade,
    this.feedback,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'moduleId': moduleId,
        'title': title,
        'description': description,
        'instructions': instructions,
        'xpReward': xpReward,
        'dueDate': dueDate?.toIso8601String(),
        'isCompleted': isCompleted,
        'grade': grade,
        'feedback': feedback,
        'createdAt': createdAt.toIso8601String(),
      };

  factory CourseAssignmentModel.fromJson(Map<String, dynamic> json) => CourseAssignmentModel(
        id: json['id'] as String,
        courseId: json['courseId'] as String,
        moduleId: json['moduleId'] as String? ?? '',
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        instructions: json['instructions'] as String? ?? '',
        xpReward: json['xpReward'] as int? ?? 0,
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
        isCompleted: json['isCompleted'] as bool? ?? false,
        grade: (json['grade'] as num?)?.toDouble(),
        feedback: json['feedback'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class CourseAnnouncementModel {
  final String id;
  final String courseId;
  final String instructorId;
  final String title;
  final String content;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseAnnouncementModel({
    required this.id,
    required this.courseId,
    required this.instructorId,
    required this.title,
    required this.content,
    this.isPinned = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'instructorId': instructorId,
        'title': title,
        'content': content,
        'isPinned': isPinned,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CourseAnnouncementModel.fromJson(Map<String, dynamic> json) => CourseAnnouncementModel(
        id: json['id'] as String,
        courseId: json['courseId'] as String,
        instructorId: json['instructorId'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        isPinned: json['isPinned'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

class CourseDiscussionModel {
  final String id;
  final String courseId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String title;
  final String content;
  final int likes;
  final int replies;
  final bool isLiked;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseDiscussionModel({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.title,
    required this.content,
    this.likes = 0,
    this.replies = 0,
    this.isLiked = false,
    this.isPinned = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'userId': userId,
        'userName': userName,
        'userAvatar': userAvatar,
        'title': title,
        'content': content,
        'likes': likes,
        'replies': replies,
        'isLiked': isLiked,
        'isPinned': isPinned,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CourseDiscussionModel.fromJson(Map<String, dynamic> json) => CourseDiscussionModel(
        id: json['id'] as String,
        courseId: json['courseId'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        userAvatar: json['userAvatar'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        likes: json['likes'] as int? ?? 0,
        replies: json['replies'] as int? ?? 0,
        isLiked: json['isLiked'] as bool? ?? false,
        isPinned: json['isPinned'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

class CourseDiscussionReplyModel {
  final String id;
  final String discussionId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final int likes;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseDiscussionReplyModel({
    required this.id,
    required this.discussionId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.likes = 0,
    this.isLiked = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'discussionId': discussionId,
        'userId': userId,
        'userName': userName,
        'userAvatar': userAvatar,
        'content': content,
        'likes': likes,
        'isLiked': isLiked,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CourseDiscussionReplyModel.fromJson(Map<String, dynamic> json) => CourseDiscussionReplyModel(
        id: json['id'] as String,
        discussionId: json['discussionId'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        userAvatar: json['userAvatar'] as String,
        content: json['content'] as String,
        likes: json['likes'] as int? ?? 0,
        isLiked: json['isLiked'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

class CourseDiscussionReportModel {
  final String id;
  final String discussionId;
  final String userId;
  final String reason;
  final String details;
  final String status;
  final String? adminNotes;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  CourseDiscussionReportModel({
    required this.id,
    required this.discussionId,
    required this.userId,
    required this.reason,
    required this.details,
    required this.status,
    this.adminNotes,
    required this.createdAt,
    this.resolvedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'discussionId': discussionId,
        'userId': userId,
        'reason': reason,
        'details': details,
        'status': status,
        'adminNotes': adminNotes,
        'createdAt': createdAt.toIso8601String(),
        'resolvedAt': resolvedAt?.toIso8601String(),
      };

  factory CourseDiscussionReportModel.fromJson(Map<String, dynamic> json) => CourseDiscussionReportModel(
        id: json['id'] as String,
        discussionId: json['discussionId'] as String,
        userId: json['userId'] as String,
        reason: json['reason'] as String,
        details: json['details'] as String? ?? '',
        status: json['status'] as String? ?? 'pending',
        adminNotes: json['adminNotes'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt'] as String) : null,
      );
}

class UserBadgeModel {
  final String id;
  final String userId;
  final String achievementId;
  final String name;
  final String description;
  final String icon;
  final int xpReward;
  final int rarityLevel;
  final DateTime unlockedAt;

  UserBadgeModel({
    required this.id,
    required this.userId,
    required this.achievementId,
    required this.name,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.rarityLevel,
    required this.unlockedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'achievementId': achievementId,
        'name': name,
        'description': description,
        'icon': icon,
        'xpReward': xpReward,
        'rarityLevel': rarityLevel,
        'unlockedAt': unlockedAt.toIso8601String(),
      };

  factory UserBadgeModel.fromJson(Map<String, dynamic> json) => UserBadgeModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        achievementId: json['achievementId'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        icon: json['icon'] as String? ?? '',
        xpReward: json['xpReward'] as int? ?? 0,
        rarityLevel: json['rarityLevel'] as int? ?? 1,
        unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      );
}

class UserSettingsModel {
  final String userId;
  final bool notificationsEnabled;
  final bool darkMode;
  final String language;
  final String theme;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool soundEffects;
  final double fontSize;
  final bool autoPlayVideos;
  final bool showCompletedLessons;
  final bool showProgressBars;
  final bool hapticFeedback;
  final bool reducedMotion;

  UserSettingsModel({
    required this.userId,
    this.notificationsEnabled = true,
    this.darkMode = true,
    this.language = 'en',
    this.theme = 'dark',
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.soundEffects = true,
    this.fontSize = 16.0,
    this.autoPlayVideos = true,
    this.showCompletedLessons = true,
    this.showProgressBars = true,
    this.hapticFeedback = true,
    this.reducedMotion = false,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'notificationsEnabled': notificationsEnabled,
        'darkMode': darkMode,
        'language': language,
        'theme': theme,
        'emailNotifications': emailNotifications,
        'pushNotifications': pushNotifications,
        'soundEffects': soundEffects,
        'fontSize': fontSize,
        'autoPlayVideos': autoPlayVideos,
        'showCompletedLessons': showCompletedLessons,
        'showProgressBars': showProgressBars,
        'hapticFeedback': hapticFeedback,
        'reducedMotion': reducedMotion,
      };

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) => UserSettingsModel(
        userId: json['userId'] as String,
        notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
        darkMode: json['darkMode'] as bool? ?? true,
        language: json['language'] as String? ?? 'en',
        theme: json['theme'] as String? ?? 'dark',
        emailNotifications: json['emailNotifications'] as bool? ?? true,
        pushNotifications: json['pushNotifications'] as bool? ?? true,
        soundEffects: json['soundEffects'] as bool? ?? true,
        fontSize: (json['fontSize'] as num?)?.toDouble() ?? 16.0,
        autoPlayVideos: json['autoPlayVideos'] as bool? ?? true,
        showCompletedLessons: json['showCompletedLessons'] as bool? ?? true,
        showProgressBars: json['showProgressBars'] as bool? ?? true,
        hapticFeedback: json['hapticFeedback'] as bool? ?? true,
        reducedMotion: json['reducedMotion'] as bool? ?? false,
      );
}

class UserActivityModel {
  final String id;
  final String userId;
  final ActivityType type;
  final String description;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  UserActivityModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    this.metadata = const {},
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'type': type.name,
        'description': description,
        'metadata': metadata,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserActivityModel.fromJson(Map<String, dynamic> json) => UserActivityModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        type: ActivityType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => ActivityType.other,
        ),
        description: json['description'] as String,
        metadata: (json['metadata'] as Map<String, dynamic>?)?.cast<String, dynamic>() ?? {},
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

enum ActivityType {
  lessonCompleted,
  quizCompleted,
  challengeCompleted,
  courseEnrolled,
  courseCompleted,
  achievementUnlocked,
  levelUp,
  streakUpdated,
  friendAdded,
  postCreated,
  commentAdded,
  login,
  logout,
  profileUpdated,
  settingsUpdated,
  other,
}

class UserAnalyticsModel {
  final String userId;
  final int totalLessons;
  final int totalQuizzes;
  final int totalChallenges;
  final int totalCourses;
  final int totalXp;
  final int currentStreak;
  final int longestStreak;
  final double averageAccuracy;
  final int totalTimeSpentMinutes;
  final Map<String, int> categoryBreakdown;
  final Map<String, int> weeklyActivity;
  final DateTime lastActive;

  UserAnalyticsModel({
    required this.userId,
    required this.totalLessons,
    required this.totalQuizzes,
    required this.totalChallenges,
    required this.totalCourses,
    required this.totalXp,
    required this.currentStreak,
    required this.longestStreak,
    required this.averageAccuracy,
    required this.totalTimeSpentMinutes,
    required this.categoryBreakdown,
    required this.weeklyActivity,
    required this.lastActive,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'totalLessons': totalLessons,
        'totalQuizzes': totalQuizzes,
        'totalChallenges': totalChallenges,
        'totalCourses': totalCourses,
        'totalXp': totalXp,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'averageAccuracy': averageAccuracy,
        'totalTimeSpentMinutes': totalTimeSpentMinutes,
        'categoryBreakdown': categoryBreakdown,
        'weeklyActivity': weeklyActivity,
        'lastActive': lastActive.toIso8601String(),
      };

  factory UserAnalyticsModel.fromJson(Map<String, dynamic> json) => UserAnalyticsModel(
        userId: json['userId'] as String,
        totalLessons: json['totalLessons'] as int? ?? 0,
        totalQuizzes: json['totalQuizzes'] as int? ?? 0,
        totalChallenges: json['totalChallenges'] as int? ?? 0,
        totalCourses: json['totalCourses'] as int? ?? 0,
        totalXp: json['totalXp'] as int? ?? 0,
        currentStreak: json['currentStreak'] as int? ?? 0,
        longestStreak: json['longestStreak'] as int? ?? 0,
        averageAccuracy: (json['averageAccuracy'] as num?)?.toDouble() ?? 0.0,
        totalTimeSpentMinutes: json['totalTimeSpentMinutes'] as int? ?? 0,
        categoryBreakdown: (json['categoryBreakdown'] as Map<String, dynamic>?)?.cast<String, int>() ?? {},
        weeklyActivity: (json['weeklyActivity'] as Map<String, dynamic>?)?.cast<String, int>() ?? {},
        lastActive: DateTime.parse(json['lastActive'] as String),
      );
}
