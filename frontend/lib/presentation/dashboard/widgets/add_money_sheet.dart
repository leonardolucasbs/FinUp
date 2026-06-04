import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class AddMoneySheet extends StatefulWidget {
  const AddMoneySheet({
    super.key,
    required this.isSubmitting,
    required this.onConfirm,
  });

  final bool isSubmitting;
  final Future<bool> Function(double amount) onConfirm;

  @override
  State<AddMoneySheet> createState() => _AddMoneySheetState();
}

class _AddMoneySheetState extends State<AddMoneySheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
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
                        'adicionar saldo',
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
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'valor',
                    labelStyle: const TextStyle(color: AppColors.textGrey),
                    filled: true,
                    fillColor: AppColors.inputField,
                    prefixIcon: const Icon(
                      Icons.savings_outlined,
                      color: AppColors.textGrey,
                    ),
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
                  validator: (value) {
                    final amount = double.tryParse(
                      (value ?? '').replaceAll(',', '.'),
                    );
                    if (amount == null || amount <= 0) {
                      return 'Informe um valor maior que zero.';
                    }
                    return null;
                  },
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

  Future<void> _confirm() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountController.text.replaceAll(',', '.'));
    final success = await widget.onConfirm(amount);
    if (success && mounted) {
      Navigator.pop(context);
    }
  }
}
