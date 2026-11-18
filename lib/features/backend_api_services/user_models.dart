import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String name;
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
  final String passwordHash;
  final String salt;
  final String role;
  final bool isEmailVerified;
  final DateTime? emailVerifiedAt;
  final String? resetPasswordToken;
  final DateTime? resetPasswordExpiresAt;
  final List<String> notifications;
  final Map<String, bool> settings;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
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
    required this.passwordHash,
    required this.salt,
    this.role = 'user',
    this.isEmailVerified = false,
    this.emailVerifiedAt,
    this.resetPasswordToken,
    this.resetPasswordExpiresAt,
    this.notifications = const [],
    this.settings = const {},
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

  bool get isAdmin => role == 'admin';
  bool get isModerator => role == 'moderator' || role == 'admin';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'level': level,
      'xp': xp,
      'rank': rank,
      'streak': streak,
      'lessonsCompleted': lessonsCompleted,
      'quizzesCompleted': quizzesCompleted,
      'badgesEarned': badgesEarned,
      'accuracy': accuracy,
      'joinedAt': joinedAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'isOnline': isOnline,
      'friends': friends,
      'badges': badges,
      'stats': stats,
      'bio': bio,
      'location': location,
      'website': website,
      'passwordHash': passwordHash,
      'salt': salt,
      'role': role,
      'isEmailVerified': isEmailVerified,
      'emailVerifiedAt': emailVerifiedAt?.toIso8601String(),
      'resetPasswordToken': resetPasswordToken,
      'resetPasswordExpiresAt': resetPasswordExpiresAt?.toIso8601String(),
      'notifications': notifications,
      'settings': settings,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      level: json['level'] as int,
      xp: json['xp'] as int,
      rank: json['rank'] as int,
      streak: json['streak'] as int,
      lessonsCompleted: json['lessonsCompleted'] as int,
      quizzesCompleted: json['quizzesCompleted'] as int,
      badgesEarned: json['badgesEarned'] as int,
      accuracy: (json['accuracy'] as num).toDouble(),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      lastActive: DateTime.parse(json['lastActive'] as String),
      isOnline: json['isOnline'] as bool? ?? false,
      friends: (json['friends'] as List<dynamic>?)?.cast<String>() ?? [],
      badges: (json['badges'] as List<dynamic>?)?.cast<String>() ?? [],
      stats: (json['stats'] as Map<String, dynamic>?)?.cast<String, dynamic>() ?? {},
      bio: json['bio'] as String? ?? '',
      location: json['location'] as String? ?? '',
      website: json['website'] as String? ?? '',
      passwordHash: json['passwordHash'] as String? ?? '',
      salt: json['salt'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      emailVerifiedAt: json['emailVerifiedAt'] != null ? DateTime.parse(json['emailVerifiedAt'] as String) : null,
      resetPasswordToken: json['resetPasswordToken'] as String?,
      resetPasswordExpiresAt: json['resetPasswordExpiresAt'] != null ? DateTime.parse(json['resetPasswordExpiresAt'] as String) : null,
      notifications: (json['notifications'] as List<dynamic>?)?.cast<String>() ?? [],
      settings: (json['settings'] as Map<String, dynamic>?)?.cast<String, bool>() ?? {},
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
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
    String? passwordHash,
    String? salt,
    String? role,
    bool? isEmailVerified,
    DateTime? emailVerifiedAt,
    String? resetPasswordToken,
    DateTime? resetPasswordExpiresAt,
    List<String>? notifications,
    Map<String, bool>? settings,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
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
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      resetPasswordToken: resetPasswordToken ?? this.resetPasswordToken,
      resetPasswordExpiresAt: resetPasswordExpiresAt ?? this.resetPasswordExpiresAt,
      notifications: notifications ?? this.notifications,
      settings: settings ?? this.settings,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, name: $name, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

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
  final String bio;
  final String location;
  final String website;
  final DateTime joinedAt;
  final DateTime lastActive;
  final bool isOnline;

  UserProfile({
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
    required this.bio,
    required this.location,
    required this.website,
    required this.joinedAt,
    required this.lastActive,
    this.isOnline = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'level': level,
      'xp': xp,
      'rank': rank,
      'streak': streak,
      'lessonsCompleted': lessonsCompleted,
      'quizzesCompleted': quizzesCompleted,
      'badgesEarned': badgesEarned,
      'accuracy': accuracy,
      'bio': bio,
      'location': location,
      'website': website,
      'joinedAt': joinedAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'isOnline': isOnline,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      level: json['level'] as int,
      xp: json['xp'] as int,
      rank: json['rank'] as int,
      streak: json['streak'] as int,
      lessonsCompleted: json['lessonsCompleted'] as int,
      quizzesCompleted: json['quizzesCompleted'] as int,
      badgesEarned: json['badgesEarned'] as int,
      accuracy: (json['accuracy'] as num).toDouble(),
      bio: json['bio'] as String? ?? '',
      location: json['location'] as String? ?? '',
      website: json['website'] as String? ?? '',
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      lastActive: DateTime.parse(json['lastActive'] as String),
      isOnline: json['isOnline'] as bool? ?? false,
    );
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
    String? bio,
    String? location,
    String? website,
    DateTime? joinedAt,
    DateTime? lastActive,
    bool? isOnline,
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
      bio: bio ?? this.bio,
      location: location ?? this.location,
      website: website ?? this.website,
      joinedAt: joinedAt ?? this.joinedAt,
      lastActive: lastActive ?? this.lastActive,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  String toString() => 'UserProfile(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class UserRegistrationRequest {
  final String email;
  final String password;
  final String name;
  final String confirmPassword;

  UserRegistrationRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'confirmPassword': confirmPassword,
    };
  }

  factory UserRegistrationRequest.fromJson(Map<String, dynamic> json) {
    return UserRegistrationRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );
  }

  bool get isValid {
    return email.isNotEmpty &&
        password.isNotEmpty &&
        name.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;
  }

  List<String> get validationErrors {
    final errors = <String>[];
    if (email.isEmpty) errors.add('Email is required');
    if (password.isEmpty) errors.add('Password is required');
    if (name.isEmpty) errors.add('Name is required');
    if (confirmPassword.isEmpty) errors.add('Confirm password is required');
    if (password != confirmPassword) errors.add('Passwords do not match');
    return errors;
  }
}

