import 'package:flutter/material.dart';

import 'appointments_tab.dart';
import 'payments_tab.dart';

class PatientTabs extends StatelessWidget {
  final int patientId;
  const PatientTabs({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'Görüşlər'),
              Tab(text: 'Ödənişlər'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                AppointmentsTab(patientId: patientId),
                PaymentsTab(patientId: patientId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
