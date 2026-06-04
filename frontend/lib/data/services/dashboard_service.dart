import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/data/models/category_model.dart';
import 'package:frontend/data/models/dashboard_model.dart';
import 'package:frontend/data/models/expense_model.dart';

class DashboardService {
  DashboardService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<DashboardModel>> findDashboardsByUser(int userId) async {
    try {
      final response = await _dio.get('/dashboard/users/$userId');
      return _listFromResponse(
        response.data,
        (json) => DashboardModel.fromJson(json),
      );
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<DashboardModel> findDashboardById(int dashboardId) async {
    try {
      final response = await _dio.get('/dashboard/$dashboardId');
      return DashboardModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<DashboardModel> createDashboard({
    required int userId,
    required String title,
  }) async {
    try {
      final response = await _dio.post(
        '/dashboard',
        data: {'userId': userId, 'title': title},
      );
      return DashboardModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<void> deleteDashboard(int dashboardId) async {
    try {
      await _dio.delete('/dashboard/$dashboardId');
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<DashboardModel> addFixedValue({
    required int dashboardId,
    required double amount,
  }) async {
    try {
      final response = await _dio.post(
        '/dashboard/fixed-values',
        data: {'dashboardId': dashboardId, 'amount': amount},
      );
      return DashboardModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<List<CategoryModel>> findCategoriesByUser(int userId) async {
    try {
      final response = await _dio.get('/dashboard/categories/$userId');
      return _listFromResponse(
        response.data,
        (json) => CategoryModel.fromJson(json),
      );
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<CategoryModel> createCategory({
    required int userId,
    required String name,
  }) async {
    try {
      final response = await _dio.post(
        '/dashboard/categories',
        data: {'userId': userId, 'name': name},
      );
      return CategoryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<List<ExpenseModel>> findExpensesByDashboard(int dashboardId) async {
    try {
      final response = await _dio.get('/dashboard/$dashboardId/expenses');
      return _listFromResponse(
        response.data,
        (json) => ExpenseModel.fromJson(json),
      );
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<void> addExpense({
    required int dashboardId,
    required double amount,
    required int categoryId,
  }) async {
    try {
      await _dio.post(
        '/dashboard/expenses',
        data: {
          'dashboardId': dashboardId,
          'amount': amount,
          'categoryId': categoryId,
        },
      );
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  Future<void> addMoney({
    required int dashboardId,
    required double amount,
  }) async {
    try {
      await _dio.post(
        '/dashboard/money',
        data: {'dashboardId': dashboardId, 'amount': amount},
      );
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
