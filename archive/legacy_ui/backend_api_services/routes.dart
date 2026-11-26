class ApiRoutes {
  static const String auth = '/auth';
  static const String users = '/users';
  static const String courses = '/courses';
  static const String lessons = '/lessons';
  static const String quizzes = '/quizzes';
  static const String progress = '/progress';
  static const String leaderboard = '/leaderboard';
  static const String achievements = '/achievements';
  static const String friends = '/friends';
  static const String notifications = '/notifications';
  static const String social = '/social';
  static const String search = '/search';
  static const String categories = '/categories';
  static const String tags = '/tags';
  static const String challenges = '/challenges';
  static const String analytics = '/analytics';
  static const String files = '/files';
  static const String settings = '/settings';
  static const String health = '/health';
  static const String docs = '/docs';
}

class AuthRoutes {
  static const String login = '${ApiRoutes.auth}/login';
  static const String register = '${ApiRoutes.auth}/register';
  static const String logout = '${ApiRoutes.auth}/logout';
  static const String refresh = '${ApiRoutes.auth}/refresh';
  static const String forgotPassword = '${ApiRoutes.auth}/forgot-password';
  static const String resetPassword = '${ApiRoutes.auth}/reset-password';
  static const String verifyEmail = '${ApiRoutes.auth}/verify-email';
  static const String changePassword = '${ApiRoutes.auth}/change-password';
  static const String me = '${ApiRoutes.auth}/me';
}

class UserRoutes {
  static const String profile = '${ApiRoutes.users}/profile';
  static const String settings = '${ApiRoutes.users}/settings';
  static const String stats = '${ApiRoutes.users}/stats';
  static const String preferences = '${ApiRoutes.users}/preferences';
  static const String activity = '${ApiRoutes.users}/activity';
  static const String badges = '${ApiRoutes.users}/badges';
  static const String friends = '${ApiRoutes.users}/friends';
  static const String search = '${ApiRoutes.users}/search';
  static const String leaderboard = '${ApiRoutes.users}/leaderboard';
}

class CourseRoutes {
  static const String list = ApiRoutes.courses;
  static const String featured = '${ApiRoutes.courses}/featured';
  static const String newCourses = '${ApiRoutes.courses}/new';
  static const String popular = '${ApiRoutes.courses}/popular';
  static const String recommended = '${ApiRoutes.courses}/recommended';
  static const String categories = '${ApiRoutes.courses}/categories';
  static const String enroll = '${ApiRoutes.courses}/enroll';
  static const String unenroll = '${ApiRoutes.courses}/unenroll';
  static const String progress = '${ApiRoutes.courses}/progress';
  static const String lessons = '${ApiRoutes.courses}/lessons';
  static const String modules = '${ApiRoutes.courses}/modules';
  static const String reviews = '${ApiRoutes.courses}/reviews';
  static const String certificates = '${ApiRoutes.courses}/certificates';
  static const String announcements = '${ApiRoutes.courses}/announcements';
  static const String discussions = '${ApiRoutes.courses}/discussions';
  static const String assignments = '${ApiRoutes.courses}/assignments';
  static const String students = '${ApiRoutes.courses}/students';
  static const String instructors = '${ApiRoutes.courses}/instructors';
  static const String search = '${ApiRoutes.courses}/search';
  static const String filter = '${ApiRoutes.courses}/filter';
  static const String sort = '${ApiRoutes.courses}/sort';
}

class LessonRoutes {
  static const String list = ApiRoutes.lessons;
  static const String complete = '${ApiRoutes.lessons}/complete';
  static const String incomplete = '${ApiRoutes.lessons}/incomplete';
  static const String progress = '${ApiRoutes.lessons}/progress';
  static const String code = '${ApiRoutes.lessons}/code';
  static const String run = '${ApiRoutes.lessons}/run';
  static const String submit = '${ApiRoutes.lessons}/submit';
  static const String hint = '${ApiRoutes.lessons}/hint';
  static const String solution = '${ApiRoutes.lessons}/solution';
  static const String notes = '${ApiRoutes.lessons}/notes';
  static const String bookmark = '${ApiRoutes.lessons}/bookmark';
}

