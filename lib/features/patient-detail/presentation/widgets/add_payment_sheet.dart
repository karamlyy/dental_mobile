import 'package:flutter/material.dart';
import '../cubit/patient_payments_cubit.dart';

class AddPaymentSheet extends StatefulWidget {
  final int patientId;
  final PatientPaymentsCubit cubit;

  const AddPaymentSheet({
    super.key,
    required this.patientId,
    required this.cubit,
  });

  @override
  State<AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<AddPaymentSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = _amountController.text.trim();
    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Məbləğ daxil edin')),
      );
      return;
    }

    setState(() => _isLoading = true);

    await widget.cubit.createPayment(
      widget.patientId,
      amount,
      _noteController.text.trim(),
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
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
              'Yeni ödəniş',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pasiyent üçün yeni ödəniş əlavə edin',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            /// 🔹 Amount Card
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _amountController,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Məbləğ (AZN)',
                    prefixIcon: Icon(Icons.payments_outlined),
                  ),
                  autofocus: true,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 Note Card
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Qeyd (istəyə bağlı)',
                    prefixIcon: Icon(Icons.notes_outlined),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// 🔹 Action Button
            FilledButton(
              onPressed: _isLoading ? null : _save,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text(
                'Ödənişi əlavə et',
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}