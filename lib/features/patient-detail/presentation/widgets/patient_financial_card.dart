import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/di.dart';
import '../cubit/patient_detail_cubit.dart';
import '../cubit/patient_service_creation_cubit.dart';
import 'add_service_sheet.dart';

class PatientFinancialCard extends StatelessWidget {
  final Map<String, dynamic> patient;

  const PatientFinancialCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final totalAmount = _parseValue(patient['totalAmount']);
    final paidAmount = _parseValue(patient['paidAmount']);
    final debt = _parseValue(patient['debt']);

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            context,
            label: l10n.general,
            value: totalAmount,
            color: Colors.blue,
          ),
          _buildVerticalDivider(),
          _buildInfoItem(
            context,
            label: l10n.paid,
            value: paidAmount,
            color: Colors.green,
          ),
          _buildVerticalDivider(),
          _buildInfoItem(
            context,
            label: l10n.debt,
            value: debt,
            color: debt > 0 ? Colors.red : Colors.grey,
            isBold: true,
          ),
        ],
      ),
    );
  }

  double _parseValue(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.2),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required String label,
    required double value,
    required Color color,
    bool isBold = false,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(0)} ₼',
          style: TextStyle(
            fontSize: 18,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
