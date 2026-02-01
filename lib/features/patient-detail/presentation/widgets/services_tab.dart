import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_services_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_services_state.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_service_sheet.dart';
import '../cubit/patient_service_creation_cubit.dart';
import '../cubit/patient_detail_cubit.dart';
import 'package:dental_mobile/features/services/presentation/cubit/services_cubit.dart';

class ServicesTab extends StatelessWidget {
  final int patientId;
  const ServicesTab({super.key, required this.patientId});

  String _formatDate(String iso) {
    final date = DateTime.parse(iso).toLocal();
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => sl<PatientServicesCubit>()..fetchServices(patientId),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<PatientServicesCubit, PatientServicesState>(
          builder: (context, state) {
            if (state is PatientServicesLoading) {
              return const LoadingIndicator();
            }

            if (state is PatientServicesLoaded) {
              if (state.services.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.medical_services_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                       Text(
                        'Xidmət tapılmadı',
                         style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.services.length,
                separatorBuilder: (_, __) => const SizedBox(height: 0),
                itemBuilder: (context, index) {
                  final service = state.services[index];

                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),

                    ),
                    child: ListTile(

                      leading: Icon(
                        Icons.medical_services_rounded,
                        color: Colors.blue.shade700,
                      ),
                      title: Text(
                        service['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _formatDate(service['createdAt']),
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      trailing: Text(
                        '${service['price']} ₼',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            if (state is PatientServicesError) {
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
                final cubit = context.read<PatientServicesCubit>();
                // Load services before opening the sheet
                context.read<ServicesCubit>().fetchServices();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => AddServiceSheet(
                    patientId: patientId,
                    cubit: sl<PatientServiceCreationCubit>(),
                  onSuccess: () {
                    cubit.fetchServices(patientId);
                    context.read<PatientDetailCubit>().refreshPatient(patientId);
                  },
                  ),
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
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      l10n.newService,
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
      ),
    );
  }
}
