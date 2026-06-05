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
