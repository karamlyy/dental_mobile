import 'package:dental_mobile/common/widgets/primary_button.dart';
import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/collaborations/presentation/cubit/collaboration_creation_cubit.dart';
import 'package:dental_mobile/features/collaborations/presentation/cubit/collaborations_cubit.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dental_mobile/core/error/app_error.dart';
import 'package:dental_mobile/common/widgets/error_bottom_sheet.dart';

class AddCollaborationSheet extends StatefulWidget {
  const AddCollaborationSheet({super.key});

  @override
  State<AddCollaborationSheet> createState() => _AddCollaborationSheetState();
}

class _AddCollaborationSheetState extends State<AddCollaborationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _technicianNameController = TextEditingController();
  final _serviceNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _technicianNameController.dispose();
    _serviceNameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final price = double.tryParse(_priceController.text);

      if (price == null) return;

      context.read<CollaborationCreationCubit>().addCollaboration(
            technicianName: _technicianNameController.text.trim(),
            serviceName: _serviceNameController.text.trim(),
            price: price,
            description: _descriptionController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => sl<CollaborationCreationCubit>(),
      child: BlocConsumer<CollaborationCreationCubit, CollaborationCreationState>(
        listener: (context, state) {
          if (state is CollaborationCreationSuccess) {
            context.read<CollaborationsCubit>().fetchCollaborations();
            Navigator.pop(context);

          } else if (state is CollaborationCreationError) {
            ErrorBottomSheet.show(
              context,
              AppError(
                message: state.message,
                error: state.error,
                statusCode: state.statusCode,
              ),
            );
          }
        },
        builder: (context, state) {
           final isLoading = state is CollaborationCreationLoading;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Form(
                key: _formKey,
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
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
        
                      /// 🔹 Title
                      Text(
                        l10n.newCollaboration,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.enterNewCollaborationInfo,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
        
                      const SizedBox(height: 24),
        
                      TextFormField(
                        controller: _technicianNameController,
                        decoration: InputDecoration(
                          labelText: 'Texnik adı',
                          prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? l10n.required  : null,
                      ),
                      const SizedBox(height: 12),
                  
                      TextFormField(
                        controller: _serviceNameController,
                        decoration: InputDecoration(
                          labelText: l10n.serviceName,
                          prefixIcon: const Icon(Icons.medical_services_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? l10n.required  : null,
                      ),
                      const SizedBox(height: 12),
                  
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: l10n.price,
                          prefixIcon: const Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) =>
                            value == null || value.isEmpty ? l10n.required  : null,
                      ),
                      const SizedBox(height: 12),
                  
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: l10n.description,
                          prefixIcon: const Icon(Icons.description_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true
                        ),
                        maxLines: 2,
                      ),
                      
                      const SizedBox(height: 32),
        
                      PrimaryButton(
                        text: l10n.create,
                        isLoading: isLoading,
                        onPressed: () => _submit(context),
                        icon: Icons.add,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
