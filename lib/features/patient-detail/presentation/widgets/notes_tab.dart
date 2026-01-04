import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_notes_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_notes_state.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_note_sheet.dart';
import '../cubit/patient_note_creation_cubit.dart';

class NotesTab extends StatelessWidget {
  final int patientId;
  const NotesTab({super.key, required this.patientId});

  String _formatDate(String iso) {
    if (iso.isEmpty) return '';
    try {
      final date = DateTime.parse(iso).toLocal();
      return '${date.day}.${date.month}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => sl<PatientNotesCubit>()..fetchNotes(patientId),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<PatientNotesCubit, PatientNotesState>(
          builder: (context, state) {
            if (state is PatientNotesLoading) {
              return const LoadingIndicator();
            }

            if (state is PatientNotesLoaded) {
              if (state.notes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.noNotes,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.notes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 0),
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  final noteText = note['note'] ?? '';
                  final date = note['createdAt'] ?? '';

                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.sticky_note_2_rounded,
                        color: Colors.orange.shade700,
                      ),
                      title: Text(
                        noteText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _formatDate(date),
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            if (state is PatientNotesError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                final cubit = context.read<PatientNotesCubit>();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => AddNoteSheet(
                    patientId: patientId,
                    cubit: sl<PatientNoteCreationCubit>(),
                    onSuccess: () {
                      cubit.fetchNotes(patientId);
                    },
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha:0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      l10n.newNote,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
