import 'package:dental_mobile/features/patients/presentation/cubit/patients_cubit.dart';
import 'package:flutter/material.dart';

class AddPatientSheet extends StatefulWidget {
  final PatientsCubit cubit;

  const AddPatientSheet({super.key, required this.cubit});

  @override
  State<AddPatientSheet> createState() => _AddPatientSheetState();
}

class _AddPatientSheetState extends State<AddPatientSheet> {
  final _fullnameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final fullname = _fullnameController.text.trim();
    final phone = _phoneController.text.trim();
    if (fullname.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ad və soyad daxil edin')));
      return;
    }
    if (phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nömrə daxil edin')));
      return;
    }
    setState(() => _isLoading = true);

    await widget.cubit.addPatient(fullname, phone);

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
          Text('YENİ PASIYENT', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),

          TextField(
            controller: _fullnameController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Ad və Soyad',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Nömrə',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
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
