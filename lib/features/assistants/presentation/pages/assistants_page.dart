import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/assistants_cubit.dart';
import '../widgets/add_assistant_sheet.dart';

class AssistantsPage extends StatelessWidget {
  const AssistantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Assistantlar')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddAssistantSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<AssistantsCubit, AssistantsState>(
        builder: (context, state) {
          if (state is AssistantsLoading && state is! AssistantsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AssistantsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Xəta baş verdi: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AssistantsCubit>().fetchAssistants(),
                    child: const Text('Yenidən yoxla'),
                  ),
                ],
              ),
            );
          }

          if (state is AssistantsLoaded) {
            final assistants = state.assistants;

            if (assistants.isEmpty) {
              return const Center(child: Text('Hələ ki assistant yoxdur'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: assistants.length,
              separatorBuilder: (context, index) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                final assistant = assistants[index];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        (assistant['fullName'] as String? ?? '?')[0]
                            .toUpperCase(),
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      assistant['fullName'] ?? 'Adsız',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(assistant['email'] ?? ''),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
