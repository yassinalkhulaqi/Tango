abstract class Repository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<T> create(T item);
  Future<T> update(T item);
  Future<void> delete(String id);
  Future<bool> exists(String id);
  Future<int> count();
}

abstract class UserRepository implements Repository<UserModel> {
  Future<UserModel?> getByEmail(String email);
  Future<UserModel?> getByUsername(String username);
  Future<List<UserModel>> search(String query);
  Future<List<UserModel>> getByRole(String role);
  Future<void> updateLastActive(String userId);
  Future<void> updateXp(String userId, int xp);
  Future<void> updateLevel(String userId, int level);
  Future<void> updateStreak(String userId, int streak);
  Future<void> addFriend(String userId, String friendId);
  Future<void> removeFriend(String userId, String friendId);
  Future<List<String>> getFriends(String userId);
  Future<void> addBadge(String userId, String badgeId);
  Future<List<String>> getBadges(String userId);
  Future<void> verifyEmail(String userId);
  Future<void> setPasswordResetToken(String userId, String token, DateTime expiresAt);
  Future<UserModel?> getByPasswordResetToken(String token);
  Future<void> updatePassword(String userId, String passwordHash);
  Future<void> updateProfile(String userId, Map<String, dynamic> data);
  Future<void> updateSettings(String userId, Map<String, dynamic> settings);
  Future<Map<String, dynamic>> getSettings(String userId);
  Future<void> updateAvatar(String userId, String avatar);
  Future<void> updateStats(String userId, Map<String, dynamic> stats);
  Future<Map<String, dynamic>> getStats(String userId);
  Future<List<UserModel>> getLeaderboard({int limit = 100, int offset = 0});
  Future<int> getRank(String userId);
  Future<List<UserModel>> getOnlineUsers();
  Future<void> setOnlineStatus(String userId, bool isOnline);
}

abstract class CourseRepository implements Repository<CourseModel> {
  Future<List<CourseModel>> getByCategory(String category);
  Future<List<CourseModel>> getByInstructor(String instructorId);
  Future<List<CourseModel>> getFeatured();
  Future<List<CourseModel>> getNew();
  Future<List<CourseModel>> getPopular();
  Future<List<CourseModel>> search(String query);
  Future<List<CourseModel>> getByLevel(int level);
  Future<List<CourseModel>> getByTags(List<String> tags);
  Future<void> incrementEnrolledCount(String courseId);
  Future<void> decrementEnrolledCount(String courseId);
  Future<void> updateRating(String courseId, double rating);
  Future<List<CourseModel>> getRecommended(String userId);
  Future<List<CourseModel>> getPrerequisites(String courseId);
  Future<void> addPrerequisite(String courseId, String prerequisiteId);
  Future<void> removePrerequisite(String courseId, String prerequisiteId);
  Future<List<CourseModel>> getByPrerequisite(String prerequisiteId);
  Future<void> setFeatured(String courseId, bool featured);
  Future<void> setNew(String courseId, bool isNew);
  Future<void> setLocked(String courseId, bool locked);
  Future<void> updateThumbnail(String courseId, String thumbnail);
  Future<void> updateInstructor(String courseId, String instructorId, String instructorName);
  Future<List<CourseModel>> getUnassignedCourses();
  Future<int> getTotalCourses();
  Future<int> getTotalEnrollments();
  Future<double> getAverageRating();
}

abstract class LessonRepository implements Repository<LessonModel> {
  Future<List<LessonModel>> getByCourse(String courseId);
  Future<List<LessonModel>> getByCourseOrdered(String courseId);
  Future<LessonModel?> getNextLesson(String courseId, int currentOrder);
  Future<LessonModel?> getPreviousLesson(String courseId, int currentOrder);
  Future<int> getLessonCount(String courseId);
  Future<int> getCompletedLessonCount(String courseId, String userId);
  Future<void> reorderLessons(String courseId, List<String> lessonIds);
  Future<void> moveLesson(String lessonId, int newOrder);
  Future<List<LessonModel>> getLockedLessons(String courseId);
  Future<void> setLocked(String lessonId, bool locked);
  Future<void> setCompleted(String lessonId, bool completed);
  Future<List<LessonModel>> getByType(String courseId, LessonType type);
  Future<List<LessonModel>> search(String query);
  Future<void> updateContent(String lessonId, String content);
  Future<void> updateCodeExample(String lessonId, String codeExample);
  Future<void> updateExplanation(String lessonId, String explanation);
  Future<void> addTag(String lessonId, String tag);
  Future<void> removeTag(String lessonId, String tag);
  Future<List<String>> getTags(String lessonId);
  Future<void> updateMetadata(String lessonId, Map<String, dynamic> metadata);
}

