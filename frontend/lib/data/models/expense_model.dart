import 'category_model.dart';

class ExpenseModel {
  const ExpenseModel({
    required this.id,
    required this.dashboardId,
    required this.amount,
    required this.category,
    required this.createdAt,
  });

  final int id;
  final int dashboardId;
  final double amount;
  final CategoryModel category;
  final DateTime createdAt;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: (json['id'] as num).toInt(),
      dashboardId: (json['dashboardId'] as num).toInt(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      category: CategoryModel.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
