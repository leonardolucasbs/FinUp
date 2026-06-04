import 'package:flutter/foundation.dart';
import 'package:frontend/data/models/app_user.dart';
import 'package:frontend/data/models/dashboard_model.dart';
import 'package:frontend/data/services/dashboard_service.dart';

class DashboardListController extends ChangeNotifier {
  DashboardListController({
    required this.user,
    DashboardService? dashboardService,
  }) : _dashboardService = dashboardService ?? DashboardService();

  final AppUser user;
  final DashboardService _dashboardService;

  List<DashboardModel> dashboards = const [];
  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dashboards = await _dashboardService.findDashboardsByUser(user.id);
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<DashboardModel?> createDashboard({
    required String title,
    required double fixedValue,
  }) async {
    if (isSubmitting) return null;

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final dashboard = await _dashboardService.createDashboard(
        userId: user.id,
        title: title,
      );
      final dashboardWithFixedValue = await _dashboardService.addFixedValue(
        dashboardId: dashboard.id,
        amount: fixedValue,
      );
      dashboards = await _dashboardService.findDashboardsByUser(user.id);
      return dashboardWithFixedValue;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
