import 'package:dental_mobile/core/localization/locale_state.dart';
import 'package:dental_mobile/core/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final SecureStorage _storage;
  static const String _localeKey = 'selected_locale';

  LocaleCubit(this._storage) : super(const LocaleState(Locale('az')));

  Future<void> loadLocale() async {
    final languageCode = await _storage.read(_localeKey);
    if (languageCode != null) {
      emit(LocaleState(Locale(languageCode)));
    } else {
      emit(const LocaleState(Locale('az')));
    }
  }

  Future<void> setLocale(Locale locale) async {
    await _storage.write(_localeKey, locale.languageCode);
    emit(LocaleState(locale));
  }
}
