class CatalogueIssue {
  const CatalogueIssue({
    required this.locale,
    required this.key,
    required this.kind,
  });

  final String locale;
  final String key;
  final String kind;

  @override
  String toString() => '$locale/$key: $kind';
}

class CatalogueAudit {
  const CatalogueAudit._();

  static List<CatalogueIssue> compare({
    required String locale,
    required Map<String, String> reference,
    required Map<String, String> target,
  }) {
    final issues = <CatalogueIssue>[];
    for (final key in reference.keys) {
      if (!target.containsKey(key)) {
        issues.add(CatalogueIssue(locale: locale, key: key, kind: 'missing'));
        continue;
      }
      if (target[key]!.trim().isEmpty) {
        issues.add(CatalogueIssue(locale: locale, key: key, kind: 'empty'));
      }
    }
    for (final key in target.keys) {
      if (!reference.containsKey(key)) {
        issues.add(CatalogueIssue(locale: locale, key: key, kind: 'unknown'));
      }
    }
    return issues..sort((a, b) => a.key.compareTo(b.key));
  }

  static Map<String, List<CatalogueIssue>> auditAll({
    required Map<String, String> reference,
    required Map<String, Map<String, String>> catalogues,
  }) {
    final result = <String, List<CatalogueIssue>>{};
    catalogues.forEach((locale, catalogue) {
      final issues = compare(
        locale: locale,
        reference: reference,
        target: catalogue,
      );
      if (issues.isNotEmpty) result[locale] = issues;
    });
    return result;
  }
}
