import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/data/models/subscription_model.dart';

class SubscriptionService {
  SubscriptionService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<SubscriptionModel>> findAllSubscriptions() async {
    try {
      final response = await _dio.get('/subscriptions');
      return _listFromResponse(
        response.data,
        (json) => SubscriptionModel.fromJson(json),
      );
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<SubscriptionModel> findSubscriptionById(int subscriptionId) async {
    try {
      final response = await _dio.get('/subscriptions/$subscriptionId');
      return SubscriptionModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<SubscriptionModel> createSubscription(
    CreateSubscriptionRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/subscriptions',
        data: request.toJson(),
      );
      return SubscriptionModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<void> deleteSubscription(int subscriptionId) async {
    try {
      await _dio.delete('/subscriptions/$subscriptionId');
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
    return 'Nao foi possivel concluir a inscricao.';
  }
}
