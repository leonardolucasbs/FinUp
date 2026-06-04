import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/data/models/app_user.dart';
import 'package:frontend/data/models/dashboard_model.dart';
import 'package:frontend/data/models/expense_model.dart';
import 'package:frontend/presentation/common/view/empty_feature_page.dart';
import 'package:frontend/presentation/dashboard/controller/dashboard_controller.dart';
import 'package:frontend/presentation/dashboard/widgets/action_buttons.dart';
import 'package:frontend/presentation/dashboard/widgets/add_expense_sheet.dart';
import 'package:frontend/presentation/dashboard/widgets/add_money_sheet.dart';
import 'package:frontend/presentation/dashboard/widgets/dashboard_bottom_nav.dart';
import 'package:frontend/presentation/dashboard/widgets/financial_summary_card.dart';
import 'package:frontend/presentation/dashboard/widgets/month_report_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.user,
    required this.initialDashboard,
  });

  final AppUser user;
  final DashboardModel initialDashboard;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardController _controller;
  final _filterController = TextEditingController();
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _controller = DashboardController(
      user: widget.user,
      initialDashboard: widget.initialDashboard,
    )..load();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.initialDashboard.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        tooltip: 'Voltar para controles de gastos',
                        onPressed: _returnToExpenseControls,
                        icon: const Icon(Icons.close_rounded),
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.cardGrey,
                          side: const BorderSide(color: AppColors.border),
                          fixedSize: const Size(44, 44),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
          bottomNavigationBar: DashboardBottomNav(
            activeTab: DashboardTab.home,
            onTabSelected: _openTab,
          ),
        );
      },
    );
  }

  void _returnToExpenseControls() {
    Navigator.maybePop(context);
  }

  Widget _buildContent() {
    if (_controller.isLoading && _controller.dashboard == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      );
    }

    final dashboard = _controller.dashboard;
    if (dashboard == null) {
      return _ErrorState(
        message: _controller.errorMessage,
        onRetry: _controller.load,
      );
    }

    final filteredExpenses = _filteredExpenses(_controller.expenses);

    return RefreshIndicator(
      color: AppColors.primaryOrange,
      backgroundColor: AppColors.cardGrey,
      onRefresh: _controller.load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            if (_controller.errorMessage != null) ...[
              _InlineError(message: _controller.errorMessage!),
              const SizedBox(height: 14),
            ],
            FinancialSummaryCard(dashboard: dashboard),
            const SizedBox(height: 18),
            DashboardActionButtons(
              onAddExpense: _showAddExpenseSheet,
              onAddMoney: _showAddMoneySheet,
            ),
            const SizedBox(height: 18),
            MonthReportCard(
              expenses: filteredExpenses,
              filterController: _filterController,
              onFilterChanged: (value) => setState(() => _filter = value),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _controller.isSubmitting
                    ? null
                    : _confirmDeleteDashboard,
                icon: const Icon(Icons.delete_rounded),
                label: const Text('Excluir controle de gastos'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryRed,
                  disabledForegroundColor: AppColors.muted,
                  side: BorderSide(
                    color: _controller.isSubmitting
                        ? AppColors.border
                        : AppColors.primaryRed,
                    width: 1.4,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ExpenseModel> _filteredExpenses(List<ExpenseModel> expenses) {
    final term = _filter.trim().toLowerCase();
    if (term.isEmpty) return expenses;
    return expenses
        .where((expense) => expense.category.name.toLowerCase().contains(term))
        .toList(growable: false);
  }

  Future<void> _confirmDeleteDashboard() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardGrey,
        title: const Text(
          'Excluir controle?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'Essa acao remove este controle de gastos e seus lancamentos.',
          style: TextStyle(color: AppColors.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.primaryRed),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) return;

    final deleted = await _controller.deleteDashboard();
    if (!mounted) return;

    if (deleted) {
      Navigator.pop(context, true);
    } else if (_controller.errorMessage != null) {
      _showMessage(_controller.errorMessage!);
    }
  }

  void _showAddExpenseSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withValues(alpha: 0.55),
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) => AddExpenseSheet(
        categories: _controller.categories,
        isSubmitting: _controller.isSubmitting,
        onCreateCategory: _controller.createCategory,
        onConfirm: (amount, categoryId, _) =>
            _controller.addExpense(amount: amount, categoryId: categoryId),
      ),
    );
  }

  void _showAddMoneySheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withValues(alpha: 0.55),
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) => AddMoneySheet(
        isSubmitting: _controller.isSubmitting,
        onConfirm: (amount) => _controller.addMoney(amount: amount),
      ),
    );
  }

  void _openTab(DashboardTab tab) {
    if (tab == DashboardTab.home) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmptyFeaturePage(
          title: _titleFor(tab),
          icon: _iconFor(tab),
          activeTab: tab,
          user: widget.user,
        ),
      ),
    );
  }

  String _titleFor(DashboardTab tab) {
    return switch (tab) {
      DashboardTab.saved => 'Salvos',
      DashboardTab.courses => 'Cursos',
      DashboardTab.profile => widget.user.fullName,
      DashboardTab.home => 'Home',
    };
  }

  IconData _iconFor(DashboardTab tab) {
    return switch (tab) {
      DashboardTab.saved => Icons.bookmark_rounded,
      DashboardTab.courses => Icons.school_rounded,
      DashboardTab.profile => Icons.person_rounded,
      DashboardTab.home => Icons.home_rounded,
    };
  }

  void _onControllerChanged() {
    final message = _controller.errorMessage;
    if (message != null && mounted) {
      setState(() {});
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryRed.withValues(alpha: 0.35)),
      ),
      child: Text(message, style: const TextStyle(color: Colors.white70)),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.primaryOrange,
              size: 38,
            ),
            const SizedBox(height: 12),
            Text(
              message ?? 'Nao foi possivel carregar o dashboard.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGrey),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
              ),
              child: const Text('tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
