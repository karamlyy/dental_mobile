import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/assistants_cubit.dart';
import '../widgets/add_assistant_sheet.dart';

import 'package:flutter_svg/flutter_svg.dart';

class AssistantsPage extends StatelessWidget {
  const AssistantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Assistantlar')),
      floatingActionButton: Builder(
        builder: (context) {
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () async {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const AddAssistantSheet(),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Yeni assistant',
                    style: TextStyle(
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

      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: isDarkMode ? 0.02 : 0.7,
              child: SvgPicture.asset(
                'assets/icons/appBackground.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          BlocBuilder<AssistantsCubit, AssistantsState>(
            builder: (context, state) {
              if (state is AssistantsLoading && state is! AssistantsLoaded) {
                return const LoadingIndicator();
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
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 0),
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
        ],
      ),
    );
  }
}