abstract class QuizRepository implements Repository<QuizModel> {
  Future<List<QuizModel>> getByCourse(String courseId);
  Future<List<QuizModel>> getByLesson(String lessonId);
  Future<QuizModel?> getActiveQuiz(String userId, String lessonId);
  Future<void> submitQuiz(String userId, String quizId, List<int> answers);
  Future<double> getQuizScore(String userId, String quizId);
  Future<int> getQuizAttempts(String userId, String quizId);
  Future<void> incrementAttempts(String userId, String quizId);
  Future<void> setCompleted(String userId, String quizId, double score);
  Future<bool> isCompleted(String userId, String quizId);
  Future<List<QuizModel>> getCompletedQuizzes(String userId);
  Future<double> getAverageScore(String userId);
  Future<void> addQuestion(String quizId, QuizQuestion question);
  Future<void> removeQuestion(String quizId, String questionId);
  Future<void> updateQuestion(String quizId, String questionId, QuizQuestion question);
  Future<void> reorderQuestions(String quizId, List<String> questionIds);
  Future<List<QuizQuestion>> getQuestions(String quizId);
  Future<void> setTimeLimit(String quizId, int timeLimit);
  Future<void> updateTitle(String quizId, String title);
  Future<void> updateDescription(String quizId, String description);
}

abstract class ProgressRepository implements Repository<ProgressModel> {
  Future<ProgressModel?> getByUserAndLesson(String userId, String lessonId);
  Future<ProgressModel?> getByUserAndCourse(String userId, String courseId);
  Future<List<ProgressModel>> getByUser(String userId);
  Future<List<ProgressModel>> getByCourse(String courseId);
  Future<List<ProgressModel>> getByLesson(String lessonId);
  Future<double> getCourseProgress(String userId, String courseId);
  Future<double> getOverallProgress(String userId);
  Future<int> getTotalXp(String userId);
  Future<int> getCompletedLessonsCount(String userId);
  Future<int> getCompletedCoursesCount(String userId);
  Future<void> updateProgress(String userId, String lessonId, double progress);
  Future<void> markCompleted(String userId, String lessonId);
  Future<void> markIncomplete(String userId, String lessonId);
  Future<void> updateTimeSpent(String userId, String lessonId, int minutes);
  Future<int> getTotalTimeSpent(String userId);
  Future<void> resetProgress(String userId, String courseId);
  Future<void> deleteByUser(String userId);
  Future<void> deleteByCourse(String courseId);
  Future<void> deleteByLesson(String lessonId);
  Future<List<ProgressModel>> getRecentProgress(String userId, {int limit = 10});
  Future<List<ProgressModel>> getStreakProgress(String userId);
  Future<DateTime?> getLastActivityDate(String userId);
  Future<void> updateLastActivityDate(String userId);
}

abstract class LeaderboardRepository {
  Future<List<LeaderboardEntryModel>> getWeekly({int limit = 100, int offset = 0});
  Future<List<LeaderboardEntryModel>> getMonthly({int limit = 100, int offset = 0});
  Future<List<LeaderboardEntryModel>> getAllTime({int limit = 100, int offset = 0});
  Future<List<LeaderboardEntryModel>> getFriends(String userId, {int limit = 100, int offset = 0});
  Future<int> getUserRank(String userId);
  Future<int> getUserWeeklyRank(String userId);
  Future<int> getUserMonthlyRank(String userId);
  Future<int> getUserAllTimeRank(String userId);
  Future<int> getUserFriendsRank(String userId);
  Future<List<LeaderboardEntryModel>> getTopUsers({int limit = 10});
  Future<List<LeaderboardEntryModel>> getTopFriends(String userId, {int limit = 10});
  Future<void> updateRankings();
  Future<void> resetWeekly();
  Future<void> resetMonthly();
  Future<int> getTotalParticipants();
  Future<Map<String, int>> getRankDistribution();
}

abstract class AchievementRepository implements Repository<AchievementModel> {
  Future<List<AchievementModel>> getByCategory(String category);
  Future<List<AchievementModel>> getByRarity(int rarityLevel);
  Future<List<AchievementModel>> getUnlocked(String userId);
  Future<List<AchievementModel>> getLocked(String userId);
  Future<List<AchievementModel>> getInProgress(String userId);
  Future<bool> isUnlocked(String userId, String achievementId);
  Future<void> unlock(String userId, String achievementId);
  Future<void> updateProgress(String userId, String achievementId, int progress);
  Future<int> getProgress(String userId, String achievementId);
  Future<List<AchievementModel>> getRecentUnlocks(String userId, {int limit = 10});
  Future<int> getTotalUnlocked(String userId);
  Future<int> getTotalLocked(String userId);
  Future<double> getCompletionPercent(String userId);
  Future<void> checkAndUnlock(String userId, String eventType, Map<String, dynamic> data);
  Future<List<AchievementModel>> getAvailableForUnlock(String userId);
}

