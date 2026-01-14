import 'dart:math';

import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CollaborationDetailSheet extends StatelessWidget {
  final Map<String, dynamic> collaboration;

  const CollaborationDetailSheet({super.key, required this.collaboration});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final serviceName = collaboration['serviceName'] ?? 'Xidmət adı yoxdur';
    final technicianName =
        collaboration['technicianName'] ?? 'Texnik adı yoxdur';
    final description = collaboration['description'] ?? 'Təsvir yoxdur';
    final price = collaboration['price'];
    final createdAt = collaboration['createdAt'];

    String formattedDate = '';
    if (createdAt != null) {
      try {
        final date = DateTime.parse(createdAt);
        formattedDate = DateFormat('dd MMMM yyyy, HH:mm').format(date);
      } catch (e) {

      }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 🔹 Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
  
              Center(
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.handshake_outlined,
                    size: 32,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 16),
  
              Text(
                serviceName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
  
              _DetailRow(
                icon: Icons.person_outline,
                label: l10n.technician,
                value: technicianName,
              ),
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.attach_money,
                label: l10n.price,
                value: '$price ₼',
                valueColor: theme.colorScheme.primary,
                isBold: true,
              ),
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.description_outlined,
                label: l10n.description,
                value: description,
              ),
              if (formattedDate.isNotEmpty) ...[
                const SizedBox(height: 16),
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: l10n.createdAt,
                  value: formattedDate,
                ),
              ],
  
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: valueColor,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
