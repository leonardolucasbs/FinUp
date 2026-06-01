import 'package:dio/dio.dart';
import '../datasources/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

 
  Future<bool> register({
    required String fullName, 
    required String email, 
    required String password,
  }) async {
    try {
   
      final response = await _apiClient.dio.post(
        '/users',
        data: {
          'fullName': fullName,
          'username': email, 
          'password': password,
        },
      );

    
      if (response.statusCode == 201) {
        return true;
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Erro ao criar conta';
      throw Exception(errorMessage);
    }
    return false;
  }



  Future<bool> login(String email, String password) async {
    try {
     
      final response = await _apiClient.dio.post(
        '/users/login',
        data: {
          'username': email, 
          'password': password,
        },
      );

     
      if (response.statusCode == 200) {
        return true;
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Erro ao realizar login';
      throw Exception(errorMessage);
    }
    return false;
  }
}