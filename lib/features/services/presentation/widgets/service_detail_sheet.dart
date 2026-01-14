import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/services_cubit.dart';

class ServiceDetailSheet extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceDetailSheet({
    super.key,
    required this.service,
  });

  void _showDeleteDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final serviceId = service['id'];
    final serviceName = service['name'];

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteService),
        content: Text('${serviceName ?? 'Bu xidməti'} silmək istədiyinizdən əminsiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              context.read<ServicesCubit>().deleteService(serviceId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.serviceDeleted)),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final serviceName = service['name'] ?? 'Xidmət adı yoxdur';
    final price = service['price'];
    final description = service['description'];

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
                    Icons.medical_services_outlined,
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
                icon: Icons.attach_money,
                label: l10n.price,
                value: price != null ? '$price ₼' : 'Qiymət təyin edilməyib',
                valueColor: theme.colorScheme.primary,
                isBold: true,
              ),
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.description_outlined,
                label: l10n.description,
                value: description != null && description.toString().isNotEmpty
                    ? description.toString()
                    : 'Təsvir yoxdur',
              ),

              const SizedBox(height: 32),

              // Delete button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showDeleteDialog(context),
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.delete),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
