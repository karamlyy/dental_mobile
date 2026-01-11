import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:dental_mobile/features/collaborations/presentation/cubit/collaborations_cubit.dart';
import 'package:dental_mobile/features/collaborations/presentation/widgets/add_collaboration_sheet.dart';
import 'package:dental_mobile/features/collaborations/presentation/widgets/collaboration_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';

class CollaborationsPage extends StatelessWidget {
  const CollaborationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Əməkdaşlıqlar')),
      floatingActionButton: Builder(
        builder: (context) {
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () async {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const AddCollaborationSheet(),
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
                    'Yeni əməkdaşlıq',
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
          BlocBuilder<CollaborationsCubit, CollaborationsState>(
            builder: (context, state) {
              if (state is CollaborationsLoading &&
                  state is! CollaborationsLoaded) {
                return const LoadingIndicator();
              }

              if (state is CollaborationsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Xəta baş verdi: ${state.message}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<CollaborationsCubit>()
                            .fetchCollaborations(),
                        child: const Text('Yenidən yoxla'),
                      ),
                    ],
                  ),
                );
              }

              if (state is CollaborationsLoaded) {
                final collaborations = state.collaborations;

                if (collaborations.isEmpty) {
                  return const Center(child: Text('Hələ ki əməkdaşlıq yoxdur'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: collaborations.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    final collaboration = collaborations[index];
                    final price = collaboration['price'];
                    final serviceName =
                        collaboration['serviceName'] ?? 'Xidmət adı yoxdur';
                    final technicianName =
                        collaboration['technicianName'] ?? 'Texnik adı yoxdur';
                    final description = collaboration['description'];

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => CollaborationDetailSheet(
                              collaboration: collaboration,
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Icon(
                              Icons.handshake_outlined,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          title: Text(
                            serviceName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('Texnik: $technicianName')],
                          ),
                          trailing: Text(
                            '$price AZN',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
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

//test
