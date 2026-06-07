import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/data/models/content_model.dart';

class SavedContentService {
  SavedContentService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<SavedContentModel> createSavedContent(
    CreateSavedContentRequest request,
  ) async {
    try {
      final response = await _dio.post('/saved-contents', data: request.toJson());
      return SavedContentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<int> findSaveCountByContentId(int contentId) async {
    try {
      final response = await _dio.get('/saved-contents/$contentId');
      final data = response.data;
      if (data is int) return data;
      if (data is num) return data.toInt();
      return 0;
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<bool> hasUserSavedContent(int contentId, int userId) async {
    try {
      final response = await _dio.get(
        '/saved-contents/$contentId/user/$userId',
      );
      final data = response.data;
      if (data is bool) return data;
      if (data is String) return data.toLowerCase() == 'true';
      return false;
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<void> deleteSavedContent(int savedContentId) async {
    try {
      await _dio.delete('/saved-contents/$savedContentId');
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<SavedContentModel?> findSavedContentByUserAndContent({
    required int userId,
    required int contentId,
  }) async {
    try {
      final response = await _dio.get('/saved-contents');
      final savedContents = _listFromResponse(
        response.data,
        (json) => SavedContentModel.fromJson(json),
      );
      for (final savedContent in savedContents) {
        if (savedContent.userId == userId &&
            savedContent.contentId == contentId) {
          return savedContent;
        }
      }
      return null;
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
    return 'Nao foi possivel concluir a requisicao.';
  }
}
