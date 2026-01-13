import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../services/presentation/cubit/services_cubit.dart';
import '../cubit/patient_service_creation_cubit.dart';
import '../cubit/patient_service_creation_state.dart';

class AddServiceSheet extends StatefulWidget {
  final int patientId;
  final PatientServiceCreationCubit cubit;
  final VoidCallback onSuccess;

  const AddServiceSheet({
    super.key,
    required this.patientId,
    required this.cubit,
    required this.onSuccess,
  });

  @override
  State<AddServiceSheet> createState() => _AddServiceSheetState();
}

class _AddServiceSheetState extends State<AddServiceSheet> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zəhmət olmasa xanaları düzgün doldurun')),
      );
      return;
    }
    setState(() => _isLoading = true);

    widget.cubit.createService(
      patientId: widget.patientId,
      name: name,
      price: price,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: widget.cubit,
      child: BlocConsumer<PatientServiceCreationCubit,
          PatientServiceCreationState>(
        listener: (context, state) {
          if (state is PatientServiceCreationSuccess) {
            Navigator.pop(context);
            widget.onSuccess();
          } else if (state is PatientServiceCreationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PatientServiceCreationLoading;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 8,
                left: 16,
                right: 16,
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
                    l10n.newService,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.enterNewServiceInfo,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 Service Name Card
                  BlocBuilder<ServicesCubit, ServicesState>(
                    builder: (context, servicesState) {
                      if (servicesState is ServicesLoaded &&
                          servicesState.services.isNotEmpty) {
                        return Card(
                          elevation: 0,
                          color: theme.colorScheme.surfaceContainerHighest,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            child: DropdownButtonFormField<Map<String, dynamic>>(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: l10n.serviceName,
                                prefixIcon:
                                    Icon(Icons.medical_services_outlined),
                              ),
                              items: servicesState.services.map((service) {
                                return DropdownMenuItem(
                                  value: service,
                                  child: Text(
                                    service['name'] ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  _nameController.text = value['name'] ?? '';
                                  _priceController.text =
                                      value['price']?.toString() ?? '';
                                }
                              },
                              hint: const Text('Xidmət seçin'),
                            ),
                          ),
                        );
                      }

                      // Fallback to manual entry if no services or loading
                      return Card(
                        elevation: 0,
                        color: theme.colorScheme.surfaceContainerHighest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: l10n.serviceName,
                              hintText: 'Məs: İmplant',
                              prefixIcon: Icon(Icons.medical_services_outlined),

                            ),
                            validator: (value) => value == null || value.isEmpty ? l10n.required  : null,
                            autofocus: true,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 Price Card
                  Card(
                    elevation: 0,
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: l10n.price,
                          hintText: 'Məs: 500',
                          prefixIcon: Icon(Icons.attach_money),
                        ),

                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  PrimaryButton(
                    text: l10n.save,
                    isLoading: isLoading,
                    onPressed: _submit,
                    icon: Icons.check,
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
