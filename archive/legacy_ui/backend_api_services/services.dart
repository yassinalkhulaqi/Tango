class AuthService {
  final UserRepository _userRepository;
  final SessionRepository _sessionRepository;
  final ApiKeyRepository _apiKeyRepository;
  final RoleRepository _roleRepository;
  final EmailRepository _emailRepository;
  final AuditRepository _auditRepository;
  final CacheRepository _cacheRepository;

  AuthService({
    required UserRepository userRepository,
    required SessionRepository sessionRepository,
    required ApiKeyRepository apiKeyRepository,
    required RoleRepository roleRepository,
    required EmailRepository emailRepository,
    required AuditRepository auditRepository,
    required CacheRepository cacheRepository,
  })  : _userRepository = userRepository,
        _sessionRepository = sessionRepository,
        _apiKeyRepository = apiKeyRepository,
        _roleRepository = roleRepository,
        _emailRepository = emailRepository,
        _auditRepository = auditRepository,
        _cacheRepository = cacheRepository;

  Future<AuthResponse> register(UserRegistrationRequest request) async {
    if (!request.isValid) {
      throw ValidationException('Registration validation failed', errors: {
        for (final e in request.validationErrors) e: [e]
      });
    }

    final existing = await _userRepository.getByEmail(request.email);
    if (existing != null) {
      throw ConflictException('Email already registered');
    }

    final userId = _generateId();
    final salt = _generateSalt();
    final passwordHash = _hashPassword(request.password, salt);

    final user = UserModel(
      id: userId,
      email: request.email,
      name: request.name,
      avatar: 'U${(userId.hashCode % 12).abs() + 1}',
      level: 1,
      xp: 0,
      rank: 0,
      streak: 0,
      lessonsCompleted: 0,
      quizzesCompleted: 0,
      badgesEarned: 0,
      accuracy: 0.0,
      joinedAt: DateTime.now(),
      lastActive: DateTime.now(),
      passwordHash: passwordHash,
      salt: salt,
    );

    await _userRepository.create(user);
    await _roleRepository.assignRole(userId, 'user');
    await _emailRepository.sendWelcomeEmail(user.email, user.name);

    final token = _generateToken(userId);
    final refreshToken = _generateRefreshToken(userId);
    final session = UserSession(
      sessionId: _generateId(),
      userId: userId,
      token: token,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      ipAddress: '',
      userAgent: '',
      deviceInfo: '',
    );
    await _sessionRepository.create(session);

    await _auditRepository.log('register', userId, {'email': request.email});

    return AuthResponse(
      token: token,
      refreshToken: refreshToken,
      user: user,
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
  }

  Future<AuthResponse> login(UserLoginRequest request) async {
    if (!request.isValid) {
      throw ValidationException('Login validation failed');
    }

    final user = await _userRepository.getByEmail(request.email);
    if (user == null) {
      throw AuthException('Invalid email or password');
    }

    final passwordHash = _hashPassword(request.password, user.salt);
    if (passwordHash != user.passwordHash) {
      await _auditRepository.log('login_failed', user.id, {'reason': 'invalid_password'});
      throw AuthException('Invalid email or password');
    }

    await _userRepository.updateLastActive(user.id);

    final token = _generateToken(user.id);
    final refreshToken = _generateRefreshToken(user.id);
    final session = UserSession(
      sessionId: _generateId(),
      userId: user.id,
      token: token,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(request.rememberMe ? const Duration(days: 30) : const Duration(days: 7)),
      ipAddress: '',
      userAgent: '',
      deviceInfo: '',
    );
    await _sessionRepository.create(session);

    await _auditRepository.log('login', user.id, {'rememberMe': request.rememberMe});

    return AuthResponse(
      token: token,
      refreshToken: refreshToken,
      user: user,
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
  }

  Future<void> logout(String token) async {
    final session = await _sessionRepository.getByToken(token);
    if (session != null) {
      await _sessionRepository.invalidate(session.sessionId);
      await _auditRepository.log('logout', session.userId, {});
    }
  }

  Future<void> logoutAll(String userId) async {
    await _sessionRepository.invalidateAll(userId);
    await _auditRepository.log('logout_all', userId, {});
  }

  Future<AuthToken> refreshToken(String refreshToken) async {
    final userId = _parseRefreshToken(refreshToken);
    if (userId == null) {
      throw AuthException('Invalid refresh token');
    }

    final user = await _userRepository.getById(userId);
    if (user == null) {
      throw AuthException('User not found');
    }

    final token = _generateToken(userId);
    final newRefreshToken = _generateRefreshToken(userId);

    await _auditRepository.log('token_refresh', userId, {});

    return AuthToken(
      accessToken: token,
      refreshToken: newRefreshToken,
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
      userId: userId,
    );
  }

  Future<void> forgotPassword(String email) async {
    final user = await _userRepository.getByEmail(email);
    if (user == null) return;

    final token = _generateToken(user.id);
    await _userRepository.setPasswordResetToken(
      user.id,
      token,
      DateTime.now().add(const Duration(hours: 1)),
    );
    await _emailRepository.sendPasswordResetEmail(email, token);
    await _auditRepository.log('forgot_password', user.id, {});
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    if (!request.isValid) {
      throw ValidationException('Reset password validation failed');
    }

    final user = await _userRepository.getByPasswordResetToken(request.token);
    if (user == null) {
      throw AuthException('Invalid or expired reset token');
    }

    if (user.resetPasswordExpiresAt != null &&
        DateTime.now().isAfter(user.resetPasswordExpiresAt!)) {
      throw AuthException('Reset token expired');
    }

    final salt = _generateSalt();
    final passwordHash = _hashPassword(request.newPassword, salt);
    await _userRepository.updatePassword(user.id, passwordHash);
    await _userRepository.setPasswordResetToken(user.id, '', DateTime.now());

    await _sessionRepository.invalidateAll(user.id);
    await _auditRepository.log('password_reset', user.id, {});
  }

  Future<void> changePassword(String userId, ChangePasswordRequest request) async {
    if (!request.isValid) {
      throw ValidationException('Change password validation failed');
    }

    final user = await _userRepository.getById(userId);
    if (user == null) {
      throw NotFoundException('User', userId);
    }

    final currentHash = _hashPassword(request.currentPassword, user.salt);
    if (currentHash != user.passwordHash) {
      throw AuthException('Current password is incorrect');
    }

    final salt = _generateSalt();
    final passwordHash = _hashPassword(request.newPassword, salt);
    await _userRepository.updatePassword(userId, passwordHash);
    await _sessionRepository.invalidateAll(userId);
    await _auditRepository.log('password_change', userId, {});
  }

  Future<UserModel> getCurrentUser(String userId) async {
    final cached = await _cacheRepository.get('user_$userId');
    if (cached != null) {
      return UserModel.fromJson(cached as Map<String, dynamic>);
    }

    final user = await _userRepository.getById(userId);
    if (user == null) {
      throw NotFoundException('User', userId);
    }

    await _cacheRepository.set('user_$userId', user.toJson(), ttl: const Duration(minutes: 5));
    return user;
  }

  Future<UserModel> updateProfile(String userId, UpdateProfileRequest request) async {
    final user = await _userRepository.getById(userId);
    if (user == null) {
      throw NotFoundException('User', userId);
    }

    await _userRepository.updateProfile(userId, {
      'name': request.name,
      'bio': request.bio,
      'location': request.location,
      'website': request.website,
      'avatar': request.avatar,
    });

    await _cacheRepository.delete('user_$userId');
    await _auditRepository.log('profile_update', userId, {});

    return (await _userRepository.getById(userId))!;
  }

  Future<void> verifyEmail(String token) async {
    final userId = _parseToken(token);
    if (userId == null) {
      throw AuthException('Invalid verification token');
    }

    await _userRepository.verifyEmail(userId);
    await _auditRepository.log('email_verified', userId, {});
  }

  Future<bool> validateToken(String token) async {
    final session = await _sessionRepository.getByToken(token);
    if (session == null) return false;
    if (session.isExpired) return false;
    return true;
  }

  Future<String?> getUserIdFromToken(String token) async {
    final session = await _sessionRepository.getByToken(token);
    return session?.userId;
  }

  Future<List<String>> getUserRoles(String userId) async {
    return _roleRepository.getUserRoles(userId);
  }

  Future<bool> hasRole(String userId, String role) async {
    return _roleRepository.hasRole(userId, role);
  }

  Future<bool> hasPermission(String userId, String permission) async {
    return _roleRepository.hasPermission(userId, permission);
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        (DateTime.now().microsecond).toString();
  }

  String _generateSalt() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String _hashPassword(String password, String salt) {
    return password + salt;
  }

  String _generateToken(String userId) {
    return 'token_$userId\_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _generateRefreshToken(String userId) {
    return 'refresh_$userId\_${DateTime.now().millisecondsSinceEpoch}';
  }

  String? _parseToken(String token) {
    if (!token.startsWith('token_')) return null;
    return token.substring(6).split('_').first;
  }

  String? _parseRefreshToken(String token) {
    if (!token.startsWith('refresh_')) return null;
    return token.substring(8).split('_').first;
  }
}

class CourseService {
  final CourseRepository _courseRepository;
  final LessonRepository _lessonRepository;
  final EnrollmentRepository _enrollmentRepository;
  final ReviewRepository _reviewRepository;
  final ModuleRepository _moduleRepository;
  final CategoryRepository _categoryRepository;
  final CacheRepository _cacheRepository;
  final SearchRepository _searchRepository;

  CourseService({
    required CourseRepository courseRepository,
    required LessonRepository lessonRepository,
    required EnrollmentRepository enrollmentRepository,
    required ReviewRepository reviewRepository,
    required ModuleRepository moduleRepository,
    required CategoryRepository categoryRepository,
    required CacheRepository cacheRepository,
    required SearchRepository searchRepository,
  })  : _courseRepository = courseRepository,
        _lessonRepository = lessonRepository,
        _enrollmentRepository = enrollmentRepository,
        _reviewRepository = reviewRepository,
        _moduleRepository = moduleRepository,
        _categoryRepository = categoryRepository,
        _cacheRepository = cacheRepository,
        _searchRepository = searchRepository;

  Future<List<CourseModel>> getCourses({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) async {
    final cacheKey = 'courses_${page}_$limit\_$category\_$search\_$sortBy\_$sortOrder';
    final cached = await _cacheRepository.get(cacheKey);
    if (cached != null) {
      return (cached as List<dynamic>)
          .map((c) => CourseModel.fromJson(c as Map<String, dynamic>))
          .toList();
    }

    var courses = await _courseRepository.getAll();

    if (category != null) {
      courses = await _courseRepository.getByCategory(category);
    }

    if (search != null && search.isNotEmpty) {
      courses = await _searchRepository.searchCourses(search);
    }

    if (sortBy != null) {
      courses = _sortCourses(courses, sortBy, sortOrder ?? 'asc');
    }

    final paginated = _paginate(courses, page, limit);

    await _cacheRepository.set(
      cacheKey,
      paginated.map((c) => c.toJson()).toList(),
      ttl: const Duration(minutes: 5),
    );

    return paginated;
  }

  Future<CourseModel> getCourse(String courseId) async {
    final cacheKey = 'course_$courseId';
    final cached = await _cacheRepository.get(cacheKey);
    if (cached != null) {
      return CourseModel.fromJson(cached as Map<String, dynamic>);
    }

    final course = await _courseRepository.getById(courseId);
    if (course == null) {
      throw NotFoundException('Course', courseId);
    }

    await _cacheRepository.set(cacheKey, course.toJson(), ttl: const Duration(minutes: 10));
    return course;
  }

  Future<CourseModel> createCourse(Map<String, dynamic> data) async {
    final course = CourseModel(
      id: _generateId(),
      title: data['title'] as String,
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? 'General',
      thumbnail: data['thumbnail'] as String? ?? '',
      lessonsCount: 0,
      level: data['level'] as int? ?? 1,
      rating: 0.0,
      enrolledCount: 0,
      isFeatured: data['isFeatured'] as bool? ?? false,
      isNew: true,
      isLocked: data['isLocked'] as bool? ?? false,
      unlockRequirement: data['unlockRequirement'] as String? ?? '',
      xpReward: data['xpReward'] as int? ?? 0,
      estimatedMinutes: data['estimatedMinutes'] as int? ?? 0,
      tags: (data['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      prerequisites: (data['prerequisites'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      instructorId: data['instructorId'] as String? ?? '',
      instructorName: data['instructorName'] as String? ?? '',
      metadata: (data['metadata'] as Map<String, dynamic>?)?.cast<String, dynamic>() ?? {},
    );

    await _courseRepository.create(course);
    await _searchRepository.indexCourse(course.id);
    await _categoryRepository.updateCourseCount(course.category);
    await _invalidateCoursesCache();

    return course;
  }

  Future<CourseModel> updateCourse(String courseId, Map<String, dynamic> data) async {
    final existing = await _courseRepository.getById(courseId);
    if (existing == null) {
      throw NotFoundException('Course', courseId);
    }

    final updated = existing.copyWith(
      title: data['title'] as String?,
      description: data['description'] as String?,
      category: data['category'] as String?,
      thumbnail: data['thumbnail'] as String?,
      level: data['level'] as int?,
      isFeatured: data['isFeatured'] as bool?,
      isNew: data['isNew'] as bool?,
      isLocked: data['isLocked'] as bool?,
      unlockRequirement: data['unlockRequirement'] as String?,
      xpReward: data['xpReward'] as int?,
      estimatedMinutes: data['estimatedMinutes'] as int?,
      tags: (data['tags'] as List<dynamic>?)?.cast<String>(),
      prerequisites: (data['prerequisites'] as List<dynamic>?)?.cast<String>(),
      updatedAt: DateTime.now(),
    );

    await _courseRepository.update(updated);
    await _searchRepository.indexCourse(courseId);
    await _cacheRepository.delete('course_$courseId');
    await _invalidateCoursesCache();

    return updated;
  }

  Future<void> deleteCourse(String courseId) async {
    final course = await _courseRepository.getById(courseId);
    if (course == null) {
      throw NotFoundException('Course', courseId);
    }

    await _lessonRepository.getByCourse(courseId).then((lessons) async {
      for (final lesson in lessons) {
        await _lessonRepository.delete(lesson.id);
      }
    });

    await _enrollmentRepository.deleteByCourse(courseId);
    await _reviewRepository.deleteByCourse(courseId);
    await _courseRepository.delete(courseId);
    await _searchRepository.removeFromIndex('course', courseId);
    await _categoryRepository.updateCourseCount(course.category);
    await _cacheRepository.delete('course_$courseId');
    await _invalidateCoursesCache();
  }

  Future<void> enrollUser(String userId, String courseId) async {
    final course = await _courseRepository.getById(courseId);
    if (course == null) {
      throw NotFoundException('Course', courseId);
    }

    if (course.isLocked) {
      throw ValidationException('Course is locked');
    }

    final isEnrolled = await _enrollmentRepository.isEnrolled(userId, courseId);
    if (isEnrolled) {
      throw ConflictException('Already enrolled in this course');
    }

    await _enrollmentRepository.enroll(userId, courseId);
    await _courseRepository.incrementEnrolledCount(courseId);
    await _cacheRepository.delete('course_$courseId');
  }

  Future<void> unenrollUser(String userId, String courseId) async {
    await _enrollmentRepository.unenroll(userId, courseId);
    await _courseRepository.decrementEnrolledCount(courseId);
    await _cacheRepository.delete('course_$courseId');
  }

  Future<double> getCourseProgress(String userId, String courseId) async {
    return _enrollmentRepository.getByUserAndCourse(userId, courseId).then((enrollment) {
      return enrollment?.progress ?? 0.0;
    });
  }

  Future<List<CourseModel>> getRecommendedCourses(String userId) async {
    return _courseRepository.getRecommended(userId);
  }

  Future<List<CourseModel>> getFeaturedCourses() async {
    return _courseRepository.getFeatured();
  }

  Future<List<CourseModel>> getNewCourses() async {
    return _courseRepository.getNew();
  }

  Future<List<CourseModel>> getPopularCourses() async {
    return _courseRepository.getPopular();
  }

  Future<void> addReview(String userId, String courseId, double rating, String comment) async {
    final review = CourseReviewModel(
      id: _generateId(),
      courseId: courseId,
      userId: userId,
      userName: '',
      userAvatar: '',
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _reviewRepository.create(review);
    await _reviewRepository.updateRating(courseId);
    await _cacheRepository.delete('course_$courseId');
  }

  Future<void> _invalidateCoursesCache() async {
    final keys = await _cacheRepository.getKeys(pattern: 'courses_');
    if (keys != null) {
      await _cacheRepository.deleteMany(keys.cast<String>());
    }
  }

  List<CourseModel> _sortCourses(List<CourseModel> courses, String sortBy, String sortOrder) {
    final ascending = sortOrder == 'asc';
    switch (sortBy) {
      case 'title':
        courses.sort((a, b) => ascending ? a.title.compareTo(b.title) : b.title.compareTo(a.title));
        break;
      case 'rating':
        courses.sort((a, b) => ascending ? a.rating.compareTo(b.rating) : b.rating.compareTo(a.rating));
        break;
      case 'enrolledCount':
        courses.sort((a, b) => ascending ? a.enrolledCount.compareTo(b.enrolledCount) : b.enrolledCount.compareTo(a.enrolledCount));
        break;
      case 'createdAt':
        courses.sort((a, b) => ascending ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt));
        break;
      case 'level':
        courses.sort((a, b) => ascending ? a.level.compareTo(b.level) : b.level.compareTo(a.level));
        break;
    }
    return courses;
  }

  List<CourseModel> _paginate(List<CourseModel> items, int page, int limit) {
    final startIndex = (page - 1) * limit;
    final endIndex = (startIndex + limit).clamp(0, items.length);
    if (startIndex >= items.length) return [];
    return items.sublist(startIndex, endIndex);
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class LessonService {
  final LessonRepository _lessonRepository;
  final ProgressRepository _progressRepository;
  final CourseRepository _courseRepository;
  final CacheRepository _cacheRepository;

  LessonService({
    required LessonRepository lessonRepository,
    required ProgressRepository progressRepository,
    required CourseRepository courseRepository,
    required CacheRepository cacheRepository,
  })  : _lessonRepository = lessonRepository,
        _progressRepository = progressRepository,
        _courseRepository = courseRepository,
        _cacheRepository = cacheRepository;

  Future<List<LessonModel>> getCourseLessons(String courseId) async {
    final cacheKey = 'lessons_$courseId';
    final cached = await _cacheRepository.get(cacheKey);
    if (cached != null) {
      return (cached as List<dynamic>)
          .map((l) => LessonModel.fromJson(l as Map<String, dynamic>))
          .toList();
    }

    final lessons = await _lessonRepository.getByCourseOrdered(courseId);
    await _cacheRepository.set(
      cacheKey,
      lessons.map((l) => l.toJson()).toList(),
      ttl: const Duration(minutes: 10),
    );
    return lessons;
  }

  Future<LessonModel> getLesson(String lessonId) async {
    final lesson = await _lessonRepository.getById(lessonId);
    if (lesson == null) {
      throw NotFoundException('Lesson', lessonId);
    }
    return lesson;
  }

  Future<LessonModel> createLesson(Map<String, dynamic> data) async {
    final lesson = LessonModel(
      id: _generateId(),
      courseId: data['courseId'] as String,
      title: data['title'] as String,
      description: data['description'] as String? ?? '',
      content: data['content'] as String? ?? '',
      codeExample: data['codeExample'] as String? ?? '',
      explanation: data['explanation'] as String? ?? '',
      order: data['order'] as int? ?? 0,
      xpReward: data['xpReward'] as int? ?? 0,
      estimatedMinutes: data['estimatedMinutes'] as int? ?? 0,
      isLocked: data['isLocked'] as bool? ?? false,
      isCompleted: false,
      type: LessonType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => LessonType.theory,
      ),
      tags: (data['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      metadata: (data['metadata'] as Map<String, dynamic>?)?.cast<String, dynamic>() ?? {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _lessonRepository.create(lesson);
    await _updateCourseLessonCount(lesson.courseId);
    await _cacheRepository.delete('lessons_${lesson.courseId}');
    return lesson;
  }

  Future<LessonModel> updateLesson(String lessonId, Map<String, dynamic> data) async {
    final existing = await _lessonRepository.getById(lessonId);
    if (existing == null) {
      throw NotFoundException('Lesson', lessonId);
    }

    final updated = LessonModel(
      id: existing.id,
      courseId: existing.courseId,
      title: data['title'] as String? ?? existing.title,
      description: data['description'] as String? ?? existing.description,
      content: data['content'] as String? ?? existing.content,
      codeExample: data['codeExample'] as String? ?? existing.codeExample,
      explanation: data['explanation'] as String? ?? existing.explanation,
      order: data['order'] as int? ?? existing.order,
      xpReward: data['xpReward'] as int? ?? existing.xpReward,
      estimatedMinutes: data['estimatedMinutes'] as int? ?? existing.estimatedMinutes,
      isLocked: data['isLocked'] as bool? ?? existing.isLocked,
      isCompleted: existing.isCompleted,
      type: data['type'] != null
          ? LessonType.values.firstWhere((e) => e.name == data['type'])
          : existing.type,
      tags: (data['tags'] as List<dynamic>?)?.cast<String>() ?? existing.tags,
      metadata: (data['metadata'] as Map<String, dynamic>?)?.cast<String, dynamic>() ?? existing.metadata,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );

    await _lessonRepository.update(updated);
    await _cacheRepository.delete('lessons_${updated.courseId}');
    return updated;
  }

  Future<void> deleteLesson(String lessonId) async {
    final lesson = await _lessonRepository.getById(lessonId);
    if (lesson == null) {
      throw NotFoundException('Lesson', lessonId);
    }

    await _lessonRepository.delete(lessonId);
    await _progressRepository.deleteByLesson(lessonId);
    await _updateCourseLessonCount(lesson.courseId);
    await _cacheRepository.delete('lessons_${lesson.courseId}');
  }

  Future<void> markLessonComplete(String userId, String lessonId) async {
    final lesson = await _lessonRepository.getById(lessonId);
    if (lesson == null) {
      throw NotFoundException('Lesson', lessonId);
    }

    await _progressRepository.markCompleted(userId, lessonId);
    await _lessonRepository.setCompleted(lessonId, true);
    await _updateCourseProgress(userId, lesson.courseId);
  }

  Future<void> markLessonIncomplete(String userId, String lessonId) async {
    await _progressRepository.markIncomplete(userId, lessonId);
    await _lessonRepository.setCompleted(lessonId, false);
  }

  Future<double> getLessonProgress(String userId, String lessonId) async {
    final progress = await _progressRepository.getByUserAndLesson(userId, lessonId);
    return progress?.progress ?? 0.0;
  }

  Future<void> updateLessonProgress(String userId, String lessonId, double progress) async {
    await _progressRepository.updateProgress(userId, lessonId, progress);
    final lesson = await _lessonRepository.getById(lessonId);
    if (lesson != null) {
      await _updateCourseProgress(userId, lesson.courseId);
    }
  }

  Future<void> _updateCourseProgress(String userId, String courseId) async {
    final progress = await _progressRepository.getCourseProgress(userId, courseId);
    await _enrollmentRepository_updateProgress(userId, courseId, progress);
  }

  Future<void> _enrollmentRepository_updateProgress(String userId, String courseId, double progress) async {
    // Delegate to enrollment repository
  }

  Future<void> _updateCourseLessonCount(String courseId) async {
    final count = await _lessonRepository.getLessonCount(courseId);
    // Update course lesson count
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class QuizService {
  final QuizRepository _quizRepository;
  final ProgressRepository _progressRepository;
  final XPTransactionRepository _xpTransactionRepository;
  final CacheRepository _cacheRepository;

  QuizService({
    required QuizRepository quizRepository,
    required ProgressRepository progressRepository,
    required XPTransactionRepository xpTransactionRepository,
    required CacheRepository cacheRepository,
  })  : _quizRepository = quizRepository,
        _progressRepository = progressRepository,
        _xpTransactionRepository = xpTransactionRepository,
        _cacheRepository = cacheRepository;

  Future<List<QuizModel>> getCourseQuizzes(String courseId) async {
    return _quizRepository.getByCourse(courseId);
  }

  Future<QuizModel> getQuiz(String quizId) async {
    final quiz = await _quizRepository.getById(quizId);
    if (quiz == null) {
      throw NotFoundException('Quiz', quizId);
    }
    return quiz;
  }

  Future<Map<String, dynamic>> submitQuiz(String userId, String quizId, List<int> answers) async {
    final quiz = await _quizRepository.getById(quizId);
    if (quiz == null) {
      throw NotFoundException('Quiz', quizId);
    }

    int correct = 0;
    for (int i = 0; i < quiz.questions.length && i < answers.length; i++) {
      if (answers[i] == quiz.questions[i].correctIndex) {
        correct++;
      }
    }

    final score = quiz.questions.isEmpty ? 0.0 : correct / quiz.questions.length;
    final perfect = correct == quiz.questions.length;
    final xpEarned = perfect ? quiz.xpReward : (quiz.xpReward * score).round();

    await _quizRepository.submitQuiz(userId, quizId, answers);
    await _quizRepository.incrementAttempts(userId, quizId);
    await _quizRepository.setCompleted(userId, quizId, score);

    if (xpEarned > 0) {
      await _xpTransactionRepository.create(XPTransactionModel(
        id: _generateId(),
        userId: userId,
        amount: xpEarned,
        type: XPTransactionType.earned,
        source: 'quiz',
        description: 'Quiz completed: ${quiz.title}',
        createdAt: DateTime.now(),
      ));
    }

    await _cacheRepository.delete('quiz_$quizId');

    return {
      'score': score,
      'correct': correct,
      'total': quiz.questions.length,
      'xpEarned': xpEarned,
      'perfect': perfect,
    };
  }

  Future<double> getQuizScore(String userId, String quizId) async {
    return _quizRepository.getQuizScore(userId, quizId);
  }

  Future<int> getQuizAttempts(String userId, String quizId) async {
    return _quizRepository.getQuizAttempts(userId, quizId);
  }

  Future<bool> isQuizCompleted(String userId, String quizId) async {
    return _quizRepository.isCompleted(userId, quizId);
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class ProgressService {
  final ProgressRepository _progressRepository;
  final CourseRepository _courseRepository;
  final UserRepository _userRepository;
  final XPTransactionRepository _xpTransactionRepository;
  final AchievementRepository _achievementRepository;
  final StreakRepository _streakRepository;

  ProgressService({
    required ProgressRepository progressRepository,
    required CourseRepository courseRepository,
    required UserRepository userRepository,
    required XPTransactionRepository xpTransactionRepository,
    required AchievementRepository achievementRepository,
    required StreakRepository streakRepository,
  })  : _progressRepository = progressRepository,
        _courseRepository = courseRepository,
        _userRepository = userRepository,
        _xpTransactionRepository = xpTransactionRepository,
        _achievementRepository = achievementRepository,
        _streakRepository = streakRepository;

  Future<double> getOverallProgress(String userId) async {
    return _progressRepository.getOverallProgress(userId);
  }

  Future<double> getCourseProgress(String userId, String courseId) async {
    return _progressRepository.getCourseProgress(userId, courseId);
  }

  Future<List<ProgressModel>> getUserProgress(String userId) async {
    return _progressRepository.getByUser(userId);
  }

  Future<int> getTotalXp(String userId) async {
    return _progressRepository.getTotalXp(userId);
  }

  Future<void> awardXp(String userId, int amount, String source, String description) async {
    await _xpTransactionRepository.create(XPTransactionModel(
      id: _generateId(),
      userId: userId,
      amount: amount,
      type: XPTransactionType.earned,
      source: source,
      description: description,
      createdAt: DateTime.now(),
    ));

    await _userRepository.updateXp(userId, amount);

    final user = await _userRepository.getById(userId);
    if (user != null) {
      final newLevel = _calculateLevel(user.xp);
      if (newLevel > user.level) {
        await _userRepository.updateLevel(userId, newLevel);
        await _achievementRepository.checkAndUnlock(userId, 'level_up', {'level': newLevel});
      }
    }
  }

  Future<void> updateStreak(String userId) async {
    final streak = await _streakRepository.getByUser(userId);
    if (streak == null) {
      await _streakRepository.updateStreak(userId, 1);
    } else {
      await _streakRepository.incrementStreak(userId);
      await _achievementRepository.checkAndUnlock(userId, 'streak_update', {
        'streak': streak.currentStreak + 1,
      });
    }
  }

  Future<void> checkAndUnlockAchievements(String userId, String eventType, Map<String, dynamic> data) async {
    await _achievementRepository.checkAndUnlock(userId, eventType, data);
  }

  int _calculateLevel(int xp) {
    final levels = [0, 200, 500, 1000, 2000, 4000, 7000, 12000, 20000];
    for (int i = levels.length - 1; i >= 0; i--) {
      if (xp >= levels[i]) return i + 1;
    }
    return 1;
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class LeaderboardService {
  final LeaderboardRepository _leaderboardRepository;
  final UserRepository _userRepository;
  final CacheRepository _cacheRepository;

  LeaderboardService({
    required LeaderboardRepository leaderboardRepository,
    required UserRepository userRepository,
    required CacheRepository cacheRepository,
  })  : _leaderboardRepository = leaderboardRepository,
        _userRepository = userRepository,
        _cacheRepository = cacheRepository;

  Future<List<LeaderboardEntryModel>> getWeeklyLeaderboard({int limit = 100, int offset = 0}) async {
    final cacheKey = 'leaderboard_weekly_${limit}_$offset';
    final cached = await _cacheRepository.get(cacheKey);
    if (cached != null) {
      return (cached as List<dynamic>)
          .map((e) => LeaderboardEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final entries = await _leaderboardRepository.getWeekly(limit: limit, offset: offset);
    await _cacheRepository.set(
      cacheKey,
      entries.map((e) => e.toJson()).toList(),
      ttl: const Duration(minutes: 5),
    );
    return entries;
  }

  Future<List<LeaderboardEntryModel>> getAllTimeLeaderboard({int limit = 100, int offset = 0}) async {
    final cacheKey = 'leaderboard_alltime_${limit}_$offset';
    final cached = await _cacheRepository.get(cacheKey);
    if (cached != null) {
      return (cached as List<dynamic>)
          .map((e) => LeaderboardEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final entries = await _leaderboardRepository.getAllTime(limit: limit, offset: offset);
    await _cacheRepository.set(
      cacheKey,
      entries.map((e) => e.toJson()).toList(),
      ttl: const Duration(minutes: 10),
    );
    return entries;
  }

  Future<List<LeaderboardEntryModel>> getFriendsLeaderboard(String userId, {int limit = 100, int offset = 0}) async {
    return _leaderboardRepository.getFriends(userId, limit: limit, offset: offset);
  }

  Future<int> getUserRank(String userId) async {
    return _leaderboardRepository.getUserRank(userId);
  }

  Future<Map<String, dynamic>> getUserLeaderboardStats(String userId) async {
    final rank = await _leaderboardRepository.getUserRank(userId);
    final weeklyRank = await _leaderboardRepository.getUserWeeklyRank(userId);
    final totalParticipants = await _leaderboardRepository.getTotalParticipants();

    return {
      'rank': rank,
      'weeklyRank': weeklyRank,
      'totalParticipants': totalParticipants,
      'percentile': totalParticipants > 0 ? ((rank / totalParticipants) * 100) : 0.0,
    };
  }
}

class NotificationService {
  final NotificationRepository _notificationRepository;
  final PushNotificationRepository _pushNotificationRepository;
  final EmailRepository _emailRepository;

  NotificationService({
    required NotificationRepository notificationRepository,
    required PushNotificationRepository pushNotificationRepository,
    required EmailRepository emailRepository,
  })  : _notificationRepository = notificationRepository,
        _pushNotificationRepository = pushNotificationRepository,
        _emailRepository = emailRepository;

  Future<List<NotificationModel>> getUserNotifications(String userId, {int limit = 50, int offset = 0}) async {
    return _notificationRepository.getByUser(userId, limit: limit, offset: offset);
  }

  Future<int> getUnreadCount(String userId) async {
    return _notificationRepository.getUnreadCount(userId);
  }

  Future<void> markAsRead(String notificationId) async {
    await _notificationRepository.markAsRead(notificationId);
  }

  Future<void> markAllAsRead(String userId) async {
    await _notificationRepository.markAllAsRead(userId);
  }

  Future<void> sendNotification(String userId, String title, String body, NotificationType type) async {
    final notification = NotificationModel(
      id: _generateId(),
      userId: userId,
      title: title,
      body: body,
      type: type,
      createdAt: DateTime.now(),
    );

    await _notificationRepository.create(notification);
    await _pushNotificationRepository.sendToUser(userId, title, body, {'type': type.name});
  }

  Future<void> sendAchievementNotification(String userId, String achievementName) async {
    await sendNotification(
      userId,
      'Achievement Unlocked!',
      'You unlocked the "$achievementName" achievement!',
      NotificationType.achievement,
    );
  }

  Future<void> sendStreakReminder(String userId, int streak) async {
    await sendNotification(
      userId,
      'Streak at Risk!',
      'Your $streak day streak is at risk. Complete a lesson to keep it going!',
      NotificationType.streak,
    );
  }

  Future<void> sendFriendRequestNotification(String userId, String fromUserName) async {
    await sendNotification(
      userId,
      'New Friend Request',
      '$fromUserName sent you a friend request!',
      NotificationType.friendRequest,
    );
  }

  Future<void> sendLevelUpNotification(String userId, int level) async {
    await sendNotification(
      userId,
      'Level Up!',
      'Congratulations! You reached level $level!',
      NotificationType.levelUp,
    );
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class SocialService {
  final SocialRepository _socialRepository;
  final FriendRepository _friendRepository;
  final NotificationRepository _notificationRepository;

  SocialService({
    required SocialRepository socialRepository,
    required FriendRepository friendRepository,
    required NotificationRepository notificationRepository,
  })  : _socialRepository = socialRepository,
        _friendRepository = friendRepository,
        _notificationRepository = notificationRepository;

  Future<List<SocialPostModel>> getFeed(String userId, {int limit = 20, int offset = 0}) async {
    return _socialRepository.getFriendsPosts(userId, limit: limit, offset: offset);
  }

  Future<SocialPostModel> createPost(String userId, String content, {String? imageUrl}) async {
    return _socialRepository.createPost(userId, content, imageUrl: imageUrl);
  }

  Future<void> likePost(String postId, String userId) async {
    await _socialRepository.likePost(postId, userId);
  }

  Future<void> unlikePost(String postId, String userId) async {
    await _socialRepository.unlikePost(postId, userId);
  }

  Future<SocialCommentModel> addComment(String postId, String userId, String content) async {
    return _socialRepository.addComment(postId, userId, content);
  }

  Future<List<FriendModel>> getFriends(String userId) async {
    return _friendRepository.getFriends(userId);
  }

  Future<void> sendFriendRequest(String fromUserId, String toUserId) async {
    await _friendRepository.sendRequest(fromUserId, toUserId);
    await _notificationRepository.create(NotificationModel(
      id: _generateId(),
      userId: toUserId,
      title: 'Friend Request',
      body: 'You have a new friend request!',
      type: NotificationType.friendRequest,
      createdAt: DateTime.now(),
    ));
  }

  Future<void> acceptFriendRequest(String requestId) async {
    await _friendRepository.acceptRequest(requestId);
  }

  Future<void> removeFriend(String userId, String friendId) async {
    await _friendRepository.removeFriend(userId, friendId);
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class AchievementService {
  final AchievementRepository _achievementRepository;
  final UserBadgeRepository _userBadgeRepository;
  final NotificationRepository _notificationRepository;
  final XPTransactionRepository _xpTransactionRepository;

  AchievementService({
    required AchievementRepository achievementRepository,
    required UserBadgeRepository userBadgeRepository,
    required NotificationRepository notificationRepository,
    required XPTransactionRepository xpTransactionRepository,
  })  : _achievementRepository = achievementRepository,
        _userBadgeRepository = userBadgeRepository,
        _notificationRepository = notificationRepository,
        _xpTransactionRepository = xpTransactionRepository;

  Future<List<AchievementModel>> getAllAchievements() async {
    return _achievementRepository.getAll();
  }

  Future<List<AchievementModel>> getUserAchievements(String userId) async {
    return _achievementRepository.getUnlocked(userId);
  }

  Future<double> getCompletionPercent(String userId) async {
    return _achievementRepository.getCompletionPercent(userId);
  }

  Future<void> checkAndUnlock(String userId, String eventType, Map<String, dynamic> data) async {
    final available = await _achievementRepository.getAvailableForUnlock(userId);
    for (final achievement in available) {
      final shouldUnlock = _evaluateAchievement(achievement, eventType, data);
      if (shouldUnlock) {
        await _unlockAchievement(userId, achievement);
      }
    }
  }

  Future<void> _unlockAchievement(String userId, AchievementModel achievement) async {
    await _achievementRepository.unlock(userId, achievement.id);
    await _userBadgeRepository.create(UserBadgeModel(
      id: _generateId(),
      userId: userId,
      achievementId: achievement.id,
      name: achievement.name,
      description: achievement.description,
      icon: achievement.icon,
      xpReward: achievement.xpReward,
      rarityLevel: achievement.rarityLevel,
      unlockedAt: DateTime.now(),
    ));

    await _xpTransactionRepository.create(XPTransactionModel(
      id: _generateId(),
      userId: userId,
      amount: achievement.xpReward,
      type: XPTransactionType.bonus,
      source: 'achievement',
      description: 'Achievement unlocked: ${achievement.name}',
      createdAt: DateTime.now(),
    ));

    await _notificationRepository.create(NotificationModel(
      id: _generateId(),
      userId: userId,
      title: 'Achievement Unlocked!',
      body: 'You unlocked "${achievement.name}" and earned ${achievement.xpReward} XP!',
      type: NotificationType.achievement,
      createdAt: DateTime.now(),
    ));
  }

  bool _evaluateAchievement(AchievementModel achievement, String eventType, Map<String, dynamic> data) {
    // Simplified evaluation logic
    return false;
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class SearchService {
  final SearchRepository _searchRepository;
  final CacheRepository _cacheRepository;

  SearchService({
    required SearchRepository searchRepository,
    required CacheRepository cacheRepository,
  })  : _searchRepository = searchRepository,
        _cacheRepository = cacheRepository;

  Future<Map<String, dynamic>> searchAll(String query) async {
    final cacheKey = 'search_$query';
    final cached = await _cacheRepository.get(cacheKey);
    if (cached != null) {
      return cached as Map<String, dynamic>;
    }

    final results = {
      'courses': await _searchRepository.searchCourses(query),
      'lessons': await _searchRepository.searchLessons(query),
      'users': await _searchRepository.searchUsers(query),
      'challenges': await _searchRepository.searchChallenges(query),
    };

    await _cacheRepository.set(cacheKey, results, ttl: const Duration(minutes: 2));
    return results;
  }

  Future<List<String>> getSuggestions(String query) async {
    return _searchRepository.getSuggestions(query);
  }

  Future<List<String>> getPopularSearches() async {
    return _searchRepository.getPopularSearches();
  }
}

class AnalyticsService {
  final AnalyticsEventRepository _eventRepository;
  final UserAnalyticsRepository _userAnalyticsRepository;
  final MetricsCollector _metricsCollector;

  AnalyticsService({
    required AnalyticsEventRepository eventRepository,
    required UserAnalyticsRepository userAnalyticsRepository,
  })  : _eventRepository = eventRepository,
        _userAnalyticsRepository = userAnalyticsRepository,
        _metricsCollector = MetricsCollector();

  Future<void> trackEvent(String event, Map<String, dynamic> properties) async {
    await _eventRepository.track(event, properties);
    _metricsCollector.increment('event_$event');
  }

  Future<void> trackScreenView(String screenName) async {
    await _eventRepository.trackScreenView(screenName);
    _metricsCollector.increment('screen_view_$screenName');
  }

  Future<void> trackUserAction(String action, Map<String, dynamic> properties) async {
    await _eventRepository.trackUserAction(action, properties);
    _metricsCollector.increment('action_$action');
  }

  Future<UserAnalyticsModel?> getUserAnalytics(String userId) async {
    return _userAnalyticsRepository.getByUser(userId);
  }

  Future<void> updateUserAnalytics(String userId, Map<String, dynamic> data) async {
    await _userAnalyticsRepository.updateAnalytics(userId, data);
  }

  Map<String, dynamic> getMetrics() {
    return _metricsCollector.allMetrics;
  }
}

class EmailService {
  final EmailRepository _emailRepository;
  final QueueRepository _queueRepository;

  EmailService({
    required EmailRepository emailRepository,
    required QueueRepository queueRepository,
  })  : _emailRepository = emailRepository,
        _queueRepository = queueRepository;

  Future<void> sendWelcomeEmail(String email, String name) async {
    await _emailRepository.sendWelcomeEmail(email, name);
  }

  Future<void> sendPasswordReset(String email, String token) async {
    await _emailRepository.sendPasswordResetEmail(email, token);
  }

  Future<void> sendAchievementNotification(String email, String achievementName) async {
    await _emailRepository.sendAchievementNotification(email, achievementName);
  }

  Future<void> sendStreakReminder(String email, int streak) async {
    await _emailRepository.sendStreakReminder(email, streak);
  }

  Future<void> sendBulk(List<String> emails, String subject, String body) async {
    await _emailRepository.sendBulk(emails, subject, body);
  }
}

class FileService {
  final FileRepository _fileRepository;
  final MediaRepository _mediaRepository;

  FileService({
    required FileRepository fileRepository,
    required MediaRepository mediaRepository,
  })  : _fileRepository = fileRepository,
        _mediaRepository = mediaRepository;

  Future<String> uploadFile(String userId, List<int> bytes, String filename) async {
    return _fileRepository.upload(userId, bytes, filename);
  }

  Future<String> uploadImage(String userId, List<int> bytes, String filename) async {
    return _mediaRepository.uploadImage(userId, bytes, filename);
  }

  Future<List<int>> download(String fileId) async {
    return _fileRepository.download(fileId);
  }

  Future<void> delete(String fileId) async {
    await _fileRepository.delete(fileId);
  }
}

class CacheService {
  final CacheRepository _cacheRepository;

  CacheService({required CacheRepository cacheRepository})
      : _cacheRepository = cacheRepository;

  Future<void> set(String key, dynamic value, {Duration? ttl}) async {
    await _cacheRepository.set(key, value, ttl: ttl);
  }

  Future<dynamic> get(String key) async {
    return _cacheRepository.get(key);
  }

  Future<void> delete(String key) async {
    await _cacheRepository.delete(key);
  }

  Future<void> clear() async {
    await _cacheRepository.clear();
  }

  Future<List<String>> getKeys({String? pattern}) async {
    return _cacheRepository.getKeys(pattern: pattern) as List<String>;
  }
}

class ValidationService {
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final _passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
  static final _urlRegex = RegExp(r'^https?://');

  static bool isValidEmail(String email) => _emailRegex.hasMatch(email);
  static bool isValidPassword(String password) => _passwordRegex.hasMatch(password);
  static bool isValidUrl(String url) => _urlRegex.hasMatch(url);
  static bool isValidUsername(String username) => username.length >= 3 && username.length <= 30;
  static bool isNotEmpty(String value) => value.isNotEmpty;
  static bool isNumeric(String value) => double.tryParse(value) != null;
  static bool isLengthValid(String value, int min, int max) =>
      value.length >= min && value.length <= max;

  static List<String> validateRegistration(UserRegistrationRequest request) {
    final errors = <String>[];
    if (!isValidEmail(request.email)) errors.add('Invalid email');
    if (!isValidPassword(request.password)) errors.add('Password must be at least 8 characters with uppercase, lowercase, and number');
    if (!isValidUsername(request.name)) errors.add('Name must be 3-30 characters');
    if (request.password != request.confirmPassword) errors.add('Passwords do not match');
    return errors;
  }

  static List<String> validateLogin(UserLoginRequest request) {
    final errors = <String>[];
    if (!isValidEmail(request.email)) errors.add('Invalid email');
    if (request.password.isEmpty) errors.add('Password is required');
    return errors;
  }
}

class PasswordService {
  static String hash(String password, String salt) {
    return password + salt;
  }

  static String generateSalt() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static bool verify(String password, String salt, String hash) {
    return hashPassword(password, salt) == hash;
  }

  static String hashPassword(String password, String salt) {
    return '$password$salt';
  }

  static bool isStrong(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }
}

class TokenService {
  static String generateAccessToken(String userId) {
    return 'token_$userId\_${DateTime.now().millisecondsSinceEpoch}';
  }

  static String generateRefreshToken(String userId) {
    return 'refresh_$userId\_${DateTime.now().millisecondsSinceEpoch}';
  }

  static String? parseUserId(String token) {
    if (!token.startsWith('token_')) return null;
    return token.substring(6).split('_').first;
  }

  static bool isValid(String token) {
    return token.startsWith('token_') && token.length > 20;
  }
}
