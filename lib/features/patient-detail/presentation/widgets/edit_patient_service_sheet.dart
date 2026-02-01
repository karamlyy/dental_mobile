import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../../../common/widgets/primary_button.dart';
import '../cubit/patient_services_cubit.dart';
import '../cubit/patient_services_state.dart';
import '../cubit/patient_detail_cubit.dart';

class EditPatientServiceSheet extends StatefulWidget {
  final int patientId;
  final Map<String, dynamic> service;

  const EditPatientServiceSheet({
    super.key,
    required this.patientId,
    required this.service,
  });

  @override
  State<EditPatientServiceSheet> createState() => _EditPatientServiceSheetState();
}

class _EditPatientServiceSheetState extends State<EditPatientServiceSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service['name'] ?? '');
    _priceController = TextEditingController(
      text: widget.service['price']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());

    if (name.isEmpty || price == null) {
      Flushbar(
        message: 'Zəhmət olmasa xanaları düzgün doldurun',
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.red,
      ).show(context);
      return;
    }

    context.read<PatientServicesCubit>().updateService(
      patientId: widget.patientId,
      serviceId: widget.service['id'],
      name: name,
      price: price,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<PatientServicesCubit, PatientServicesState>(
      listener: (context, state) {
        if (state is PatientServicesLoaded) {
          Navigator.pop(context);
          context.read<PatientDetailCubit>().refreshPatient(widget.patientId);
        } else if (state is PatientServicesError) {
          Flushbar(
            message: state.message,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            backgroundColor: Colors.red,
          ).show(context);
        }
      },
      child: BlocBuilder<PatientServicesCubit, PatientServicesState>(
        builder: (context, state) {
          final isLoading = state is PatientServicesLoading;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 8,
                left: 16,
                right: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// Drag Handle
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

                    /// Title
                    Text(
                      'Xidməti redaktə et',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Xidmət məlumatlarını yeniləyin',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Service Name Card
                    Card(
                      elevation: 0,
                      color: theme.colorScheme.surfaceContainerHighest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: l10n.serviceName,
                            prefixIcon: const Icon(
                              Icons.medical_services_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Price Card
                    Card(
                      elevation: 0,
                      color: theme.colorScheme.surfaceContainerHighest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: l10n.price,
                            prefixIcon: const Icon(Icons.attach_money),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    PrimaryButton(
                      text: l10n.save,
                      isLoading: isLoading,
                      onPressed: _submit,
                      icon: Icons.check,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
