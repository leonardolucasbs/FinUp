import 'package:flutter/foundation.dart';
import 'package:frontend/data/models/app_user.dart';
import 'package:frontend/data/models/category_model.dart';
import 'package:frontend/data/models/dashboard_model.dart';
import 'package:frontend/data/models/expense_model.dart';
import 'package:frontend/data/services/dashboard_service.dart';

class DashboardController extends ChangeNotifier {
  DashboardController({
    required this.user,
    required DashboardModel initialDashboard,
    DashboardService? dashboardService,
  }) : dashboard = initialDashboard,
       _dashboardService = dashboardService ?? DashboardService();

  final AppUser user;
  final DashboardService _dashboardService;

  DashboardModel? dashboard;
  List<CategoryModel> categories = const [];
  List<ExpenseModel> expenses = const [];
  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final currentDashboard = dashboard;
      if (currentDashboard == null) {
        throw Exception('Dashboard nao informado.');
      }
      dashboard = await _dashboardService.findDashboardById(
        currentDashboard.id,
      );
      categories = await _dashboardService.findCategoriesByUser(user.id);
      expenses = await _dashboardService.findExpensesByDashboard(dashboard!.id);
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addExpense({
    required double amount,
    required int categoryId,
  }) async {
    final currentDashboard = dashboard;
    if (currentDashboard == null || isSubmitting) return false;

    return _submit(() async {
      await _dashboardService.addExpense(
        dashboardId: currentDashboard.id,
        amount: amount,
        categoryId: categoryId,
      );
    });
  }

  Future<bool> addMoney({required double amount}) async {
    final currentDashboard = dashboard;
    if (currentDashboard == null || isSubmitting) return false;

    return _submit(() async {
      await _dashboardService.addMoney(
        dashboardId: currentDashboard.id,
        amount: amount,
      );
    });
  }

  Future<CategoryModel?> createCategory(String name) async {
    if (isSubmitting) return null;

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final category = await _dashboardService.createCategory(
        userId: user.id,
        name: name,
      );
      categories = [...categories, category];
      return category;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> deleteDashboard() async {
    final currentDashboard = dashboard;
    if (currentDashboard == null || isSubmitting) return false;

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _dashboardService.deleteDashboard(currentDashboard.id);
      dashboard = null;
      return true;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> _submit(Future<void> Function() action) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await action();
      await load();
      return true;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