abstract class SocialRepository {
  Future<List<SocialPostModel>> getPosts({int limit = 20, int offset = 0});
  Future<List<SocialPostModel>> getUserPosts(String userId, {int limit = 20, int offset = 0});
  Future<List<SocialPostModel>> getFriendsPosts(String userId, {int limit = 20, int offset = 0});
  Future<SocialPostModel?> getPost(String postId);
  Future<SocialPostModel> createPost(String userId, String content, {String? imageUrl});
  Future<void> deletePost(String postId, String userId);
  Future<void> likePost(String postId, String userId);
  Future<void> unlikePost(String postId, String userId);
  Future<bool> isLiked(String postId, String userId);
  Future<List<String>> getLikes(String postId);
  Future<SocialCommentModel> addComment(String postId, String userId, String content);
  Future<void> deleteComment(String commentId, String userId);
  Future<List<SocialCommentModel>> getComments(String postId);
  Future<int> getCommentCount(String postId);
  Future<void> updatePost(String postId, String userId, String content);
  Future<void> reportPost(String postId, String userId, String reason);
  Future<List<SocialPostModel>> getReportedPosts();
  Future<void> moderatePost(String postId, String action);
  Future<void> pinPost(String postId, bool pinned);
  Future<List<SocialPostModel>> getPinnedPosts();
}

abstract class FriendRepository {
  Future<List<FriendModel>> getFriends(String userId);
  Future<List<FriendRequestModel>> getSentRequests(String userId);
  Future<List<FriendRequestModel>> getReceivedRequests(String userId);
  Future<void> sendRequest(String fromUserId, String toUserId);
  Future<void> acceptRequest(String requestId);
  Future<void> rejectRequest(String requestId);
  Future<void> cancelRequest(String requestId);
  Future<void> removeFriend(String userId, String friendId);
  Future<bool> areFriends(String userId, String friendId);
  Future<bool> hasPendingRequest(String userId, String friendId);
  Future<int> getFriendCount(String userId);
  Future<int> getPendingRequestCount(String userId);
  Future<List<FriendModel>> getOnlineFriends(String userId);
  Future<List<FriendModel>> getSuggestedFriends(String userId);
  Future<List<FriendModel>> searchFriends(String userId, String query);
  Future<void> blockUser(String userId, String blockedUserId);
  Future<void> unblockUser(String userId, String blockedUserId);
  Future<bool> isBlocked(String userId, String blockedUserId);
  Future<List<FriendModel>> getBlockedUsers(String userId);
  Future<void> muteUser(String userId, String mutedUserId);
  Future<void> unmuteUser(String userId, String mutedUserId);
  Future<bool> isMuted(String userId, String mutedUserId);
}

