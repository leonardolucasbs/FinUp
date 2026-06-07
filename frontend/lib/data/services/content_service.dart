import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/data/models/content_model.dart';

class ContentService {
  ContentService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<ContentModel>> findAllContents() async {
    try {
      final response = await _dio.get('/contents');
      return _listFromResponse(
        response.data,
        (json) => ContentModel.fromJson(json),
      );
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<ContentModel> findContentById(int contentId) async {
    try {
      final response = await _dio.get('/contents/$contentId');
      return ContentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<ContentModel> createContent(CreateContentRequest request) async {
    try {
      final response = await _dio.post('/contents', data: request.toJson());
      return ContentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<ContentModel> updateContent(
    int contentId,
    UpdateContentRequest request,
  ) async {
    try {
      final response = await _dio.put(
        '/contents/$contentId',
        data: request.toJson(),
      );
      return ContentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<void> deleteContent(int contentId) async {
    try {
      await _dio.delete('/contents/$contentId');
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