class UserLoginRequest {
  final String email;
  final String password;
  final bool rememberMe;

  UserLoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'rememberMe': rememberMe,
    };
  }

  factory UserLoginRequest.fromJson(Map<String, dynamic> json) {
    return UserLoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      rememberMe: json['rememberMe'] as bool? ?? false,
    );
  }

  bool get isValid {
    return email.isNotEmpty && password.isNotEmpty;
  }

  List<String> get validationErrors {
    final errors = <String>[];
    if (email.isEmpty) errors.add('Email is required');
    if (password.isEmpty) errors.add('Password is required');
    return errors;
  }
}

class AuthResponse {
  final String token;
  final String refreshToken;
  final UserModel user;
  final DateTime expiresAt;

  AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'user': user.toJson(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  Duration get timeUntilExpiry {
    return expiresAt.difference(DateTime.now());
  }
}

class AuthLoginResponse {
  final String token;
  final UserModel user;

  AuthLoginResponse({
    required this.token,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }

  factory AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    return AuthLoginResponse(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class AuthRegisterResponse {
  final String token;
  final UserModel user;

  AuthRegisterResponse({
    required this.token,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }

  factory AuthRegisterResponse.fromJson(Map<String, dynamic> json) {
    return AuthRegisterResponse(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    return ChangePasswordRequest(
      currentPassword: json['currentPassword'] as String,
      newPassword: json['newPassword'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );
  }

  bool get isValid {
    return currentPassword.isNotEmpty &&
        newPassword.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        newPassword == confirmPassword;
  }

  List<String> get validationErrors {
    final errors = <String>[];
    if (currentPassword.isEmpty) errors.add('Current password is required');
    if (newPassword.isEmpty) errors.add('New password is required');
    if (confirmPassword.isEmpty) errors.add('Confirm password is required');
    if (newPassword != confirmPassword) errors.Add('Passwords do not match');
    return errors;
  }
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordRequest(
      email: json['email'] as String,
    );
  }

  bool get isValid {
    return email.isNotEmpty;
  }
}

class ResetPasswordRequest {
  final String token;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequest({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequest(
      token: json['token'] as String,
      newPassword: json['newPassword'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );
  }

  bool get isValid {
    return token.isNotEmpty &&
        newPassword.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        newPassword == confirmPassword;
  }

  List<String> get validationErrors {
    final errors = <String>[];
    if (token.isEmpty) errors.add('Token is required');
    if (newPassword.isEmpty) errors.add('New password is required');
    if (confirmPassword.isEmpty) errors.add('Confirm password is required');
    if (newPassword != confirmPassword) errors.add('Passwords do not match');
    return errors;
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) {
    return RefreshTokenRequest(
      refreshToken: json['refreshToken'] as String,
    );
  }
}

class LogoutRequest {
  final String refreshToken;

  LogoutRequest({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }

  factory LogoutRequest.fromJson(Map<String, dynamic> json) {
    return LogoutRequest(
      refreshToken: json['refreshToken'] as String,
    );
  }
}

class UpdateProfileRequest {
  final String name;
  final String bio;
  final String location;
  final String website;
  final String avatar;

  UpdateProfileRequest({
    required this.name,
    required this.bio,
    required this.location,
    required this.website,
    required this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'location': location,
      'website': website,
      'avatar': avatar,
    };
  }

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProfileRequest(
      name: json['name'] as String,
      bio: json['bio'] as String,
      location: json['location'] as String,
      website: json['website'] as String,
      avatar: json['avatar'] as String,
    );
  }
}

class UpdateSettingsRequest {
  final bool notifications;
  final bool darkMode;
  final String language;

  UpdateSettingsRequest({
    required this.notifications,
    required this.darkMode,
    required this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications,
      'darkMode': darkMode,
      'language': language,
    };
  }

  factory UpdateSettingsRequest.fromJson(Map<String, dynamic> json) {
    return UpdateSettingsRequest(
      notifications: json['notifications'] as bool,
      darkMode: json['darkMode'] as bool,
      language: json['language'] as String,
    );
  }
}

class UserStats {
  final int lessonsCompleted;
  final int quizzesCompleted;
  final int badgesEarned;
  final double accuracy;
  final int totalXp;
  final int currentStreak;
  final int longestStreak;
  final int timeSpentMinutes;
  final DateTime lastLessonDate;
  final Map<String, int> categoryStats;

  UserStats({
    required this.lessonsCompleted,
    required this.quizzesCompleted,
    required this.badgesEarned,
    required this.accuracy,
    required this.totalXp,
    required this.currentStreak,
    required this.longestStreak,
    required this.timeSpentMinutes,
    required this.lastLessonDate,
    this.categoryStats = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'lessonsCompleted': lessonsCompleted,
      'quizzesCompleted': quizzesCompleted,
      'badgesEarned': badgesEarned,
      'accuracy': accuracy,
      'totalXp': totalXp,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'timeSpentMinutes': timeSpentMinutes,
      'lastLessonDate': lastLessonDate.toIso8601String(),
      'categoryStats': categoryStats,
    };
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      lessonsCompleted: json['lessonsCompleted'] as int,
      quizzesCompleted: json['quizzesCompleted'] as int,
      badgesEarned: json['badgesEarned'] as int,
      accuracy: (json['accuracy'] as num).toDouble(),
      totalXp: json['totalXp'] as int,
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      timeSpentMinutes: json['timeSpentMinutes'] as int,
      lastLessonDate: DateTime.parse(json['lastLessonDate'] as String),
      categoryStats: (json['categoryStats'] as Map<String, dynamic>?)?.cast<String, int>() ?? {},
    );
  }
}

class UserPreferences {
  final bool notificationsEnabled;
  final bool darkMode;
  final String language;
  final String theme;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool soundEffects;
  final double fontSize;

  UserPreferences({
    this.notificationsEnabled = true,
    this.darkMode = true,
    this.language = 'en',
    this.theme = 'dark',
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.soundEffects = true,
    this.fontSize = 16.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'darkMode': darkMode,
      'language': language,
      'theme': theme,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'soundEffects': soundEffects,
      'fontSize': fontSize,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      darkMode: json['darkMode'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      theme: json['theme'] as String? ?? 'dark',
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      soundEffects: json['soundEffects'] as bool? ?? true,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 16.0,
    );
  }
}

class UserSession {
  final String sessionId;
  final String userId;
  final String token;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String ipAddress;
  final String userAgent;
  final String deviceInfo;
  final bool isActive;

  UserSession({
    required this.sessionId,
    required this.userId,
    required this.token,
    required this.createdAt,
    required this.expiresAt,
    required this.ipAddress,
    required this.userAgent,
    required this.deviceInfo,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'token': token,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'deviceInfo': deviceInfo,
      'isActive': isActive,
    };
  }

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      token: json['token'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      ipAddress: json['ipAddress'] as String,
      userAgent: json['userAgent'] as String,
      deviceInfo: json['deviceInfo'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  Duration get timeUntilExpiry {
    return expiresAt.difference(DateTime.now());
  }
}

class AuthToken {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String userId;

  AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      userId: json['userId'] as String,
    );
  }

  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  Duration get timeUntilExpiry {
    return expiresAt.difference(DateTime.now());
  }
}

class JwtPayload {
  final String userId;
  final String email;
  final String role;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final Map<String, dynamic> claims;

  JwtPayload({
    required this.userId,
    required this.email,
    required this.role,
    required this.issuedAt,
    required this.expiresAt,
    this.claims = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'role': role,
      'issuedAt': issuedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'claims': claims,
    };
  }

  factory JwtPayload.fromJson(Map<String, dynamic> json) {
    return JwtPayload(
      userId: json['userId'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      claims: (json['claims'] as Map<String, dynamic>?)?.cast<String, dynamic>() ?? {},
    );
  }

  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  Duration get timeUntilExpiry {
    return expiresAt.difference(DateTime.now());
  }
}

class ApiKey {
  final String key;
  final String name;
  final String userId;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final List<String> permissions;
  final bool isActive;

  ApiKey({
    required this.key,
    required this.name,
    required this.userId,
    required this.createdAt,
    this.expiresAt,
    this.permissions = const [],
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'permissions': permissions,
      'isActive': isActive,
    };
  }

  factory ApiKey.fromJson(Map<String, dynamic> json) {
    return ApiKey(
      key: json['key'] as String,
      name: json['name'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt'] as String) : null,
      permissions: (json['permissions'] as List<dynamic>?)?.cast<String>() ?? [],
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get canAccess(String permission) {
    return isActive && !isExpired && permissions.contains(permission);
  }
}

class ApiKeyRequest {
  final String name;
  final List<String> permissions;
  final DateTime? expiresAt;

  ApiKeyRequest({
    required this.name,
    this.permissions = const [],
    this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'permissions': permissions,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  factory ApiKeyRequest.fromJson(Map<String, dynamic> json) {
    return ApiKeyRequest(
      name: json['name'] as String,
      permissions: (json['permissions'] as List<dynamic>?)?.cast<String>() ?? [],
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt'] as String) : null,
    );
  }
}

class ApiKeyResponse {
  final String key;
  final String name;
  final String userId;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final List<String> permissions;
  final bool isActive;

  ApiKeyResponse({
    required this.key,
    required this.name,
    required this.userId,
    required this.createdAt,
    this.expiresAt,
    required this.permissions,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'permissions': permissions,
      'isActive': isActive,
    };
  }

  factory ApiKeyResponse.fromJson(Map<String, dynamic> json) {
    return ApiKeyResponse(
      key: json['key'] as String,
      name: json['name'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt'] as String) : null,
      permissions: (json['permissions'] as List<dynamic>?)?.cast<String>() ?? [],
      isActive: json['isActive'] as bool,
    );
  }
}

class Role {
  final String id;
  final String name;
  final String description;
  final List<String> permissions;
  final DateTime createdAt;
  final DateTime updatedAt;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'permissions': permissions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      permissions: (json['permissions'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  bool hasAllPermissions(List<String> permissions) {
    return permissions.every((p) => this.permissions.contains(p));
  }

  bool hasAnyPermission(List<String> permissions) {
    return permissions.any((p) => this.permissions.contains(p));
  }
}

class Permission {
  final String id;
  final String name;
  final String description;
  final String resource;
  final String action;

  Permission({
    required this.id,
    required this.name,
    required this.description,
    required this.resource,
    required this.action,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'resource': resource,
      'action': action,
    };
  }

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      resource: json['resource'] as String,
      action: json['action'] as String,
    );
  }

  @override
  String toString() => 'Permission(resource: $resource, action: $action)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Permission && other.resource == resource && other.action == action;
  }

  @override
  int get hashCode => Object.hash(resource, action);
}

class PermissionSet {
  final Set<Permission> _permissions = {};

  void add(Permission permission) {
    _permissions.add(permission);
  }

  void remove(Permission permission) {
    _permissions.remove(permission);
  }

  bool has(Permission permission) {
    return _permissions.contains(permission);
  }

  bool hasResource(String resource) {
    return _permissions.any((p) => p.resource == resource);
  }

  bool hasAction(String action) {
    return _permissions.any((p) => p.action == action);
  }

  List<Permission> getByResource(String resource) {
    return _permissions.where((p) => p.resource == resource).toList();
  }

  List<Permission> getByAction(String action) {
    return _permissions.where((p) => p.action == action).toList();
  }

  List<String> get resources {
    return _permissions.map((p) => p.resource).toSet().toList();
  }

  List<String> get actions {
    return _permissions.map((p) => p.action).toSet().toList();
  }

  int get count => _permissions.length;
  bool get isEmpty => _permissions.isEmpty;
  bool get isNotEmpty => _permissions.isNotEmpty;

  void clear() {
    _permissions.clear();
  }
}

class RoleRequest {
  final String name;
  final String description;
  final List<String> permissions;

  RoleRequest({
    required this.name,
    required this.description,
    required this.permissions,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'permissions': permissions,
    };
  }

  factory RoleRequest.fromJson(Map<String, dynamic> json) {
    return RoleRequest(
      name: json['name'] as String,
      description: json['description'] as String,
      permissions: (json['permissions'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

class RoleResponse {
  final String id;
  final String name;
  final String description;
  final List<Permission> permissions;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoleResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'permissions': permissions.map((p) => p.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory RoleResponse.fromJson(Map<String, dynamic> json) {
    return RoleResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      permissions: (json['permissions'] as List<dynamic>?)?.map((p) => Permission.fromJson(p as Map<String, dynamic>)).toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class UserRoleAssignment {
  final String userId;
  final String roleId;
  final DateTime assignedAt;
  final String assignedBy;

  UserRoleAssignment({
    required this.userId,
    required this.roleId,
    required this.assignedAt,
    required this.assignedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'roleId': roleId,
      'assignedAt': assignedAt.toIso8601String(),
      'assignedBy': assignedBy,
    };
  }

  factory UserRoleAssignment.fromJson(Map<String, dynamic> json) {
    return UserRoleAssignment(
      userId: json['userId'] as String,
      roleId: json['roleId'] as String,
      assignedAt: DateTime.parse(json['assignedAt'] as String),
      assignedBy: json['assignedBy'] as String,
    );
  }
}

class UserRoleAssignmentRequest {
  final String userId;
  final String roleId;

  UserRoleAssignmentRequest({
    required this.userId,
    required this.roleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'roleId': roleId,
    };
  }

  factory UserRoleAssignmentRequest.fromJson(Map<String, dynamic> json) {
    return UserRoleAssignmentRequest(
      userId: json['userId'] as String,
      roleId: json['roleId'] as String,
    );
  }
}

class AuthMiddleware {
  final bool _required;
  final List<String> _requiredRoles;
  final List<String> _requiredPermissions;

  AuthMiddleware({
    this._required = false,
    this._requiredRoles = const [],
    this._requiredPermissions = const [],
  });

  Future<bool> authenticate(Map<String, String> headers) async {
    final authHeader = headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      if (_required) {
        throw AuthException('Authentication required');
      }
      return false;
    }
    final token = authHeader.substring(7);
    // Validate token - simplified
    return token.isNotEmpty;
  }

  Future<bool> authorize(List<String> userRoles, List<String> userPermissions) async {
    if (_requiredRoles.isNotEmpty) {
      if (!_requiredRoles.any((r) => userRoles.contains(r))) {
        throw AuthException('Insufficient role');
      }
    }
    if (_requiredPermissions.isNotEmpty) {
      if (!_requiredPermissions.any((p) => userPermissions.contains(p))) {
        throw AuthException('Insufficient permission');
      }
    }
    return true;
  }

  bool get requiresAuth => _required;
  List<String> get requiredRoles => List.unmodifiable(_requiredRoles);
  List<String> get requiredPermissions => List.unmodifiable(_requiredPermissions);
}

class RoleMiddleware {
  final List<String> _allowedRoles;

  RoleMiddleware(this._allowedRoles);

  Future<bool> authorize(List<String> userRoles) async {
    return _allowedRoles.any((r) => userRoles.contains(r));
  }

  List<String> get allowedRoles => List.unmodifiable(_allowedRoles);
}

class PermissionMiddleware {
  final List<String> _requiredPermissions;

  PermissionMiddleware(this._requiredPermissions);

  Future<bool> authorize(List<String> userPermissions) async {
    return _requiredPermissions.any((p) => userPermissions.contains(p));
  }

  List<String> get requiredPermissions => List.unmodifiable(_requiredPermissions);
}

class AuthGuard {
  final AuthMiddleware _middleware;

  AuthGuard(this._middleware);

  Future<bool> canAccess(Map<String, String> headers, List<String> userRoles, List<String> userPermissions) async {
    final authenticated = await _middleware.authenticate(headers);
    if (!authenticated) return false;
    return _middleware.authorize(userRoles, userPermissions);
  }
}

class AuthFilter {
  final bool _required;

  AuthFilter({this._required = false});

  bool shouldApply(Map<String, String> headers) {
    final authHeader = headers['Authorization'];
    if (authHeader == null) {
      return !_required;
    }
    return true;
  }
}

class AuthDecorator {
  final bool Function(Map<String, String>) _check;

  AuthDecorator(this._check);

  bool isAllowed(Map<String, String> headers) {
    return _check(headers);
  }
}

class AuthInterceptor2 {
  final bool Function(Map<String, String>) _intercept;

  AuthInterceptor2(this._intercept);

  Future<Map<String, String>> apply(Map<String, String> headers) async {
    if (!_intercept(headers)) {
      throw AuthException('Access denied');
    }
    return headers;
  }
}

class AuthValidator {
  final bool Function(Map<String, String>) _validate;

  AuthValidator(this._validate);

  bool validate(Map<String, String> headers) {
    return _validate(headers);
  }
}

class AuthProvider {
  final bool Function(Map<String, String>) _provide;

  AuthProvider(this._provide);

  bool provide(Map<String, String> headers) {
    return _provide(headers);
  }
}

class AuthConsumer {
  final void Function(Map<String, String>) _consume;

  AuthConsumer(this._consume);

  void consume(Map<String, String> headers) {
    _consume(headers);
  }
}

class AuthManager {
  final Map<String, String> _tokens = {};
  final Map<String, UserModel> _users = {};
  final Map<String, List<String>> _userRoles = {};
  final Map<String, List<String>> _userPermissions = {};

  void registerToken(String token, String userId) {
    _tokens[token] = userId;
  }

  void removeToken(String token) {
    _tokens.remove(token);
  }

  String? getUserId(String token) {
    return _tokens[token];
  }

  void registerUser(UserModel user) {
    _users[user.id] = user;
  }

  UserModel? getUser(String id) {
    return _users[id];
  }

  void registerRoles(String userId, List<String> roles) {
    _userRoles[userId] = roles;
  }

  List<String> getRoles(String userId) {
    return _userRoles[userId] ?? [];
  }

  void registerPermissions(String userId, List<String> permissions) {
    _userPermissions[userId] = permissions;
  }

  List<String> getPermissions(String userId) {
    return _userPermissions[userId] ?? [];
  }

  bool hasRole(String userId, String role) {
    return getRoles(userId).contains(role);
  }

  bool hasPermission(String userId, String permission) {
    return getPermissions(userId).contains(permission);
  }

  bool hasAnyRole(String userId, List<String> roles) {
    return roles.any((r) => getRoles(userId).contains(r));
  }

  bool hasAnyPermission(String userId, List<String> permissions) {
    return permissions.any((p) => getPermissions(userId).contains(p));
  }

  bool hasAllRoles(String userId, List<String> roles) {
    return roles.every((r) => getRoles(userId).contains(r));
  }

  bool hasAllPermissions(String userId, List<String> permissions) {
    return permissions.every((p) => getPermissions(userId).contains(p));
  }

  void clear() {
    _tokens.clear();
    _users.clear();
    _userRoles.clear();
    _userPermissions.clear();
  }
}

class AuthService {
  final AuthManager _manager = AuthManager();

  void registerUser(UserModel user, List<String> roles, List<String> permissions) {
    _manager.registerUser(user);
    _manager.registerRoles(user.id, roles);
    _manager.registerPermissions(user.id, permissions);
  }

  void registerToken(String token, String userId) {
    _manager.registerToken(token, userId);
  }

  void removeToken(String token) {
    _manager.removeToken(token);
  }

  String? getUserId(String token) {
    return _manager.getUserId(token);
  }

  UserModel? getUser(String id) {
    return _manager.getUser(id);
  }

  bool isAuthenticated(String token) {
    return _manager.getUserId(token) != null;
  }

  bool isAuthorized(String userId, String role) {
    return _manager.hasRole(userId, role);
  }

  bool hasPermission(String userId, String permission) {
    return _manager.hasPermission(userId, permission);
  }

  void logout(String token) {
    _manager.removeToken(token);
  }

  void logoutAll(String userId) {
    // Remove all tokens for user - simplified
  }

  void clear() {
    _manager.clear();
  }
}

class AuthRepository {
  final AuthService _service;

  AuthRepository(this._service);

  Future<UserModel> login(UserLoginRequest request) async {
    // Simplified - would call API
    throw UnimplementedError();
  }

  Future<UserModel> register(UserRegistrationRequest request) async {
    throw UnimplementedError();
  }

  Future<void> logout(String token) async {
    _service.logout(token);
  }

  Future<AuthToken> refreshToken(String refreshToken) async {
    throw UnimplementedError();
  }

  Future<void> forgotPassword(String email) async {
    throw UnimplementedError();
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    throw UnimplementedError();
  }

  Future<UserModel> getCurrentUser(String userId) async {
    return _service.getUser(userId) ?? throw Exception('User not found');
  }

  Future<void> updateProfile(String userId, UpdateProfileRequest request) async {
    throw UnimplementedError();
  }

  Future<void> changePassword(String userId, ChangePasswordRequest request) async {
    throw UnimplementedError();
  }
}

class AuthController {
  final AuthService _service;

  AuthController(this._service);

  Future<Map<String, dynamic>> login(UserLoginRequest request) async {
    try {
      final user = _service.getUser(request.email);
      if (user == null) {
        return {'success': false, 'message': 'Invalid credentials'};
      }
      final token = 'token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';
      _service.registerToken(token, user.id);
      return {
        'success': true,
        'token': token,
        'user': user.toJson(),
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> register(UserRegistrationRequest request) async {
    try {
      if (!request.isValid) {
        return {'success': false, 'message': 'Validation failed', 'errors': request.validationErrors};
      }
      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final user = UserModel(
        id: userId,
        email: request.email,
        name: request.name,
        avatar: 'U1',
        level: 1,
        xp: 0,
        rank: 1,
        streak: 0,
        lessonsCompleted: 0,
        quizzesCompleted: 0,
        badgesEarned: 0,
        accuracy: 0.0,
        joinedAt: DateTime.now(),
        lastActive: DateTime.now(),
        passwordHash: 'hashed_${request.password}',
        salt: 'salt_${DateTime.now().millisecondsSinceEpoch}',
      );
      _service.registerUser(user, ['user'], ['read', 'write']);
      final token = 'token_${userId}_${DateTime.now().millisecondsSinceEpoch}';
      _service.registerToken(token, userId);
      return {
        'success': true,
        'token': token,
        'user': user.toJson(),
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> logout(String token) async {
    try {
      _service.logout(token);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getProfile(String userId) async {
    try {
      final user = _service.getUser(userId);
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }
      return {'success': true, 'user': user.toJson()};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateProfile(String userId, UpdateProfileRequest request) async {
    try {
      final user = _service.getUser(userId);
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }
      final updated = user.copyWith(
        name: request.name,
        bio: request.bio,
        location: request.location,
        website: request.website,
        avatar: request.avatar,
      );
      _service.registerUser(updated, ['user'], ['read', 'write']);
      return {'success': true, 'user': updated.toJson()};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> changePassword(String userId, ChangePasswordRequest request) async {
    try {
      if (!request.isValid) {
        return {'success': false, 'message': 'Validation failed', 'errors': request.validationErrors};
      }
      final user = _service.getUser(userId);
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }
      final updated = user.copyWith(passwordHash: 'hashed_${request.newPassword}');
      _service.registerUser(updated, ['user'], ['read', 'write']);
      return {'success': true, 'message': 'Password changed successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      // Simplified
      return {'success': true, 'message': 'Password reset email sent'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> resetPassword(ResetPasswordRequest request) async {
    try {
      if (!request.isValid) {
        return {'success': false, 'message': 'Validation failed', 'errors': request.validationErrors};
      }
      return {'success': true, 'message': 'Password reset successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}

class UserController {
  final AuthService _service;

  UserController(this._service);

  Future<Map<String, dynamic>> getUser(String userId) async {
    try {
      final user = _service.getUser(userId);
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }
      return {'success': true, 'user': user.toJson()};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUsers(int page, int limit) async {
    try {
      // Simplified pagination
      return {
        'success': true,
        'users': [],
        'total': 0,
        'page': page,
        'limit': limit,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> createUser(UserRegistrationRequest request) async {
    try {
      if (!request.isValid) {
        return {'success': false, 'message': 'Validation failed', 'errors': request.validationErrors};
      }
      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final user = UserModel(
        id: userId,
        email: request.email,
        name: request.name,
        avatar: 'U1',
        level: 1,
        xp: 0,
        rank: 1,
        streak: 0,
        lessonsCompleted: 0,
        quizzesCompleted: 0,
        badgesEarned: 0,
        accuracy: 0.0,
        joinedAt: DateTime.now(),
        lastActive: DateTime.now(),
        passwordHash: 'hashed_${request.password}',
        salt: 'salt_${DateTime.now().millisecondsSinceEpoch}',
      );
      _service.registerUser(user, ['user'], ['read', 'write']);
      return {'success': true, 'user': user.toJson()};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateUser(String userId, UpdateProfileRequest request) async {
    try {
      final user = _service.getUser(userId);
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }
      final updated = user.copyWith(
        name: request.name,
        bio: request.bio,
        location: request.location,
        website: request.website,
        avatar: request.avatar,
      );
      _service.registerUser(updated, ['user'], ['read', 'write']);
      return {'success': true, 'user': updated.toJson()};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteUser(String userId) async {
    try {
      // Simplified
      return {'success': true, 'message': 'User deleted successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      final user = _service.getUser(userId);
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }
      final stats = UserStats(
        lessonsCompleted: user.lessonsCompleted,
        quizzesCompleted: user.quizzesCompleted,
        badgesEarned: user.badgesEarned,
        accuracy: user.accuracy,
        totalXp: user.xp,
        currentStreak: user.streak,
        longestStreak: user.streak,
        timeSpentMinutes: 0,
        lastLessonDate: user.lastActive,
      );
      return {'success': true, 'stats': stats.toJson()};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUserPreferences(String userId) async {
    try {
      final user = _service.getUser(userId);
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }
      final prefs = UserPreferences();
      return {'success': true, 'preferences': prefs.toJson()};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateUserPreferences(String userId, UpdateSettingsRequest request) async {
    try {
      final user = _service.getUser(userId);
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }
      final prefs = UserPreferences(
        notificationsEnabled: request.notifications,
        darkMode: request.darkMode,
        language: request.language,
      );
      return {'success': true, 'preferences': prefs.toJson()};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUserFriends(String userId) async {
    try {
      final user = _service.getUser(userId);
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }
      return {'success': true, 'friends': user.friends};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> addFriend(String userId, String friendId) async {
    try {
      final user = _service.getUser(userId);
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }
      final updated = user.copyWith(friends: [...user.friends, friendId]);
      _service.registerUser(updated, ['user'], ['read', 'write']);
      return {'success': true, 'user': updated.toJson()};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> removeFriend(String userId, String friendId) async {
    try {
      final user = _service.getUser(userId);
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }
      final updated = user.copyWith(friends: user.friends.where((f) => f != friendId).toList());
      _service.registerUser(updated, ['user'], ['read', 'write']);
      return {'success': true, 'user': updated.toJson()};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> searchUsers(String query) async {
    try {
      // Simplified search
      return {'success': true, 'users': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}

class CourseController {
  final AuthService _service;

  CourseController(this._service);

  Future<Map<String, dynamic>> getCourses(int page, int limit) async {
    try {
      return {
        'success': true,
        'courses': [],
        'total': 0,
        'page': page,
        'limit': limit,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourse(String courseId) async {
    try {
      return {'success': false, 'message': 'Course not found'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> createCourse(Map<String, dynamic> data) async {
    try {
      return {'success': false, 'message': 'Not implemented'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateCourse(String courseId, Map<String, dynamic> data) async {
    try {
      return {'success': false, 'message': 'Course not found'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteCourse(String courseId) async {
    try {
      return {'success': false, 'message': 'Course not found'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseLessons(String courseId) async {
    try {
      return {'success': true, 'lessons': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> enrollUser(String userId, String courseId) async {
    try {
      return {'success': true, 'message': 'Enrolled successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> unenrollUser(String userId, String courseId) async {
    try {
      return {'success': true, 'message': 'Unenrolled successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUserCourses(String userId) async {
    try {
      return {'success': true, 'courses': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUserEnrollments(String userId) async {
    try {
      return {'success': true, 'enrollments': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseStats(String courseId) async {
    try {
      return {'success': true, 'stats': {}};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> searchCourses(String query) async {
    try {
      return {'success': true, 'courses': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> filterCourses(Map<String, String> filters) async {
    try {
      return {'success': true, 'courses': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> sortCourses(List<String> sortBy) async {
    try {
      return {'success': true, 'courses': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getPopularCourses() async {
    try {
      return {'success': true, 'courses': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getNewCourses() async {
    try {
      return {'success': true, 'courses': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getFeaturedCourses() async {
    try {
      return {'success': true, 'courses': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getRecommendedCourses(String userId) async {
    try {
      return {'success': true, 'courses': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUserEnrolledCourses(String userId) async {
    try {
      return {'success': true, 'courses': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUserCompletedCourses(String userId) async {
    try {
      return {'success': true, 'courses': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUserInProgressCourses(String userId) async {
    try {
      return {'success': true, 'courses': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUserSavedCourses(String userId) async {
    try {
      return {'success': true, 'courses': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> saveCourse(String userId, String courseId) async {
    try {
      return {'success': true, 'message': 'Course saved successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> unsaveCourse(String userId, String courseId) async {
    try {
      return {'success': true, 'message': 'Course unsaved successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseProgress(String userId, String courseId) async {
    try {
      return {'success': true, 'progress': 0.0};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateCourseProgress(String userId, String courseId, double progress) async {
    try {
      return {'success': true, 'progress': progress};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseLessonsProgress(String userId, String courseId) async {
    try {
      return {'success': true, 'lessons': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> markLessonComplete(String userId, String courseId, String lessonId) async {
    try {
      return {'success': true, 'message': 'Lesson marked complete'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> markLessonIncomplete(String userId, String courseId, String lessonId) async {
    try {
      return {'success': true, 'message': 'Lesson marked incomplete'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseCertificate(String userId, String courseId) async {
    try {
      return {'success': false, 'message': 'Certificate not found'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> generateCourseCertificate(String userId, String courseId) async {
    try {
      return {'success': false, 'message': 'Certificate generation not available'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> downloadCourseCertificate(String userId, String courseId) async {
    try {
      return {'success': false, 'message': 'Certificate download not available'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyCourseCertificate(String certificateId) async {
    try {
      return {'success': false, 'message': 'Certificate not found'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseReviews(String courseId) async {
    try {
      return {'success': true, 'reviews': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> addCourseReview(String userId, String courseId, Map<String, dynamic> review) async {
    try {
      return {'success': true, 'message': 'Review added successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateCourseReview(String userId, String courseId, String reviewId, Map<String, dynamic> review) async {
    try {
      return {'success': true, 'message': 'Review updated successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteCourseReview(String userId, String courseId, String reviewId) async {
    try {
      return {'success': true, 'message': 'Review deleted successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseRating(String courseId) async {
    try {
      return {'success': true, 'rating': 0.0, 'count': 0};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseEnrollments(String courseId) async {
    try {
      return {'success': true, 'enrollments': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseStudents(String courseId) async {
    try {
      return {'success': true, 'students': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseInstructors(String courseId) async {
    try {
      return {'success': true, 'instructors': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> addCourseInstructor(String courseId, String instructorId) async {
    try {
      return {'success': true, 'message': 'Instructor added successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> removeCourseInstructor(String courseId, String instructorId) async {
    try {
      return {'success': true, 'message': 'Instructor removed successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseModules(String courseId) async {
    try {
      return {'success': true, 'modules': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> createCourseModule(String courseId, Map<String, dynamic> data) async {
    try {
      return {'success': false, 'message': 'Not implemented'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateCourseModule(String courseId, String moduleId, Map<String, dynamic> data) async {
    try {
      return {'success': false, 'message': 'Module not found'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteCourseModule(String courseId, String moduleId) async {
    try {
      return {'success': false, 'message': 'Module not found'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseAssignments(String courseId) async {
    try {
      return {'success': true, 'assignments': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> submitCourseAssignment(String userId, String courseId, String assignmentId, Map<String, dynamic> submission) async {
    try {
      return {'success': true, 'message': 'Assignment submitted successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseAssignmentSubmissions(String courseId, String assignmentId) async {
    try {
      return {'success': true, 'submissions': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> gradeCourseAssignment(String userId, String courseId, String assignmentId, String submissionId, double grade, String feedback) async {
    try {
      return {'success': true, 'message': 'Assignment graded successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseAnnouncements(String courseId) async {
    try {
      return {'success': true, 'announcements': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> createCourseAnnouncement(String courseId, String instructorId, Map<String, dynamic> announcement) async {
    try {
      return {'success': true, 'message': 'Announcement created successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateCourseAnnouncement(String courseId, String announcementId, Map<String, dynamic> announcement) async {
    try {
      return {'success': true, 'message': 'Announcement updated successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteCourseAnnouncement(String courseId, String announcementId) async {
    try {
      return {'success': true, 'message': 'Announcement deleted successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseDiscussions(String courseId) async {
    try {
      return {'success': true, 'discussions': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> createCourseDiscussion(String courseId, String userId, Map<String, dynamic> discussion) async {
    try {
      return {'success': true, 'message': 'Discussion created successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> replyCourseDiscussion(String courseId, String discussionId, String userId, Map<String, dynamic> reply) async {
    try {
      return {'success': true, 'message': 'Reply created successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseDiscussionReplies(String courseId, String discussionId) async {
    try {
      return {'success': true, 'replies': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> likeCourseDiscussion(String courseId, String discussionId, String userId) async {
    try {
      return {'success': true, 'message': 'Discussion liked successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> unlikeCourseDiscussion(String courseId, String discussionId, String userId) async {
    try {
      return {'success': true, 'message': 'Discussion unliked successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseDiscussionLikes(String courseId, String discussionId) async {
    try {
      return {'success': true, 'likes': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseDiscussionParticipants(String courseId, String discussionId) async {
    try {
      return {'success': true, 'participants': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseDiscussionStats(String courseId) async {
    try {
      return {'success': true, 'stats': {}};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseDiscussionTrends(String courseId) async {
    try {
      return {'success': true, 'trends': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseDiscussionAnalytics(String courseId) async {
    try {
      return {'success': true, 'analytics': {}};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseDiscussionInsights(String courseId) async {
    try {
      return {'success': true, 'insights': {}};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseDiscussionReports(String courseId) async {
    try {
      return {'success': true, 'reports': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> createCourseDiscussionReport(String courseId, String discussionId, String userId, Map<String, dynamic> report) async {
    try {
      return {'success': true, 'message': 'Report created successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> resolveCourseDiscussionReport(String courseId, String reportId, String adminId, String status) async {
    try {
      return {'success': true, 'message': 'Report resolved successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteCourseDiscussionReport(String courseId, String reportId) async {
    try {
      return {'success': true, 'message': 'Report deleted successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseDiscussionReportStats(String courseId) async {
    try {
      return {'success': true, 'stats': {}};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseDiscussionReportTrends(String courseId) async {
    try {
      return {'success': true, 'trends': []};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseDiscussionReportAnalytics(String courseId) async {
    try {
      return {'success': true, 'analytics': {}};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourseDiscussionReportInsights(String courseId) async {
    try {
      return {'success': true, 'insights': {}};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