class QuizRoutes {
  static const String list = ApiRoutes.quizzes;
  static const String submit = '${ApiRoutes.quizzes}/submit';
  static const String results = '${ApiRoutes.quizzes}/results';
  static const String retry = '${ApiRoutes.quizzes}/retry';
  static const String hint = '${ApiRoutes.quizzes}/hint';
  static const String explanation = '${ApiRoutes.quizzes}/explanation';
  static const String leaderboard = '${ApiRoutes.quizzes}/leaderboard';
}

class ProgressRoutes {
  static const String overall = '${ApiRoutes.progress}/overall';
  static const String course = '${ApiRoutes.progress}/course';
  static const String lesson = '${ApiRoutes.progress}/lesson';
  static const String streak = '${ApiRoutes.progress}/streak';
  static const String xp = '${ApiRoutes.progress}/xp';
  static const String stats = '${ApiRoutes.progress}/stats';
  static const String history = '${ApiRoutes.progress}/history';
  static const String achievements = '${ApiRoutes.progress}/achievements';
  static const String badges = '${ApiRoutes.progress}/badges';
  static const String certificates = '${ApiRoutes.progress}/certificates';
  static const String leaderboard = '${ApiRoutes.progress}/leaderboard';
}

class LeaderboardRoutes {
  static const String weekly = '${ApiRoutes.leaderboard}/weekly';
  static const String monthly = '${ApiRoutes.leaderboard}/monthly';
  static const String allTime = '${ApiRoutes.leaderboard}/all-time';
  static const String friends = '${ApiRoutes.leaderboard}/friends';
  static const String rank = '${ApiRoutes.leaderboard}/rank';
  static const String stats = '${ApiRoutes.leaderboard}/stats';
  static const String history = '${ApiRoutes.leaderboard}/history';
  static const String trends = '${ApiRoutes.leaderboard}/trends';
}

class AchievementRoutes {
  static const String list = ApiRoutes.achievements;
  static const String unlocked = '${ApiRoutes.achievements}/unlocked';
  static const String locked = '${ApiRoutes.achievements}/locked';
  static const String progress = '${ApiRoutes.achievements}/progress';
  static const String categories = '${ApiRoutes.achievements}/categories';
  static const String rarity = '${ApiRoutes.achievements}/rarity';
  static const String recent = '${ApiRoutes.achievements}/recent';
}

class FriendRoutes {
  static const String list = ApiRoutes.friends;
  static const String requests = '${ApiRoutes.friends}/requests';
  static const String sent = '${ApiRoutes.friends}/requests/sent';
  static const String received = '${ApiRoutes.friends}/requests/received';
  static const String accept = '${ApiRoutes.friends}/requests/accept';
  static const String reject = '${ApiRoutes.friends}/requests/reject';
  static const String cancel = '${ApiRoutes.friends}/requests/cancel';
  static const String remove = '${ApiRoutes.friends}/remove';
  static const String block = '${ApiRoutes.friends}/block';
  static const String unblock = '${ApiRoutes.friends}/unblock';
  static const String suggestions = '${ApiRoutes.friends}/suggestions';
  static const String search = '${ApiRoutes.friends}/search';
  static const String online = '${ApiRoutes.friends}/online';
  static const String blocked = '${ApiRoutes.friends}/blocked';
  static const String muted = '${ApiRoutes.friends}/muted';
}

