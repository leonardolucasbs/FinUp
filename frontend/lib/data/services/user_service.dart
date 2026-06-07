import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/data/models/app_user.dart';

class UserService {
  UserService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<void> createUser({
    required String fullName,
    required String username,
    required String password,
  }) async {
    try {
      await _dio.post(
        '/users',
        data: {
          'fullName': fullName,
          'username': username,
          'password': password,
        },
      );
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<AppUser> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/users/login',
        data: {'username': username, 'password': password},
      );
      final data = response.data;
      if (data is Map<String, dynamic> &&
          data['data'] is Map<String, dynamic>) {
        return AppUser.fromJson(data['data'] as Map<String, dynamic>);
      }
      throw Exception('Resposta de login invalida.');
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<AppUser> getUserById({ required int userId }) async { 
    try {
      final response = await _dio.get("/users/$userId");
      return AppUser.fromJson(response.data['data'] as Map<String, dynamic>);

    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));

  Future<AppUser> updateUser({
    required AppUser user,
    required String fullName,
    required String password,
  }) async {
    try {
      await _dio.put(
        '/users/${user.id}',
        data: {'fullName': fullName, 'password': password},
      );
      return user.copyWith(fullName: fullName);
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

    return 'Nao foi possivel concluir a requisicao.';
  }
}
