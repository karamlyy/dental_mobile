import 'dart:math';

import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/services_cubit.dart';
import '../widgets/add_service_sheet.dart';

import 'package:flutter_svg/flutter_svg.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.services)),
      floatingActionButton: Builder(
        builder: (context) {
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () async {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const AddServiceSheet(),
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
          BlocBuilder<ServicesCubit, ServicesState>(
            builder: (context, state) {
              if (state is ServicesLoading && state is! ServicesLoaded) {
                return const LoadingIndicator();
              }

              if (state is ServicesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Xəta baş verdi: ${state.message}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ServicesCubit>().fetchServices(),
                        child: const Text('Yenidən yoxla'),
                      ),
                    ],
                  ),
                );
              }

              if (state is ServicesLoaded) {
                final services = state.services;

                if (services.isEmpty) {
                  return const Center(child: Text('Hələ ki xidmət yoxdur'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: services.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    final service = services[index];
                    final price = service['price'];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Icon(
                            Icons.medical_services_outlined,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(
                          service['name'] ?? 'Adsız',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: price != null
                            ? Text('$price AZN')
                            : const Text('Qiymət təyin edilməyib'),
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
