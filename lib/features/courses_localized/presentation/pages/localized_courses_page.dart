import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/localized_widgets.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/locale_format.dart';
import '../../../design_v2/presentation/widgets/premium_widgets.dart';

class CourseItem {
  final String id;
  final String title;
  final String category;
  final int lessons;
  final double progress;
  final bool locked;

  const CourseItem({
    required this.id,
    required this.title,
    required this.category,
    required this.lessons,
    required this.progress,
    this.locked = false,
  });
}

/// Localized course catalog with category filter chips and progress cards.
class LocalizedCoursesPage extends StatefulWidget {
  final AppLocale locale;
  final List<CourseItem> courses;

  const LocalizedCoursesPage({
    super.key,
    required this.locale,
    this.courses = const [
      CourseItem(id: '1', title: 'Flutter Fundamentals', category: 'Flutter', lessons: 24, progress: 0.5),
      CourseItem(id: '2', title: 'Python 101', category: 'Python', lessons: 18, progress: 0.3),
      CourseItem(id: '3', title: 'Web Development', category: 'Web', lessons: 30, progress: 0.0),
      CourseItem(id: '4', title: 'AI / ML', category: 'AI', lessons: 9, progress: 0.0, locked: true),
    ],
  });

  @override
  State<LocalizedCoursesPage> createState() => _LocalizedCoursesPageState();
}

class _LocalizedCoursesPageState extends State<LocalizedCoursesPage> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filtered = _filter == 'all'
        ? widget.courses
        : widget.courses.where((c) => c.category == _filter).toList();

    return Scaffold(
      appBar: AppBar(title: LocalizedText((l) => l.courses)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.search,
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: ['all', 'Flutter', 'Python', 'Web', 'AI'].map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat == 'all' ? l10n.all : cat),
                      selected: _filter == cat,
                      onSelected: (_) => setState(() => _filter = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final course = filtered[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PremiumCard(
                      title: course.title,
                      subtitle: '${LocaleFormat.number(course.lessons, widget.locale)} ${l10n.lessons} · ${(course.progress * 100).round()}%',
                      icon: course.locked ? Icons.lock_rounded : Icons.school_rounded,
                      onTap: course.locked ? null : () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
