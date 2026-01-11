import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/di.dart';
import '../cubit/patient_detail_cubit.dart';
import '../widgets/patient_header.dart';
import '../widgets/patient_tabs.dart';
import '../widgets/patient_financial_card.dart';

import 'package:flutter_svg/flutter_svg.dart';

class PatientDetailPage extends StatelessWidget {
  final int patientId;
  const PatientDetailPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => sl<PatientDetailCubit>()..fetchPatient(patientId),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            l10n.patientProfile,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
            BlocBuilder<PatientDetailCubit, PatientDetailState>(
              builder: (context, state) {
                if (state is PatientDetailLoading) {
                  return const LoadingIndicator();
                }
            
                if (state is PatientDetailLoaded) {
                  final patient = state.patient;
                  return Column(
                    children: [
                      PatientHeader(patient: patient),
                      PatientFinancialCard(patient: patient),
                      Expanded(child: PatientTabs(patientId: patientId)),
                    ],
                  );
                }
                if (state is PatientDetailError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}


