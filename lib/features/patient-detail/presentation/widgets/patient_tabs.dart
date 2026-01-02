import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'appointments_tab.dart';
import 'payments_tab.dart';
import 'services_tab.dart';

class PatientTabs extends StatelessWidget {
  final int patientId;
  const PatientTabs({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
           TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: l10n.appointments),
              Tab(text: l10n.services),
              Tab(text: l10n.payments),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                AppointmentsTab(patientId: patientId),
                ServicesTab(patientId: patientId),
                PaymentsTab(patientId: patientId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
