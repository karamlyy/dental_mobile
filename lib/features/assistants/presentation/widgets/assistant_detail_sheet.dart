import 'package:dental_mobile/common/widgets/primary_button.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AssistantDetailSheet extends StatelessWidget {
  final Map<String, dynamic> assistant;

  const AssistantDetailSheet({super.key, required this.assistant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - 
                     MediaQuery.of(context).padding.top - 
                     kToolbarHeight - 
                     20,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
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

                Row(
                  children: [
                    Text(
                      'Assistant detalları',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                // Full Name
                _DetailField(
                  icon: Icons.person_outline,
                  label: l10n.nameAndSurname,
                  value: assistant['fullName'] ?? 'N/A',
                  theme: theme,
                ),
                const SizedBox(height: 16),

                // Email
                _DetailField(
                  icon: Icons.email_outlined,
                  label: l10n.email,
                  value: assistant['email'] ?? 'N/A',
                  theme: theme,
                ),
                const SizedBox(height: 16),

                // Phone Number
                _DetailField(
                  icon: Icons.phone_outlined,
                  label: l10n.phoneNumber,
                  value: assistant['phoneNumber'] ?? 'N/A',
                  theme: theme,
                ),
                const SizedBox(height: 16),

                // Gender
                _DetailField(
                  icon: Icons.wc_outlined,
                  label: l10n.gender,
                  value: _getGenderText(assistant['gender'], l10n),
                  theme: theme,
                ),

                const SizedBox(height: 32),

                PrimaryButton(text: 'Bağla', onPressed: () => Navigator.pop(context),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGenderText(String? gender, AppLocalizations l10n) {
    if (gender == null) return 'N/A';
    switch (gender.toUpperCase()) {
      case 'MALE':
        return l10n.male;
      case 'FEMALE':
        return l10n.female;
      default:
        return gender;
    }
  }
}

class _DetailField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _DetailField({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