class NotificationRoutes {
  static const String list = ApiRoutes.notifications;
  static const String unread = '${ApiRoutes.notifications}/unread';
  static const String read = '${ApiRoutes.notifications}/read';
  static const String readAll = '${ApiRoutes.notifications}/read-all';
  static const String delete = '${ApiRoutes.notifications}/delete';
  static const String settings = '${ApiRoutes.notifications}/settings';
  static const String preferences = '${ApiRoutes.notifications}/preferences';
  static const String push = '${ApiRoutes.notifications}/push';
  static const String email = '${ApiRoutes.notifications}/email';
  static const String scheduled = '${ApiRoutes.notifications}/scheduled';
  static const String cancel = '${ApiRoutes.notifications}/cancel';
}

class SocialRoutes {
  static const String posts = '${ApiRoutes.social}/posts';
  static const String comments = '${ApiRoutes.social}/posts/comments';
  static const String likes = '${ApiRoutes.social}/posts/likes';
  static const String feed = '${ApiRoutes.social}/feed';
  static const String share = '${ApiRoutes.social}/share';
  static const String report = '${ApiRoutes.social}/report';
  static const String moderate = '${ApiRoutes.social}/moderate';
  static const String pin = '${ApiRoutes.social}/pin';
  static const String trending = '${ApiRoutes.social}/trending';
  static const String notifications = '${ApiRoutes.social}/notifications';
}

class SearchRoutes {
  static const String all = ApiRoutes.search;
  static const String courses = '${ApiRoutes.search}/courses';
  static const String lessons = '${ApiRoutes.search}/lessons';
  static const String users = '${ApiRoutes.search}/users';
  static const String challenges = '${ApiRoutes.search}/challenges';
  static const String suggestions = '${ApiRoutes.search}/suggestions';
  static const String popular = '${ApiRoutes.search}/popular';
  static const String recent = '${ApiRoutes.search}/recent';
  static const String history = '${ApiRoutes.search}/history';
}

class AnalyticsRoutes {
  static const String track = '${ApiRoutes.analytics}/track';
  static const String events = '${ApiRoutes.analytics}/events';
  static const String user = '${ApiRoutes.analytics}/user';
  static const String platform = '${ApiRoutes.analytics}/platform';
  static const String engagement = '${ApiRoutes.analytics}/engagement';
  static const String reports = '${ApiRoutes.analytics}/reports';
  static const String export = '${ApiRoutes.analytics}/export';
  static const String dashboard = '${ApiRoutes.analytics}/dashboard';
}

class FileRoutes {
  static const String upload = '${ApiRoutes.files}/upload';
  static const String download = '${ApiRoutes.files}/download';
  static const String delete = '${ApiRoutes.files}/delete';
  static const String list = '${ApiRoutes.files}/list';
  static const String metadata = '${ApiRoutes.files}/metadata';
  static const String url = '${ApiRoutes.files}/url';
  static const String thumbnail = '${ApiRoutes.files}/thumbnail';
}

class RouteDefinition {
  final String path;
  final String method;
  final List<String> middleware;
  final Map<String, dynamic> meta;

  RouteDefinition({
    required this.path,
    required this.method,
    this.middleware = const [],
    this.meta = const {},
  });
}

class RouteGroup {
  final String prefix;
  final List<String> middleware;
  final List<RouteDefinition> routes;

  RouteGroup({
    required this.prefix,
    this.middleware = const [],
    this.routes = const [],
  });

  List<RouteDefinition> get fullRoutes => routes.map((r) => RouteDefinition(
        path: '$prefix${r.path}',
        method: r.method,
        middleware: [...middleware, ...r.middleware],
        meta: r.meta,
      )).toList();
}

class Router {
  final List<RouteDefinition> _routes = [];

  void add(RouteDefinition route) => _routes.add(route);
  void addGroup(RouteGroup group) => _routes.addAll(group.fullRoutes);
  void remove(String path, String method) =>
      _routes.removeWhere((r) => r.path == path && r.method == method);
  RouteDefinition? find(String path, String method) {
    for (final route in _routes) {
      if (route.path == path && route.method == method) return route;
    }
    return null;
  }

  List<RouteDefinition> get routes => List.unmodifiable(_routes);
}
