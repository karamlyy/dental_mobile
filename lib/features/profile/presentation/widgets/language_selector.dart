import 'package:dental_mobile/core/localization/locale_cubit.dart';
import 'package:dental_mobile/core/localization/locale_state.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        String currentLang;
        switch (state.locale.languageCode) {
          case 'en':
            currentLang = l10n.english;
            break;
          case 'ru':
            currentLang = l10n.russian;
            break;
          case 'az':
          default:
            currentLang = l10n.azerbaijani;
        }

        return InkWell(
          onTap: () => _showLanguageBottomSheet(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.changeLanguage,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  currentLang,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCubit = context.read<LocaleCubit>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(l10n.azerbaijani),
                onTap: () {
                  localeCubit.setLocale(const Locale('az'));
                  Navigator.pop(context);
                },
                trailing: localeCubit.state.locale.languageCode == 'az'
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
              ),
              ListTile(
                title: Text(l10n.english),
                onTap: () {
                  localeCubit.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
                trailing: localeCubit.state.locale.languageCode == 'en'
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
              ),
              ListTile(
                title: Text(l10n.russian),
                onTap: () {
                  localeCubit.setLocale(const Locale('ru'));
                  Navigator.pop(context);
                },
                trailing: localeCubit.state.locale.languageCode == 'ru'
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}