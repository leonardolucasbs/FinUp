import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/data/models/category_model.dart';
import 'dashboard_formatters.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({
    super.key,
    required this.categories,
    required this.isSubmitting,
    required this.onConfirm,
    required this.onCreateCategory,
  });

  final List<CategoryModel> categories;
  final bool isSubmitting;
  final Future<bool> Function(double amount, int categoryId, DateTime date)
  onConfirm;
  final Future<CategoryModel?> Function(String name) onCreateCategory;

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _categoryNameController = TextEditingController();
  late List<CategoryModel> _categories;
  DateTime _selectedDate = DateTime.now();
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _categories = List.of(widget.categories);
    _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardGrey,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.border),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      color: Colors.white,
                    ),
                    const Expanded(
                      child: Text(
                        'adicionar gasto',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 18),
                _AmountField(controller: _amountController),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<CategoryModel>(
                        initialValue: _selectedCategory,
                        dropdownColor: AppColors.inputField,
                        iconEnabledColor: AppColors.textGrey,
                        decoration: _inputDecoration(
                          label: 'categoria',
                          icon: Icons.category_outlined,
                        ),
                        items: _categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedCategory = value),
                        validator: (value) =>
                            value == null ? 'Selecione uma categoria.' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      tooltip: 'Criar categoria',
                      onPressed: widget.isSubmitting ? null : _createCategory,
                      icon: const Icon(Icons.add_rounded),
                      color: Colors.white,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        disabledBackgroundColor: AppColors.inputField,
                        fixedSize: const Size(54, 54),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(15),
                  child: InputDecorator(
                    decoration: _inputDecoration(
                      label: 'data da compra',
                      icon: Icons.calendar_month_outlined,
                    ),
                    child: Text(
                      DashboardFormatters.date(_selectedDate),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: widget.isSubmitting ? null : _confirm,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                      widget.isSubmitting ? 'confirmando...' : 'confirmar',
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.primaryOrange,
                      disabledBackgroundColor: AppColors.inputField,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primaryOrange,
            surface: AppColors.cardGrey,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _createCategory() async {
    _categoryNameController.clear();

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardGrey,
        title: const Text(
          'Criar categoria',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        content: TextField(
          controller: _categoryNameController,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration(
            label: 'nome da categoria',
            icon: Icons.category_outlined,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final value = _categoryNameController.text.trim();
              if (value.isNotEmpty) {
                Navigator.pop(context, value);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryOrange,
            ),
            child: const Text('Criar'),
          ),
        ],
      ),
    );

    if (name == null || !mounted) return;

    final category = await widget.onCreateCategory(name);
    if (!mounted) return;

    if (category != null) {
      setState(() {
        _categories = [..._categories, category];
        _selectedCategory = category;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel criar a categoria.')),
      );
    }
  }

  Future<void> _confirm() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountController.text.replaceAll(',', '.'));
    final success = await widget.onConfirm(
      amount,
      _selectedCategory!.id,
      _selectedDate,
    );
    if (success && mounted) {
      Navigator.pop(context);
    }
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(
        label: 'valor',
        icon: Icons.payments_outlined,
      ),
      validator: (value) {
        final amount = double.tryParse((value ?? '').replaceAll(',', '.'));
        if (amount == null || amount <= 0) {
          return 'Informe um valor maior que zero.';
        }
        return null;
      },
    );
  }
}

InputDecoration _inputDecoration({
  required String label,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: AppColors.textGrey),
    filled: true,
    fillColor: AppColors.inputField,
    prefixIcon: Icon(icon, color: AppColors.textGrey),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: AppColors.primaryRed),
    ),
  );
}
