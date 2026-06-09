import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/data/models/content_model.dart';

class ContentService {
  ContentService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<ContentModel>> findContentsByUser(int userId) async {
    try {
      final response = await _dio.get('/contents');
      final data = response.data;
      if (data is! List) return const [];

      return data
          .whereType<Map<String, dynamic>>()
          .map(ContentModel.fromJson)
          .where((content) => content.userId == userId)
          .toList(growable: false);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

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
      final response = await _dio.post(
        '/contents',
        data: _formDataFromCreateRequest(request),
        options: Options(contentType: Headers.multipartFormDataContentType),
      );
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
        data: _formDataFromUpdateRequest(request),
        options: Options(contentType: Headers.multipartFormDataContentType),
      );
      return ContentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  FormData _formDataFromCreateRequest(CreateContentRequest request) {
    final data = Map<String, dynamic>.from(request.toJson());
    final imageBytes = request.imageBytes;
    if (imageBytes != null && imageBytes.isNotEmpty) {
      data['image'] = MultipartFile.fromBytes(
        imageBytes,
        filename: request.imageFileName ?? 'content-image',
      );
    }
    return FormData.fromMap(data);
  }

  FormData _formDataFromUpdateRequest(UpdateContentRequest request) {
    final data = Map<String, dynamic>.from(request.toJson());
    final imageBytes = request.imageBytes;
    if (imageBytes != null && imageBytes.isNotEmpty) {
      data['image'] = MultipartFile.fromBytes(
        imageBytes,
        filename: request.imageFileName ?? 'content-image',
      );
    }
    return FormData.fromMap(data);
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
    return 'Nao foi possivel carregar as postagens.';
  }
}
