class CodeSnippet {
  final String id;
  final String title;
  final String language;
  final String code;
  final DateTime createdAt;

  const CodeSnippet({
    required this.id,
    required this.title,
    required this.language,
    required this.code,
    required this.createdAt,
  });
}
