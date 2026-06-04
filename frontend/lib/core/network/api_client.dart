import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();

  static const String localBaseUrl = 'http://localhost:8080';

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: localBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
