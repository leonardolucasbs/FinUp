import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/data/models/expense_model.dart';
import 'expense_item.dart';

class MonthReportCard extends StatelessWidget {
  const MonthReportCard({
    super.key,
    required this.expenses,
    required this.filterController,
    required this.onFilterChanged,
  });

  final List<ExpenseModel> expenses;
  final TextEditingController filterController;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardGrey,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 18,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'relatorio do mes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: filterController,
            onChanged: onFilterChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.inputField,
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textGrey,
              ),
              hintText: 'filtro',
              hintStyle: const TextStyle(color: Colors.white24),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.primaryOrange,
                  width: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (expenses.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Text(
                  'nenhum gasto encontrado',
                  style: TextStyle(color: AppColors.textGrey),
                ),
              ),
            )
          else
            ...expenses.map((expense) => ExpenseItem(expense: expense)),
        ],
      ),
    );
  }
}
