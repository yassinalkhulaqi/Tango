import '../../../core/data/paged_repository.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/providers.dart';
import '../domain/course_model.dart';
import 'course_dto.dart';

class CoursesApiDataSource implements PagedDataSource<Course> {
  CoursesApiDataSource(this._api);

  final ApiClient _api;

  @override
  Future<Page<Course>> load(PageRequest request) async {
    final envelope = await _api.getList<Course>(
      '/courses',
      queryParameters: request.toQueryParameters(),
      fromJson: (json) => CourseDto.fromJson(json).toDomain(),
    );
    return Page<Course>.fromEnvelope(envelope);
  }
}

final coursesPagedRepositoryProvider = Provider<PagedRepository<Course>>((ref) {
  final api = ref.watch(apiClientProvider);
  return PagedRepository<Course>(CoursesApiDataSource(api));
});

final coursesPagedControllerProvider =
    StateNotifierProvider<PagedListController<Course>, PagedListState<Course>>((
      ref,
    ) {
      return PagedListController<Course>(
        ref.watch(coursesPagedRepositoryProvider),
      );
    });

Future<Course?> fetchCourseById(ApiClient api, String id) async {
  try {
    final body = await api.get('/courses/$id');
    final data = body['data'];
    if (data is! Map) return null;
    return CourseDto.fromJson(Map<String, dynamic>.from(data)).toDomain();
  } on Object {
    return null;
  }
}
