import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/data/models/course_model.dart';

class CourseService {
  CourseService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<CourseModel>> findAllCourses() async {
    try {
      final response = await _dio.get('/courses');
      return _listFromResponse(
        response.data,
        (json) => CourseModel.fromJson(json),
      );
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<CourseModel> findCourseById(int courseId) async {
    try {
      final response = await _dio.get('/courses/$courseId');
      return CourseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<CourseModel> createCourse(CreateCourseRequest request) async {
    try {
      final response = await _dio.post('/courses', data: request.toJson());
      return CourseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<CourseModel> updateCourse(
    int courseId,
    UpdateCourseRequest request,
  ) async {
    try {
      final response = await _dio.put(
        '/courses/$courseId',
        data: request.toJson(),
      );
      return CourseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<void> deleteCourse(int courseId) async {
    try {
      await _dio.delete('/courses/$courseId');
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  List<T> _listFromResponse<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(fromJson)
          .toList(growable: false);
    }
    return const [];
  }

  String _messageFromDio(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
      if (message is Map) {
        return message.values.whereType<String>().join('\n');
      }
    }
    return 'Nao foi possivel carregar os cursos.';
  }
}
