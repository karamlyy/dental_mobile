import 'dart:math';

import 'package:dental_mobile/common/widgets/primary_button.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';
import '../cubit/patient_payments_cubit.dart';
import 'package:dental_mobile/core/error/app_error.dart';
import 'package:dental_mobile/common/widgets/error_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPaymentSheet extends StatefulWidget {
  final int patientId;
  final PatientPaymentsCubit cubit;
  final VoidCallback? onSuccess;

  const AddPaymentSheet({
    super.key,
    required this.patientId,
    required this.cubit,
    this.onSuccess,
  });

  @override
  State<AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<AddPaymentSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    final amount = _amountController.text.trim();
    if (amount.isEmpty) {
      Flushbar(
        message: 'Məbləğ daxil edin',
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.red,
      ).show(context);
      return;
    }

    setState(() => _isLoading = true);

    await widget.cubit.createPayment(
      widget.patientId,
      amount,
      _noteController.text.trim(),
      _selectedDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<PatientPaymentsCubit, PatientPaymentsState>(
      bloc: widget.cubit,
      listener: (context, state) {
        if (state is PatientPaymentsError) {
          setState(() => _isLoading = false);
          ErrorBottomSheet.show(
            context,
            AppError(
              message: state.message,
              error: state.error,
              statusCode: state.statusCode,
            ),
          );
        } else if (state is PatientPaymentsLoaded) {
          Navigator.pop(context);
          widget.onSuccess?.call();
        }
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
            left: 16,
            right: 16,
            top: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 🔹 Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
  
              /// 🔹 Title
              Text(
                l10n.newPayment,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.addNewPaymentForPatient,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
  
              const SizedBox(height: 24),
  
              /// 🔹 Amount Card
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _amountController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      labelText: l10n.amount,
                      prefixIcon: Icon(Icons.payments_outlined),
                    ),
                    autofocus: true,
                  ),
                ),
              ),
  
              const SizedBox(height: 16),

              /// 🔹 Date Card
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  onTap: _pickDate,
                  leading: const Icon(Icons.calendar_month_outlined),
                  title: Text(l10n.date),
                  subtitle: Text(
                    _selectedDate == null
                        ? l10n.selectDate
                        : DateFormat('dd.MM.yyyy').format(_selectedDate!),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
  
              const SizedBox(height: 16),
  
              /// 🔹 Note Card
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      labelText: l10n.paymentNoteOptional,
                      prefixIcon: Icon(Icons.notes_outlined),
                    ),
                  ),
                ),
              ),
  
              const SizedBox(height: 24),
              PrimaryButton(
                text: l10n.addPayment,
                isLoading: _isLoading,
                onPressed: _save,
                icon: Icons.add,
              ),
  
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}