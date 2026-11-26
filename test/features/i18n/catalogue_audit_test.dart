import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/localization/catalogue_audit.dart';

void main() {
  const english = {'a': 'Alpha', 'b': 'Beta'};

  test('reports no issues for a complete catalogue', () {
    expect(
      CatalogueAudit.compare(
        locale: 'fr',
        reference: english,
        target: const {'a': 'Un', 'b': 'Deux'},
      ),
      isEmpty,
    );
  });

  test('reports missing, empty and unknown keys', () {
    final issues = CatalogueAudit.compare(
      locale: 'ar',
      reference: english,
      target: const {'a': '', 'c': 'Extra'},
    );

    expect(
      issues.map((i) => i.kind),
      containsAll(['empty', 'missing', 'unknown']),
    );
    expect(issues.first.key, 'a');
  });

  test('auditAll skips locales with no issues', () {
    final result = CatalogueAudit.auditAll(
      reference: english,
      catalogues: {
        'fr': const {'a': 'Un', 'b': 'Deux'},
        'es': const {'a': ''},
      },
    );

    expect(result.keys, ['es']);
    expect(result['es'], hasLength(2));
  });

  test('sorts issues by key for stable reports', () {
    final issues = CatalogueAudit.compare(
      locale: 'tr',
      reference: const {'z': 'Z', 'a': 'A'},
      target: const {},
    );

    expect(issues.map((i) => i.key), ['a', 'z']);
  });
}
