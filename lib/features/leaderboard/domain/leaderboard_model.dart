class LeaderboardEntry {
  final String id;
  final String name;
  final String avatar;
  final int level;
  final int xp;
  final int rank;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.id,
    required this.name,
    required this.avatar,
    required this.level,
    required this.xp,
    required this.rank,
    this.isCurrentUser = false,
  });
}
