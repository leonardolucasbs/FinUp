import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/data/models/content_model.dart';

class CreateContentSheet extends StatefulWidget {
  const CreateContentSheet({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
    this.initialContent,
  });

  final bool isSubmitting;
  final ContentModel? initialContent;
  final Future<bool> Function({
    required String title,
    required String description,
    required String type,
    String? imageUrl,
  })
  onSubmit;

  @override
  State<CreateContentSheet> createState() => _CreateContentSheetState();
}

class _CreateContentSheetState extends State<CreateContentSheet> {
  static const _types = ['NOTES', 'NEWS', 'ARTICLES', 'OTHERS'];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String? _selectedType = _types.first;
  bool _isSubmitting = false;

  bool get _isEditing => widget.initialContent != null;

  @override
  void initState() {
    super.initState();
    final content = widget.initialContent;
    if (content == null) return;

    _titleController.text = content.title;
    _descriptionController.text = content.description;
    _imageUrlController.text = content.imageUrl;
    _selectedType = _types.contains(content.type) ? content.type : _types.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = widget.isSubmitting || _isSubmitting;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: SingleChildScrollView(
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
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 24,
                  offset: Offset(0, 16),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: isSubmitting
                            ? null
                            : () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Text(
                          _isEditing ? 'editar conteudo' : 'criar conteudo',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'title',
                      icon: Icons.title_rounded,
                    ),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Informe o titulo.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'description',
                      icon: Icons.notes_rounded,
                    ),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Informe a descricao.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    dropdownColor: AppColors.inputField,
                    iconEnabledColor: AppColors.textGrey,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'type',
                      icon: Icons.category_outlined,
                    ),
                    items: _types
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ),
                        )
                        .toList(),
                    onChanged: isSubmitting
                        ? null
                        : (value) => setState(() => _selectedType = value),
                    validator: (value) =>
                        value == null ? 'Selecione um tipo.' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _imageUrlController,
                    keyboardType: TextInputType.url,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'imageUrl',
                      icon: Icons.image_outlined,
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: isSubmitting ? null : _confirm,
                      icon: Icon(
                        _isEditing ? Icons.check_rounded : Icons.add_rounded,
                      ),
                      label: Text(
                        isSubmitting
                            ? (_isEditing ? 'salvando...' : 'criando...')
                            : (_isEditing ? 'Salvar' : 'Criar'),
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
      ),
    );
  }

  Future<void> _confirm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final success = await widget.onSubmit(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      type: _selectedType!,
      imageUrl: _imageUrlController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.pop(context, true);
    }
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
