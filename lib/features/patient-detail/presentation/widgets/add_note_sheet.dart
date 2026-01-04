import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/primary_button.dart';
import '../cubit/patient_note_creation_cubit.dart';
import '../cubit/patient_note_creation_state.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';

class AddNoteSheet extends StatefulWidget {
  final int patientId;
  final PatientNoteCreationCubit cubit;
  final VoidCallback onSuccess;

  const AddNoteSheet({
    super.key,
    required this.patientId,
    required this.cubit,
    required this.onSuccess,
  });

  @override
  State<AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<AddNoteSheet> {
  final _noteController = TextEditingController();
  
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final note = _noteController.text.trim();

    if (note.isEmpty) {
      return;
    }
   
    widget.cubit.createNote(
      patientId: widget.patientId,
      note: note,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: widget.cubit,
      child: BlocConsumer<PatientNoteCreationCubit,
          PatientNoteCreationState>(
        listener: (context, state) {
          if (state is PatientNoteCreationSuccess) {
            Navigator.pop(context);
            widget.onSuccess();
          } else if (state is PatientNoteCreationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PatientNoteCreationLoading;

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
                    l10n.addNote,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.enterNote,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 Note Input Card
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: l10n.note,
                          prefixIcon: const Icon(Icons.note_alt_outlined),
                        ),
                        autofocus: true,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  PrimaryButton(
                    text: l10n.addNote,
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
