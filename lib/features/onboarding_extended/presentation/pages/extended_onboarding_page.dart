import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/selection_tiles.dart';

/// Two-step extended onboarding: pick skills, then pick a daily goal.
///
/// The finish button stays disabled until at least one skill and one goal are
/// selected, so a user cannot skip personalization by accident. All copy is
/// passed in by the caller (already localized).
class ExtendedOnboardingPage extends StatefulWidget {
  final List<String> skillsLabel;
  final List<String> goalsLabel;
  final VoidCallback onFinish;

  const ExtendedOnboardingPage({
    super.key,
    required this.skillsLabel,
    required this.goalsLabel,
    required this.onFinish,
  });

  @override
  State<ExtendedOnboardingPage> createState() => _ExtendedOnboardingPageState();
}

class _ExtendedOnboardingPageState extends State<ExtendedOnboardingPage> {
  int _step = 0;
  final Set<String> _skills = {};
  int? _goalMinutes;

  static const _catalog = [
    ('Flutter', 'Cross-platform apps', Icons.phone_android_rounded),
    ('Python', 'Data & scripting', Icons.code_rounded),
    ('Web Dev', 'HTML, CSS, JS', Icons.language_rounded),
    ('Security', 'Ethical hacking', Icons.security_rounded),
    ('AI / ML', 'Models & data', Icons.psychology_rounded),
    ('Game Dev', '2D and 3D games', Icons.games_rounded),
  ];

  static const _goals = [
    ('Casual', '5 min a day', 5),
    ('Regular', '15 min a day', 15),
    ('Serious', '30 min a day', 30),
    ('Hardcore', '60 min a day', 60),
  ];

  bool get _canContinue =>
      _step == 0 ? _skills.isNotEmpty : _goalMinutes != null;

  void _next() {
    if (_step == 0) {
      setState(() => _step = 1);
    } else if (_canContinue) {
      widget.onFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (_step + 1) / 2),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: _step == 0 ? _buildSkills() : _buildGoals(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _step = 0),
                        child: const Text('Back'),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _canContinue ? _next : null,
                      child: Text(_step == 0 ? 'Next' : 'Finish'),
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

  Widget _buildSkills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.skillsLabel[0], style: AppTextStyles.displayMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(widget.skillsLabel[1], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _catalog.map((skill) {
            final selected = _skills.contains(skill.$1);
            return SkillTile(
              label: skill.$1,
              subtitle: skill.$2,
              icon: skill.$3,
              selected: selected,
              onChanged: (_) => setState(() {
                if (selected) { _skills.remove(skill.$1); } else { _skills.add(skill.$1); }
              }),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.goalsLabel[0], style: AppTextStyles.displayMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(widget.goalsLabel[1], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.xl),
        ..._goals.map((goal) => GoalOption(
              title: goal.$1,
              subtitle: goal.$2,
              minutes: goal.$3,
              selected: _goalMinutes == goal.$3,
              onTap: () => setState(() => _goalMinutes = goal.$3),
            )),
      ],
    );
  }
}