abstract class NotificationRepository implements Repository<NotificationModel> {
  Future<List<NotificationModel>> getByUser(String userId, {int limit = 50, int offset = 0});
  Future<List<NotificationModel>> getUnread(String userId);
  Future<int> getUnreadCount(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> markAsUnread(String notificationId);
  Future<void> deleteNotification(String notificationId);
  Future<void> deleteAllForUser(String userId);
  Future<void> deleteReadForUser(String userId);
  Future<List<NotificationModel>> getByType(String userId, NotificationType type);
  Future<List<NotificationModel>> getRecent(String userId, {int limit = 10});
  Future<void> sendNotification(String userId, String title, String body, NotificationType type);
  Future<void> sendBulkNotification(List<String> userIds, String title, String body, NotificationType type);
  Future<void> scheduleNotification(String userId, String title, String body, NotificationType type, DateTime scheduledAt);
  Future<List<NotificationModel>> getScheduledNotifications();
  Future<void> cancelScheduledNotification(String notificationId);
  Future<void> updateNotificationData(String notificationId, Map<String, dynamic> data);
  Future<Map<String, dynamic>> getNotificationData(String notificationId);
}

abstract class CategoryRepository implements Repository<CategoryModel> {
  Future<List<CategoryModel>> getActive();
  Future<List<CategoryModel>> getLocked();
  Future<void> setLocked(String categoryId, bool locked);
  Future<void> updateCourseCount(String categoryId);
  Future<void> updateLessonCount(String categoryId);
  Future<CategoryModel?> getByName(String name);
  Future<List<CategoryModel>> getByRequiredLevel(int level);
  Future<void> reorderCategories(List<String> categoryIds);
  Future<void> updateIcon(String categoryId, String icon);
  Future<void> updateColor(String categoryId, String color);
}

abstract class TagRepository implements Repository<TagModel> {
  Future<List<TagModel>> getByUsage({int limit = 20});
  Future<TagModel?> getByName(String name);
  Future<void> incrementUsage(String tagId);
  Future<void> decrementUsage(String tagId);
  Future<List<TagModel>> search(String query);
  Future<List<TagModel>> getByCourse(String courseId);
  Future<List<TagModel>> getByLesson(String lessonId);
  Future<void> addTagToCourse(String courseId, String tagId);
  Future<void> removeTagFromCourse(String courseId, String tagId);
  Future<void> addTagToLesson(String lessonId, String tagId);
  Future<void> removeTagFromLesson(String lessonId, String tagId);
}

abstract class EnrollmentRepository implements Repository<CourseEnrollmentModel> {
  Future<CourseEnrollmentModel?> getByUserAndCourse(String userId, String courseId);
  Future<List<CourseEnrollmentModel>> getByUser(String userId);
  Future<List<CourseEnrollmentModel>> getByCourse(String courseId);
  Future<List<CourseEnrollmentModel>> getCompleted(String userId);
  Future<List<CourseEnrollmentModel>> getInProgress(String userId);
  Future<List<CourseEnrollmentModel>> getNotStarted(String userId);
  Future<bool> isEnrolled(String userId, String courseId);
  Future<void> enroll(String userId, String courseId);
  Future<void> unenroll(String userId, String courseId);
  Future<void> updateProgress(String userId, String courseId, double progress);
  Future<void> markCompleted(String userId, String courseId);
  Future<int> getEnrollmentCount(String courseId);
  Future<int> getCompletedCount(String courseId);
  Future<List<String>> getEnrolledUserIds(String courseId);
  Future<void> deleteByUser(String userId);
  Future<void> deleteByCourse(String courseId);
}

abstract class ReviewRepository implements Repository<CourseReviewModel> {
  Future<List<CourseReviewModel>> getByCourse(String courseId);
  Future<List<CourseReviewModel>> getByUser(String userId);
  Future<CourseReviewModel?> getByUserAndCourse(String userId, String courseId);
  Future<double> getAverageRating(String courseId);
  Future<int> getReviewCount(String courseId);
  Future<Map<int, int>> getRatingDistribution(String courseId);
  Future<void> updateRating(String courseId);
  Future<void> deleteByUser(String userId);
  Future<void> deleteByCourse(String courseId);
  Future<List<CourseReviewModel>> getRecent({int limit = 10});
  Future<List<CourseReviewModel>> getPositive(String courseId);
  Future<List<CourseReviewModel>> getNegative(String courseId);
}

abstract class CertificateRepository implements Repository<CertificateModel> {
  Future<List<CertificateModel>> getByUser(String userId);
  Future<CertificateModel?> getByUserAndCourse(String userId, String courseId);
  Future<CertificateModel?> getByVerificationCode(String code);
  Future<bool> verify(String verificationCode);
  Future<void> revoke(String certificateId);
  Future<int> getTotalIssued();
  Future<List<CertificateModel>> getRecent({int limit = 10});
  Future<void> updateUrl(String certificateId, String url);
}

abstract class XPTransactionRepository implements Repository<XPTransactionModel> {
  Future<List<XPTransactionModel>> getByUser(String userId);
  Future<List<XPTransactionModel>> getByUserAndType(String userId, XPTransactionType type);
  Future<int> getTotalEarned(String userId);
  Future<int> getTotalSpent(String userId);
  Future<List<XPTransactionModel>> getRecent(String userId, {int limit = 20});
  Future<void> deleteByUser(String userId);
  Future<int> getDailyEarnings(String userId);
  Future<int> getWeeklyEarnings(String userId);
  Future<int> getMonthlyEarnings(String userId);
}

abstract class StreakRepository {
  Future<StreakModel?> getByUser(String userId);
  Future<void> updateStreak(String userId, int streak);
  Future<void> incrementStreak(String userId);
  Future<void> resetStreak(String userId);
  Future<void> useStreakFreeze(String userId);
  Future<void> addStreakFreeze(String userId);
  Future<int> getStreakFreezeCount(String userId);
  Future<void> updateLastActivityDate(String userId);
  Future<bool> isStreakAtRisk(String userId);
  Future<bool> isStreakBroken(String userId);
  Future<List<String>> getUsersWithBrokenStreaks();
  Future<void> notifyUsersWithBrokenStreaks();
}

abstract class ChallengeRepository implements Repository<ChallengeModel> {
  Future<List<ChallengeModel>> getByCategory(String category);
  Future<List<ChallengeModel>> getByDifficulty(int difficulty);
  Future<List<ChallengeModel>> getCompleted(String userId);
  Future<List<ChallengeModel>> getIncomplete(String userId);
  Future<bool> isCompleted(String userId, String challengeId);
  Future<void> markCompleted(String userId, String challengeId);
  Future<List<ChallengeModel>> getDaily();
  Future<DailyChallengeModel?> getDailyChallenge(String userId);
  Future<List<DailyChallengeModel>> getDailyChallenges();
  Future<void> updateDailyChallenge(String userId, String challengeId);
  Future<List<ChallengeModel>> search(String query);
  Future<void> addTestCase(String challengeId, String testCase);
  Future<void> removeTestCase(String challengeId, String testCase);
  Future<List<String>> getTestCases(String challengeId);
  Future<void> updateStarterCode(String challengeId, String code);
  Future<void> updateSolution(String challengeId, String solution);
}

abstract class CodeSubmissionRepository implements Repository<CodeSubmissionModel> {
  Future<List<CodeSubmissionModel>> getByUser(String userId);
  Future<List<CodeSubmissionModel>> getByLesson(String lessonId);
  Future<List<CodeSubmissionModel>> getByUserAndLesson(String userId, String lessonId);
  Future<int> getAttemptCount(String userId, String lessonId);
  Future<CodeSubmissionModel?> getLastSubmission(String userId, String lessonId);
  Future<List<CodeSubmissionModel>> getSuccessfulSubmissions(String userId);
  Future<List<CodeSubmissionModel>> getFailedSubmissions(String userId);
  Future<void> deleteByUser(String userId);
  Future<void> deleteByLesson(String lessonId);
  Future<double> getSuccessRate(String userId);
  Future<int> getTotalAttempts(String userId);
}

abstract class ModuleRepository implements Repository<CourseModuleModel> {
  Future<List<CourseModuleModel>> getByCourse(String courseId);
  Future<List<CourseModuleModel>> getByCourseOrdered(String courseId);
  Future<void> reorderModules(String courseId, List<String> moduleIds);
  Future<void> moveModule(String moduleId, int newOrder);
  Future<void> addLessonToModule(String moduleId, String lessonId);
  Future<void> removeLessonFromModule(String moduleId, String lessonId);
  Future<List<String>> getLessons(String moduleId);
  Future<void> setCompleted(String moduleId, bool completed);
  Future<int> getModuleCount(String courseId);
  Future<int> getCompletedModuleCount(String courseId);
  Future<void> updateTitle(String moduleId, String title);
  Future<void> updateDescription(String moduleId, String description);
}

abstract class AssignmentRepository implements Repository<CourseAssignmentModel> {
  Future<List<CourseAssignmentModel>> getByCourse(String courseId);
  Future<List<CourseAssignmentModel>> getByModule(String moduleId);
  Future<List<CourseAssignmentModel>> getCompleted(String userId);
  Future<List<CourseAssignmentModel>> getPending(String userId);
  Future<List<CourseAssignmentModel>> getOverdue(String userId);
  Future<bool> isCompleted(String userId, String assignmentId);
  Future<void> submit(String userId, String assignmentId);
  Future<void> grade(String userId, String assignmentId, double grade, String feedback);
  Future<double?> getGrade(String userId, String assignmentId);
  Future<String?> getFeedback(String userId, String assignmentId);
  Future<List<CourseAssignmentModel>> getGraded(String userId);
  Future<List<CourseAssignmentModel>> getUngraded();
  Future<void> deleteByCourse(String courseId);
  Future<void> deleteByModule(String moduleId);
}

abstract class AnnouncementRepository implements Repository<CourseAnnouncementModel> {
  Future<List<CourseAnnouncementModel>> getByCourse(String courseId);
  Future<List<CourseAnnouncementModel>> getPinned(String courseId);
  Future<List<CourseAnnouncementModel>> getRecent(String courseId, {int limit = 10});
  Future<void> pin(String announcementId, bool pinned);
  Future<void> deleteByCourse(String courseId);
  Future<void> deleteByInstructor(String instructorId);
  Future<int> getCount(String courseId);
  Future<List<CourseAnnouncementModel>> search(String query);
}

abstract class DiscussionRepository implements Repository<CourseDiscussionModel> {
  Future<List<CourseDiscussionModel>> getByCourse(String courseId);
  Future<List<CourseDiscussionModel>> getByUser(String userId);
  Future<List<CourseDiscussionModel>> getPinned(String courseId);
  Future<List<CourseDiscussionModel>> getRecent(String courseId, {int limit = 20});
  Future<List<CourseDiscussionModel>> search(String query);
  Future<void> pin(String discussionId, bool pinned);
  Future<void> like(String discussionId, String userId);
  Future<void> unlike(String discussionId, String userId);
  Future<bool> isLiked(String discussionId, String userId);
  Future<List<String>> getLikes(String discussionId);
  Future<int> getLikeCount(String discussionId);
  Future<void> incrementReplies(String discussionId);
  Future<void> decrementReplies(String discussionId);
  Future<void> deleteByCourse(String courseId);
  Future<void> deleteByUser(String userId);
}

abstract class DiscussionReplyRepository implements Repository<CourseDiscussionReplyModel> {
  Future<List<CourseDiscussionReplyModel>> getByDiscussion(String discussionId);
  Future<List<CourseDiscussionReplyModel>> getByUser(String userId);
  Future<void> like(String replyId, String userId);
  Future<void> unlike(String replyId, String userId);
  Future<bool> isLiked(String replyId, String userId);
  Future<List<String>> getLikes(String replyId);
  Future<int> getLikeCount(String replyId);
  Future<void> deleteByDiscussion(String discussionId);
  Future<void> deleteByUser(String userId);
  Future<int> getReplyCount(String discussionId);
}

abstract class DiscussionReportRepository implements Repository<CourseDiscussionReportModel> {
  Future<List<CourseDiscussionReportModel>> getByDiscussion(String discussionId);
  Future<List<CourseDiscussionReportModel>> getByUser(String userId);
  Future<List<CourseDiscussionReportModel>> getPending();
  Future<List<CourseDiscussionReportModel>> getResolved();
  Future<void> resolve(String reportId, String adminNotes);
  Future<void> dismiss(String reportId);
  Future<void> deleteByDiscussion(String discussionId);
  Future<void> deleteByUser(String userId);
  Future<int> getPendingCount();
  Future<int> getResolvedCount();
}

abstract class UserBadgeRepository implements Repository<UserBadgeModel> {
  Future<List<UserBadgeModel>> getByUser(String userId);
  Future<UserBadgeModel?> getByUserAndAchievement(String userId, String achievementId);
  Future<bool> hasBadge(String userId, String achievementId);
  Future<List<UserBadgeModel>> getRecent(String userId, {int limit = 10});
  Future<int> getCount(String userId);
  Future<int> getRareCount(String userId);
  Future<void> deleteByUser(String userId);
  Future<void> deleteByAchievement(String achievementId);
  Future<List<UserBadgeModel>> getByRarity(String userId, int rarityLevel);
}

abstract class UserSettingsRepository {
  Future<UserSettingsModel?> getByUser(String userId);
  Future<void> updateSettings(String userId, Map<String, dynamic> settings);
  Future<void> setNotifications(String userId, bool enabled);
  Future<void> setDarkMode(String userId, bool enabled);
  Future<void> setLanguage(String userId, String language);
  Future<void> setTheme(String userId, String theme);
  Future<void> setFontSize(String userId, double size);
  Future<void> setHapticFeedback(String userId, bool enabled);
  Future<void> setReducedMotion(String userId, bool enabled);
  Future<void> resetToDefaults(String userId);
  Future<void> deleteByUser(String userId);
}

abstract class UserActivityRepository implements Repository<UserActivityModel> {
  Future<List<UserActivityModel>> getByUser(String userId);
  Future<List<UserActivityModel>> getByUserAndType(String userId, ActivityType type);
  Future<List<UserActivityModel>> getRecent(String userId, {int limit = 20});
  Future<List<UserActivityModel>> getByDateRange(String userId, DateTime start, DateTime end);
  Future<void> deleteByUser(String userId);
  Future<void> deleteOlderThan(DateTime date);
  Future<int> getCount(String userId);
  Future<int> getCountByType(String userId, ActivityType type);
  Future<Map<ActivityType, int>> getTypeBreakdown(String userId);
}

abstract class UserAnalyticsRepository {
  Future<UserAnalyticsModel?> getByUser(String userId);
  Future<void> updateAnalytics(String userId, Map<String, dynamic> data);
  Future<void> incrementLessons(String userId);
  Future<void> incrementQuizzes(String userId);
  Future<void> incrementChallenges(String userId);
  Future<void> incrementCourses(String userId);
  Future<void> addXp(String userId, int xp);
  Future<void> updateStreak(String userId, int streak);
  Future<void> updateAccuracy(String userId, double accuracy);
  Future<void> addTimeSpent(String userId, int minutes);
  Future<void> updateLastActive(String userId);
  Future<void> deleteByUser(String userId);
}

abstract class SessionRepository {
  Future<UserSession?> getById(String sessionId);
  Future<UserSession?> getByToken(String token);
  Future<List<UserSession>> getByUser(String userId);
  Future<List<UserSession>> getActiveByUser(String userId);
  Future<void> create(UserSession session);
  Future<void> update(UserSession session);
  Future<void> delete(String sessionId);
  Future<void> deleteByUser(String userId);
  Future<void> deleteExpired();
  Future<void> invalidate(String sessionId);
  Future<void> invalidateAll(String userId);
  Future<int> getActiveCount(String userId);
  Future<bool> isValid(String token);
}

abstract class ApiKeyRepository implements Repository<ApiKey> {
  Future<ApiKey?> getByKey(String key);
  Future<List<ApiKey>> getByUser(String userId);
  Future<void> revoke(String keyId);
  Future<void> deleteExpired();
  Future<void> deleteByUser(String userId);
  Future<bool> isValid(String key);
  Future<int> getCount(String userId);
}

abstract class RoleRepository implements Repository<Role> {
  Future<Role?> getByName(String name);
  Future<List<Role>> getDefault();
  Future<List<Permission>> getPermissions(String roleId);
  Future<void> addPermission(String roleId, String permission);
  Future<void> removePermission(String roleId, String permission);
  Future<List<String>> getUserRoles(String userId);
  Future<void> assignRole(String userId, String roleId);
  Future<void> removeRole(String userId, String roleId);
  Future<bool> hasRole(String userId, String roleName);
  Future<bool> hasPermission(String userId, String permission);
}

abstract class PermissionRepository implements Repository<Permission> {
  Future<Permission?> getByName(String name);
  Future<Permission?> getByResourceAndAction(String resource, String action);
  Future<List<Permission>> getByResource(String resource);
  Future<List<Permission>> getByAction(String action);
  Future<List<Permission>> getAllGrouped();
}

abstract class AuditRepository {
  Future<void> log(String action, String userId, Map<String, dynamic> details);
  Future<List<Map<String, dynamic>>> getByUser(String userId);
  Future<List<Map<String, dynamic>>> getByAction(String action);
  Future<List<Map<String, dynamic>>> getByDateRange(DateTime start, DateTime end);
  Future<List<Map<String, dynamic>>> getRecent({int limit = 100});
  Future<void> deleteOlderThan(DateTime date);
  Future<int> getCount();
  Future<Map<String, int>> getActionBreakdown();
}

abstract class CacheRepository {
  Future<void> set(String key, dynamic value, {Duration? ttl});
  Future<dynamic> get(String key);
  Future<bool> has(String key);
  Future<void> delete(String key);
  Future<void> deleteMany(List<String> keys);
  Future<void> clear();
  Future<List<String>> getKeys({String? pattern});
  Future<int> getSize();
  Future<void> flush();
  Future<Map<String, dynamic>> getStats();
}

abstract class FileRepository {
  Future<String> upload(String userId, List<int> bytes, String filename);
  Future<List<int>> download(String fileId);
  Future<void> delete(String fileId);
  Future<bool> exists(String fileId);
  Future<String?> getUrl(String fileId);
  Future<int> getSize(String fileId);
  Future<String?> getContentType(String fileId);
  Future<List<String>> getUserFiles(String userId);
  Future<void> deleteUserFiles(String userId);
}

abstract class SearchRepository {
  Future<List<Map<String, dynamic>>> searchCourses(String query);
  Future<List<Map<String, dynamic>>> searchLessons(String query);
  Future<List<Map<String, dynamic>>> searchUsers(String query);
  Future<List<Map<String, dynamic>>> searchChallenges(String query);
  Future<List<Map<String, dynamic>>> searchAll(String query);
  Future<List<String>> getSuggestions(String query);
  Future<List<String>> getPopularSearches();
  Future<void> indexCourse(String courseId);
  Future<void> indexLesson(String lessonId);
  Future<void> indexUser(String userId);
  Future<void> removeFromIndex(String type, String id);
}

abstract class EmailRepository {
  Future<void> sendWelcomeEmail(String email, String name);
  Future<void> sendPasswordResetEmail(String email, String token);
  Future<void> sendEmailVerification(String email, String token);
  Future<void> sendAchievementNotification(String email, String achievementName);
  Future<void> sendStreakReminder(String email, int streak);
  Future<void> sendCourseCompletionEmail(String email, String courseName);
  Future<void> sendWeeklyDigest(String email, Map<String, dynamic> data);
  Future<void> sendTransactional(String email, String subject, String body);
  Future<void> sendBulk(List<String> emails, String subject, String body);
}

abstract class PushNotificationRepository {
  Future<void> sendToUser(String userId, String title, String body, Map<String, dynamic> data);
  Future<void> sendToUsers(List<String> userIds, String title, String body, Map<String, dynamic> data);
  Future<void> sendToTopic(String topic, String title, String body, Map<String, dynamic> data);
  Future<void> subscribeToTopic(String userId, String topic);
  Future<void> unsubscribeFromTopic(String userId, String topic);
  Future<List<String>> getUserTopics(String userId);
  Future<void> sendDataMessage(String userId, Map<String, dynamic> data);
}

abstract class ReportRepository {
  Future<Map<String, dynamic>> generateUserReport(String userId);
  Future<Map<String, dynamic>> generateCourseReport(String courseId);
  Future<Map<String, dynamic>> generatePlatformReport();
  Future<Map<String, dynamic>> generateEngagementReport();
  Future<Map<String, dynamic>> generateRevenueReport();
  Future<void> scheduleReport(String type, String frequency);
  Future<List<Map<String, dynamic>>> getScheduledReports();
  Future<void> cancelScheduledReport(String reportId);
}

abstract class IntegrationRepository {
  Future<void> syncWithCRM(Map<String, dynamic> data);
  Future<void> syncWithAnalytics(Map<String, dynamic> data);
  Future<void> syncWithPaymentProvider(Map<String, dynamic> data);
  Future<void> sendWebhook(String event, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getWebhookLogs();
  Future<void> registerWebhook(String url, List<String> events);
  Future<void> unregisterWebhook(String webhookId);
  Future<List<Map<String, dynamic>>> getWebhooks();
}

abstract class LocalizationRepository {
  Future<Map<String, String>> getStrings(String language);
  Future<Map<String, String>> getStringsForNamespace(String language, String namespace);
  Future<void> addString(String language, String key, String value);
  Future<void> updateString(String language, String key, String value);
  Future<void> deleteString(String language, String key);
  Future<List<String>> getSupportedLanguages();
  Future<String> detectLanguage(String text);
  Future<String> translate(String text, String from, String to);
}

abstract class MediaRepository {
  Future<String> uploadImage(String userId, List<int> bytes, String filename);
  Future<String> uploadVideo(String userId, List<int> bytes, String filename);
  Future<String> uploadAudio(String userId, List<int> bytes, String filename);
  Future<String> uploadDocument(String userId, List<int> bytes, String filename);
  Future<List<int>> download(String mediaId);
  Future<void> delete(String mediaId);
  Future<String?> getUrl(String mediaId);
  Future<String?> getThumbnail(String mediaId);
  Future<void> generateThumbnail(String mediaId);
  Future<Map<String, dynamic>> getMetadata(String mediaId);
  Future<List<String>> getUserMedia(String userId);
}

abstract class AnalyticsEventRepository {
  Future<void> track(String event, Map<String, dynamic> properties);
  Future<void> trackScreenView(String screenName);
  Future<void> trackUserAction(String action, Map<String, dynamic> properties);
  Future<void> trackError(String error, Map<String, dynamic> properties);
  Future<void> trackPerformance(String metric, double value);
  Future<void> trackConversion(String goal, double value);
  Future<List<Map<String, dynamic>>> getEvents({int limit = 100});
  Future<List<Map<String, dynamic>>> getEventsByUser(String userId);
  Future<List<Map<String, dynamic>>> getEventsByType(String type);
  Future<Map<String, int>> getEventCounts({DateTime? start, DateTime? end});
  Future<void> deleteOlderThan(DateTime date);
}

abstract class FeatureFlagRepository {
  Future<bool> isEnabled(String flagName);
  Future<void> setEnabled(String flagName, bool enabled);
  Future<List<String>> getEnabledFlags();
  Future<List<String>> getDisabledFlags();
  Future<void> reset(String flagName);
  Future<void> resetAll();
  Future<Map<String, bool>> getAllFlags();
}
