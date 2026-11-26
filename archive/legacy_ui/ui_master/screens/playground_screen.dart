import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  String _tab = 'Weekly';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              _buildTabs(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return _buildLeaderboardRow(
                      rank: index + 1,
                      name: ['Alex Rivera', 'Sam Chen', 'Jordan Lee', 'Taylor Kim', 'Morgan Davis', 'Casey Wu', 'Riley Ortiz', 'Quinn Martinez', 'Parker Sullivan', 'Jordan Hayes'][index],
                      avatar: ['AR', 'SC', 'JL', 'TK', 'MD', 'CW', 'RO', 'QM', 'PS', 'JH'][index],
                      level: [12, 11, 10, 9, 8, 7, 7, 6, 6, 5][index],
                      xp: [18400, 16200, 14800, 12400, 11100, 9500, 9200, 7800, 7500, 6200][index],
                      streak: [15, 12, 8, 6, 3, 1, 2, 1, 0, 1][index],
                      isCurrentUser: index == 5,
                      isFriend: index == 1 || index == 3,
                    );
                  },
                ),
              ),
              _buildCurrentUserBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: AppRadius.circular(AppRadius.md),
              boxShadow: [AppGradients.glow(AppColors.primaryBlue, blurRadius: 12)],
            ),
            child: const Center(
              child: Icon(Icons.leaderboard_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Text(
            'Leaderboard',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['Weekly', 'All-time', 'Friends'];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = _tab == tabs[i];
          return GestureDetector(
            onTap: () => setState(() => _tab = tabs[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              margin: const EdgeInsets.only(right: AppSpacing.xxl),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? AppColors.primaryBlue : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                tabs[i],
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isActive ? AppColors.primaryBlue : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLeaderboardRow({
    required int rank,
    required String name,
    required String avatar,
    required int level,
    required int xp,
    required int streak,
    required bool isCurrentUser,
    required bool isFriend,
  }) {
    final Color rankColor = rank == 1 ? AppColors.primaryYellow : rank == 2 ? const Color(0xFFCBD5E1) : rank == 3 ? const Color(0xFFE2E8F0) : AppColors.textMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.primaryBlue.withValues(alpha: 0.10) : AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(
          color: isCurrentUser ? AppColors.primaryBlue : AppColors.cardBorder,
          width: isCurrentUser ? 2 : 1,
        ),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: Row(
        children: [
          _buildRank(rank, rankColor),
          const SizedBox(width: AppSpacing.md),
          _buildAvatar(avatar),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isCurrentUser ? AppColors.primaryBlue : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      'Lv.$level',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primaryYellow,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.local_fire_department_rounded, color: AppColors.primaryOrange, size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '$streak day streak',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    const Spacer(),
                    Text(
                      '$xp XP',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primaryYellow,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isFriend)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.15),
                borderRadius: AppRadius.circular(AppRadius.xxl),
                border: Border.all(color: AppColors.primaryGreen, width: 1),
              ),
              child: const Text(
                'Friend',
                style: TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            )
          else if (isCurrentUser)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: AppRadius.circular(AppRadius.xxl),
              ),
              child: const Text(
                'YOU',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildRank(int rank, Color color) {
    if (rank <= 3) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.05)],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Text(
            '$rank',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: Text(
        '#$rank',
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildAvatar(String avatar) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          avatar,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentUserBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      color: AppColors.surface,
      child: Row(
        children: [
          _buildAvatar('YU'),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Alex Rivera',
                      style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.15),
                        borderRadius: AppRadius.circular(AppRadius.xxl),
                        border: Border.all(color: AppColors.primaryBlue, width: 1),
                      ),
                      child: const Text(
                        'YOU',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Rank #42  •  Level 7  •  8,900 XP',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            '#42',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final List<Map<String, dynamic>> _achievements = [
    {'name': 'First Commit', 'description': 'Complete your very first lesson', 'icon': '🚀', 'color': AppColors.primaryBlue, 'unlocked': true, 'xp': 100},
    {'name': 'Bug Squasher', 'description': 'Solve 10 challenge quizzes', 'icon': '🐛', 'color': AppColors.primaryGreen, 'unlocked': false, 'xp': 200},
    {'name': 'Week Warrior', 'description': 'Maintain a 7-day streak', 'icon': '🔥', 'color': AppColors.primaryOrange, 'unlocked': false, 'xp': 200},
    {'name': 'Polyglot', 'description': 'Learn 3 different categories', 'icon': '🌐', 'color': AppColors.primaryPurple, 'unlocked': false, 'xp': 300},
    {'name': 'Speed Runner', 'description': 'Complete a quiz in under 5 minutes', 'icon': '⚡', 'color': AppColors.primaryYellow, 'unlocked': false, 'xp': 150},
    {'name': 'Monthly Master', 'description': 'Stay active for 30 days', 'icon': '🏆', 'color': AppColors.primaryCyan, 'unlocked': false, 'xp': 500},
    {'name': 'Helpful Hand', 'description': 'Help 5 other users', 'icon': '🤝', 'color': AppColors.primaryPink, 'unlocked': false, 'xp': 250},
    {'name': 'Night Owl', 'description': 'Complete a lesson after midnight', 'icon': '🦉', 'color': AppColors.primaryIndigo, 'unlocked': false, 'xp': 150},
  ];

  @override
  Widget build(BuildContext context) {
    final earned = _achievements.where((a) => a['unlocked'] as bool).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Column(
                children: [
                  _buildProgressHeader(earned),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.88,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                      ),
                      itemCount: _achievements.length,
                      itemBuilder: (context, index) {
                        return _buildAchievementCard(_achievements[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: AppRadius.circular(AppRadius.md),
              boxShadow: [AppGradients.glow(AppColors.primaryBlue, blurRadius: 12)],
            ),
            child: const Center(
              child: Icon(Icons.emoji_events_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Text(
            'Achievements',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(int earned) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Badges',
                style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
              ),
              Text(
                '$earned / ${_achievements.length}',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadius.circular(AppRadius.md),
            child: LinearProgressIndicator(
              value: earned / _achievements.length,
              minHeight: 8,
              backgroundColor: AppColors.cardBorder,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryYellow),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final isUnlocked = achievement['unlocked'] as bool;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(
          color: isUnlocked ? achievement['color'] : AppColors.cardBorder,
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: [AppGradients.cardShadow()],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isUnlocked ? achievement['color'].withValues(alpha: 0.2) : AppColors.cardBorder.withValues(alpha: 0.4),
              shape: BoxShape.circle,
              border: Border.all(
                color: isUnlocked ? achievement['color'] : AppColors.textMuted,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(achievement['icon'] as String, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            achievement['name'] as String,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            achievement['description'] as String,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isUnlocked ? AppColors.textSecondary : AppColors.textMuted,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isUnlocked) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, color: AppColors.primaryYellow, size: 16),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '+${achievement['xp']} XP',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primaryYellow,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  final _codeController = TextEditingController();
  final _outputController = TextEditingController();
  String _language = 'Dart';
  double _divider = 0.6;
  bool _isRunning = false;

  static const _languages = ['Dart', 'Python', 'JavaScript', 'Flutter'];

  @override
  void initState() {
    super.initState();
    _codeController.text = '''void main() {
  print('Hello, CodeBro Playground!');
  var message = 'Learning to code is fun';
  print(message);
}''';
  }

  @override
  void dispose() {
    _codeController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  void _runCode() {
    setState(() => _isRunning = true);
    _outputController.text = 'Running $_language code...\n\n';
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _outputController.text += 'Hello, CodeBro Playground!\nLearning to code is fun\n\nExecution completed in 840ms.';
        _isRunning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Code Playground'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.reset_outlined),
            onPressed: _isRunning ? null : () {
              setState(() {
                _outputController.clear();
                _codeController.text = '''void main() {
  print('Hello, CodeBro Playground!');
}''';
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final editorHeight = (constraints.maxHeight * _divider).clamp(60.0, constraints.maxHeight - 60);
                return Column(
                  children: [
                    Expanded(child: _buildEditorPane(editorHeight)),
                    _buildDivider(),
                    Expanded(child: _buildOutputPane()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppRadius.circular(AppRadius.xxl),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _language,
                dropdownColor: AppColors.surfaceLight,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                items: _languages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: (v) => setState(() => _language = v!),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SizedBox(
              height: 44,
              child: PremiumButton(
                text: _isRunning ? 'Running...' : 'Run',
                onPressed: _isRunning ? null : _runCode,
                icon: _isRunning ? null : Icons.play_arrow_rounded,
                gradient: AppGradients.neonGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorPane(double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF070A0F),
        borderRadius: AppRadius.circular(AppRadius.lg),
      ),
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            color: const Color(0xFF0F141C),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                const Icon(Icons.code_rounded, color: AppColors.primaryYellow, size: 16),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _language,
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _codeController,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                fontFamily: 'FiraCode',
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(AppSpacing.md),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() => _divider = (_divider + details.delta.dx / 400).clamp(0.25, 0.85));
      },
      child: Container(
        height: 8,
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 20,
            height: 2,
            color: AppColors.textMuted.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildOutputPane() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF05070A),
        borderRadius: AppRadius.circular(AppRadius.lg),
      ),
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            color: const Color(0xFF0F141C),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                const Icon(Icons.terminal_rounded, color: AppColors.primaryCyan, size: 16),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Output',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                _outputController.text.isEmpty ? 'Run your code to see output here.' : _outputController.text,
                style: const TextStyle(
                  fontFamily: 'FiraCode',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
