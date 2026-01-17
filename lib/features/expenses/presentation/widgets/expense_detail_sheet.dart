import 'package:dental_mobile/common/widgets/primary_button.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:another_flushbar/flushbar.dart';
import '../cubit/expenses_cubit.dart';

class ExpenseDetailSheet extends StatefulWidget {
  final Map<String, dynamic> expense;

  const ExpenseDetailSheet({super.key, required this.expense});

  @override
  State<ExpenseDetailSheet> createState() => _ExpenseDetailSheetState();
}

class _ExpenseDetailSheetState extends State<ExpenseDetailSheet> {
  bool _isEditMode = false;
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.expense['title'] ?? '',
    );
    _priceController = TextEditingController(
      text: widget.expense['price']?.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.expense['description'] ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _cancelEdit() {
    setState(() {
      _titleController.text = widget.expense['title'] ?? '';
      _priceController.text = widget.expense['price']?.toString() ?? '';
      _descriptionController.text = widget.expense['description'] ?? '';
      _isEditMode = false;
    });
  }

  void _saveChanges() {
    final l10n = AppLocalizations.of(context)!;
    final expenseId = widget.expense['id'];
    final title = _titleController.text.trim();
    final priceValue = double.tryParse(_priceController.text.trim());
    final desc = _descriptionController.text.trim();

    if (title.isEmpty) {
      Flushbar(
        message: 'Xərc adı boş ola bilməz',
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.red,
      ).show(context);
      return;
    }

    if (priceValue == null) {
      Flushbar(
        message: 'Qiymət formatı düzgün deyil',
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.red,
      ).show(context);
      return;
    }

    final body = {'title': title, 'price': priceValue, 'description': desc};

    context.read<ExpensesCubit>().updateExpense(expenseId, body);
    Navigator.pop(context); // Close bottom sheet

    // Show success message after navigation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        Flushbar(
          message: 'Xərc yeniləndi',
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.green,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        ).show(context);
      }
    });
  }

  void _showDeleteDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final expenseId = widget.expense['id'];
    final expenseTitle = widget.expense['title'];

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Xərci sil'),
        content: Text(
          '${expenseTitle ?? 'Bu xərci'} silmək istədiyinizdən əminsiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              context.read<ExpensesCubit>().deleteExpense(expenseId);

              // Show success message after navigation
              Future.delayed(const Duration(milliseconds: 100), () {
                if (context.mounted) {
                  Flushbar(
                    message: 'Xərc silindi',
                    duration: const Duration(seconds: 3),
                    margin: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: Colors.green,
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                  ).show(context);
                }
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - 
                     MediaQuery.of(context).padding.top - 
                     kToolbarHeight - 
                     20,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              /// 🔹 Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              if (!_isEditMode) ...[
                Row(
                  children: [
                    Text(
                      'Xərc detalları',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    Text(
                      'Xərci redaktə et',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: _cancelEdit,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          l10n.cancel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ],
              const SizedBox(height: 24),

              TextFormField(
                controller: _titleController,
                readOnly: !_isEditMode,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: l10n.expenseName,
                  prefixIcon: Icon(Icons.receipt_long),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _isEditMode ? null : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                readOnly: !_isEditMode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.amount,
                  prefixIcon: Icon(Icons.attach_money),
                  suffixText: '₼',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _isEditMode ? null : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              // Description field
              TextFormField(
                controller: _descriptionController,
                readOnly: !_isEditMode,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.description,
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _isEditMode ? null : theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 32),

              if (!_isEditMode) ...[
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showDeleteDialog(context),
                          icon: Icon(
                            CupertinoIcons.delete,
                            color: theme.colorScheme.error,
                          ),
                          label: Text(
                            l10n.delete,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.colorScheme.error),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _toggleEditMode,
                          icon: Icon(CupertinoIcons.pencil),
                          label: Text(l10n.edit),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: l10n.save,
                        onPressed: _saveChanges,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
          ),
        ),
      );
  }
}
