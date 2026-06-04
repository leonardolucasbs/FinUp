class DashboardModel {
  const DashboardModel({
    required this.id,
    required this.title,
    required this.userId,
    required this.balance,
    required this.fixedBalance,
    required this.expenses,
    required this.date,
  });

  final int id;
  final String title;
  final int userId;
  final double balance;
  final double fixedBalance;
  final double expenses;
  final DateTime date;

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      userId: (json['userId'] as num).toInt(),
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      fixedBalance: (json['fixedBalance'] as num?)?.toDouble() ?? 0,
      expenses: (json['expenses'] as num?)?.toDouble() ?? 0,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
