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

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'YENİ ÖDƏNİŞ',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Məbləğ (AZN)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Qeyd',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.note),
            ),
          ),
          
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _save,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Əlavə et'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
