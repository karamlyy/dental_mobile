import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_az.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('az'),
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @profile.
  ///
  /// In az, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In az, this message translates to:
  /// **'Tənzimləmələr'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In az, this message translates to:
  /// **'Qaranlıq rejim'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In az, this message translates to:
  /// **'Açıq rejim'**
  String get lightMode;

  /// No description provided for @assistants.
  ///
  /// In az, this message translates to:
  /// **'Assistantlar'**
  String get assistants;

  /// No description provided for @assistantsList.
  ///
  /// In az, this message translates to:
  /// **'Assistant siyahısı'**
  String get assistantsList;

  /// No description provided for @logout.
  ///
  /// In az, this message translates to:
  /// **'Çıxış et'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In az, this message translates to:
  /// **'Hesabdan çıxış'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In az, this message translates to:
  /// **'Hesabdan çıxmaq istədiyinizə əminsiniz?'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In az, this message translates to:
  /// **'Ləğv et'**
  String get cancel;

  /// No description provided for @changeLanguage.
  ///
  /// In az, this message translates to:
  /// **'Dili dəyiş'**
  String get changeLanguage;

  /// No description provided for @azerbaijani.
  ///
  /// In az, this message translates to:
  /// **'Azərbaycan dili'**
  String get azerbaijani;

  /// No description provided for @english.
  ///
  /// In az, this message translates to:
  /// **'İngilis dili'**
  String get english;

  /// No description provided for @russian.
  ///
  /// In az, this message translates to:
  /// **'Rus dili'**
  String get russian;

  /// No description provided for @nextAppointments.
  ///
  /// In az, this message translates to:
  /// **'Növbəti görüşlər'**
  String get nextAppointments;

  /// No description provided for @nextAppointment.
  ///
  /// In az, this message translates to:
  /// **'Növbəti görüş'**
  String get nextAppointment;

  /// No description provided for @scheduled.
  ///
  /// In az, this message translates to:
  /// **'Planlaşdırılıb'**
  String get scheduled;

  /// No description provided for @completed.
  ///
  /// In az, this message translates to:
  /// **'Tamamlandı'**
  String get completed;

  /// No description provided for @canceled.
  ///
  /// In az, this message translates to:
  /// **'Ləğv edilib'**
  String get canceled;

  /// No description provided for @confirmed.
  ///
  /// In az, this message translates to:
  /// **'Təsdiqlənib'**
  String get confirmed;

  /// No description provided for @todayAppointments.
  ///
  /// In az, this message translates to:
  /// **'Bu günün görüşləri'**
  String get todayAppointments;

  /// No description provided for @noAppointments.
  ///
  /// In az, this message translates to:
  /// **'Görüş yoxdur'**
  String get noAppointments;

  /// No description provided for @appointments.
  ///
  /// In az, this message translates to:
  /// **'Görüşlər'**
  String get appointments;

  /// No description provided for @patients.
  ///
  /// In az, this message translates to:
  /// **'Pasiyentlər'**
  String get patients;

  /// No description provided for @patientProfile.
  ///
  /// In az, this message translates to:
  /// **'Pasiyent profili'**
  String get patientProfile;

  /// No description provided for @newAppointment.
  ///
  /// In az, this message translates to:
  /// **'Yeni görüş'**
  String get newAppointment;

  /// No description provided for @date.
  ///
  /// In az, this message translates to:
  /// **'Tarix'**
  String get date;

  /// No description provided for @selectDate.
  ///
  /// In az, this message translates to:
  /// **'Tarixi seçin'**
  String get selectDate;

  /// No description provided for @startTime.
  ///
  /// In az, this message translates to:
  /// **'Başlama vaxtı'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In az, this message translates to:
  /// **'Bitmə vaxtı'**
  String get endTime;

  /// No description provided for @selectTime.
  ///
  /// In az, this message translates to:
  /// **'Vaxtı seçin'**
  String get selectTime;

  /// No description provided for @newPatient.
  ///
  /// In az, this message translates to:
  /// **'Yeni pasiyent'**
  String get newPatient;

  /// No description provided for @addNewPatient.
  ///
  /// In az, this message translates to:
  /// **'Yeni pasiyent əlavə et'**
  String get addNewPatient;

  /// No description provided for @searchPatients.
  ///
  /// In az, this message translates to:
  /// **'Pasiyentləri axtar'**
  String get searchPatients;

  /// No description provided for @enterPatientInfo.
  ///
  /// In az, this message translates to:
  /// **'Pasiyent məlumatlarını daxil edin'**
  String get enterPatientInfo;

  /// No description provided for @nameAndSurname.
  ///
  /// In az, this message translates to:
  /// **'Ad və soyad'**
  String get nameAndSurname;

  /// No description provided for @phoneNumber.
  ///
  /// In az, this message translates to:
  /// **'Telefon nömrəsi'**
  String get phoneNumber;

  /// No description provided for @emailAddress.
  ///
  /// In az, this message translates to:
  /// **'E-poçt ünvanı'**
  String get emailAddress;

  /// No description provided for @addPatient.
  ///
  /// In az, this message translates to:
  /// **'Pasiyent əlavə et'**
  String get addPatient;

  /// No description provided for @appointment.
  ///
  /// In az, this message translates to:
  /// **'Görüş detalları'**
  String get appointment;

  /// No description provided for @payments.
  ///
  /// In az, this message translates to:
  /// **'Ödənişlər'**
  String get payments;

  /// No description provided for @newPayment.
  ///
  /// In az, this message translates to:
  /// **'Yeni ödəniş'**
  String get newPayment;

  /// No description provided for @addNewPaymentForPatient.
  ///
  /// In az, this message translates to:
  /// **'Pasiyent üçün yeni ödəniş əlavə et'**
  String get addNewPaymentForPatient;

  /// No description provided for @amount.
  ///
  /// In az, this message translates to:
  /// **'Məbləğ (₼)'**
  String get amount;

  /// No description provided for @paymentNoteOptional.
  ///
  /// In az, this message translates to:
  /// **'Ödəniş qeydi (istəyə bağlı)'**
  String get paymentNoteOptional;

  /// No description provided for @addPayment.
  ///
  /// In az, this message translates to:
  /// **'Ödəniş əlavə et'**
  String get addPayment;

  /// No description provided for @noPatientsFound.
  ///
  /// In az, this message translates to:
  /// **'Pasiyent tapılmadı'**
  String get noPatientsFound;

  /// No description provided for @noAppointmentsFound.
  ///
  /// In az, this message translates to:
  /// **'Görüş tapılmadı'**
  String get noAppointmentsFound;

  /// No description provided for @noPaymentsFound.
  ///
  /// In az, this message translates to:
  /// **'Ödəniş tapılmadı'**
  String get noPaymentsFound;

  /// No description provided for @noNotes.
  ///
  /// In az, this message translates to:
  /// **'Qeyd yoxdur'**
  String get noNotes;

  /// No description provided for @arrangeNewAppointmentForPatient.
  ///
  /// In az, this message translates to:
  /// **'Pasiyent üçün yeni görüş təyin et'**
  String get arrangeNewAppointmentForPatient;

  /// No description provided for @createAppointment.
  ///
  /// In az, this message translates to:
  /// **'Görüş yarat'**
  String get createAppointment;

  /// No description provided for @welcome.
  ///
  /// In az, this message translates to:
  /// **'Xoş gəlmisiniz'**
  String get welcome;

  /// No description provided for @enterCredentials.
  ///
  /// In az, this message translates to:
  /// **'Daxil olmaq üçün məlumatlarınızı daxil edin'**
  String get enterCredentials;

  /// No description provided for @login.
  ///
  /// In az, this message translates to:
  /// **'Daxil ol'**
  String get login;

  /// No description provided for @register.
  ///
  /// In az, this message translates to:
  /// **'Qeydiyyat'**
  String get register;

  /// No description provided for @email.
  ///
  /// In az, this message translates to:
  /// **'E-poçt'**
  String get email;

  /// No description provided for @password.
  ///
  /// In az, this message translates to:
  /// **'Şifrə'**
  String get password;

  /// No description provided for @haveAccount.
  ///
  /// In az, this message translates to:
  /// **'Hesabınız var?'**
  String get haveAccount;

  /// No description provided for @noAccount.
  ///
  /// In az, this message translates to:
  /// **'Hesabınız yoxdur?'**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In az, this message translates to:
  /// **'Hesab yarat'**
  String get createAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In az, this message translates to:
  /// **'Şifrəni unutmusunuz?'**
  String get forgotPassword;

  /// No description provided for @enterCredentialsToRegister.
  ///
  /// In az, this message translates to:
  /// **'Qeydiyyatdan keçmək üçün məlumatlarınızı daxil edin'**
  String get enterCredentialsToRegister;

  /// No description provided for @endTimeBeforeStartTime.
  ///
  /// In az, this message translates to:
  /// **'Bitmə vaxtı başlanğıc vaxtdan əvvəl ola bilməz'**
  String get endTimeBeforeStartTime;

  /// No description provided for @seeAll.
  ///
  /// In az, this message translates to:
  /// **'Hamısına bax'**
  String get seeAll;

  /// No description provided for @services.
  ///
  /// In az, this message translates to:
  /// **'Xidmətlər'**
  String get services;

  /// No description provided for @gender.
  ///
  /// In az, this message translates to:
  /// **'Cins'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In az, this message translates to:
  /// **'Kişi'**
  String get male;

  /// No description provided for @female.
  ///
  /// In az, this message translates to:
  /// **'Qadın'**
  String get female;

  /// No description provided for @notes.
  ///
  /// In az, this message translates to:
  /// **'Qeydlər'**
  String get notes;

  /// No description provided for @newNote.
  ///
  /// In az, this message translates to:
  /// **'Yeni qeyd'**
  String get newNote;

  /// No description provided for @addNote.
  ///
  /// In az, this message translates to:
  /// **'Qeyd əlavə et'**
  String get addNote;

  /// No description provided for @note.
  ///
  /// In az, this message translates to:
  /// **'Qeyd'**
  String get note;

  /// No description provided for @enterNote.
  ///
  /// In az, this message translates to:
  /// **'Qeyd daxil edin'**
  String get enterNote;

  /// No description provided for @collaborations.
  ///
  /// In az, this message translates to:
  /// **'Əməkdaşlıqlar'**
  String get collaborations;

  /// No description provided for @myExpenses.
  ///
  /// In az, this message translates to:
  /// **'Xərclərim'**
  String get myExpenses;

  /// No description provided for @clinicName.
  ///
  /// In az, this message translates to:
  /// **'Klinika adı'**
  String get clinicName;

  /// No description provided for @address.
  ///
  /// In az, this message translates to:
  /// **'Ünvan'**
  String get address;

  /// No description provided for @specialization.
  ///
  /// In az, this message translates to:
  /// **'İxtisas'**
  String get specialization;

  /// No description provided for @editProfile.
  ///
  /// In az, this message translates to:
  /// **'Profili redaktə et'**
  String get editProfile;

  /// No description provided for @saveChanges.
  ///
  /// In az, this message translates to:
  /// **'Dəyişiklikləri yadda saxla'**
  String get saveChanges;

  /// No description provided for @edit.
  ///
  /// In az, this message translates to:
  /// **'Redaktə et'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In az, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In az, this message translates to:
  /// **'Silməyi təsdiqləyin'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In az, this message translates to:
  /// **'Bu elementi silmək istədiyinizə əminsiniz?'**
  String get deleteConfirmMessage;

  /// No description provided for @goodMorning.
  ///
  /// In az, this message translates to:
  /// **'Sabahınız xeyir'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In az, this message translates to:
  /// **'Günortanız xeyir'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In az, this message translates to:
  /// **'Axşamınız xeyir'**
  String get goodEvening;

  /// No description provided for @birthDate.
  ///
  /// In az, this message translates to:
  /// **'Doğum tarixi'**
  String get birthDate;

  /// No description provided for @viewAll.
  ///
  /// In az, this message translates to:
  /// **'Hamısına bax'**
  String get viewAll;

  /// No description provided for @newExpense.
  ///
  /// In az, this message translates to:
  /// **'Yeni xərc'**
  String get newExpense;

  /// No description provided for @expenseName.
  ///
  /// In az, this message translates to:
  /// **'Xərc adı'**
  String get expenseName;

  /// No description provided for @description.
  ///
  /// In az, this message translates to:
  /// **'Təsvir'**
  String get description;

  /// No description provided for @createdAt.
  ///
  /// In az, this message translates to:
  /// **'Yaradılıb'**
  String get createdAt;

  /// No description provided for @enterNewExpenseInfo.
  ///
  /// In az, this message translates to:
  /// **'Yeni xərc məlumatlarını daxil edin'**
  String get enterNewExpenseInfo;

  /// No description provided for @create.
  ///
  /// In az, this message translates to:
  /// **'Yarat'**
  String get create;

  /// No description provided for @assistantsListTitle.
  ///
  /// In az, this message translates to:
  /// **'Assistantlar'**
  String get assistantsListTitle;

  /// No description provided for @newAssistant.
  ///
  /// In az, this message translates to:
  /// **'Yeni assistant'**
  String get newAssistant;

  /// No description provided for @enterNewAssistantInfo.
  ///
  /// In az, this message translates to:
  /// **'Yeni assistant məlumatlarını daxil edin'**
  String get enterNewAssistantInfo;

  /// No description provided for @newService.
  ///
  /// In az, this message translates to:
  /// **'Yeni xidmət'**
  String get newService;

  /// No description provided for @enterNewServiceInfo.
  ///
  /// In az, this message translates to:
  /// **'Yeni xidmət məlumatlarını daxil edin'**
  String get enterNewServiceInfo;

  /// No description provided for @serviceName.
  ///
  /// In az, this message translates to:
  /// **'Xidmətin adı'**
  String get serviceName;

  /// No description provided for @technician.
  ///
  /// In az, this message translates to:
  /// **'Texnik'**
  String get technician;

  /// No description provided for @newCollaboration.
  ///
  /// In az, this message translates to:
  /// **'Yeni əməkdaşlıq'**
  String get newCollaboration;

  /// No description provided for @enterNewCollaborationInfo.
  ///
  /// In az, this message translates to:
  /// **'Yeni əməkdaşlıq məlumatlarını daxil edin'**
  String get enterNewCollaborationInfo;

  /// No description provided for @technicianName.
  ///
  /// In az, this message translates to:
  /// **'Texnik adı'**
  String get technicianName;

  /// No description provided for @doctorPanel.
  ///
  /// In az, this message translates to:
  /// **'Həkim paneli'**
  String get doctorPanel;

  /// No description provided for @enterProfileInfoToEdit.
  ///
  /// In az, this message translates to:
  /// **'Yeniləmək istədiyiniz məlumatları daxil edin'**
  String get enterProfileInfoToEdit;

  /// No description provided for @price.
  ///
  /// In az, this message translates to:
  /// **'Qiymət'**
  String get price;

  /// No description provided for @required.
  ///
  /// In az, this message translates to:
  /// **'Mütləqdir'**
  String get required;

  /// No description provided for @save.
  ///
  /// In az, this message translates to:
  /// **'Yadda saxla'**
  String get save;

  /// No description provided for @todayAppointmentsZero.
  ///
  /// In az, this message translates to:
  /// **'Bu gün görüşünüz yoxdur'**
  String get todayAppointmentsZero;

  /// No description provided for @today.
  ///
  /// In az, this message translates to:
  /// **'Bu gün'**
  String get today;

  /// No description provided for @overall.
  ///
  /// In az, this message translates to:
  /// **'Ümumi'**
  String get overall;

  /// No description provided for @noServicesFound.
  ///
  /// In az, this message translates to:
  /// **'Xidmət tapılmadı'**
  String get noServicesFound;

  /// No description provided for @noAssistantsFound.
  ///
  /// In az, this message translates to:
  /// **'Assistant tapılmadı'**
  String get noAssistantsFound;

  /// No description provided for @noCollaborationsFound.
  ///
  /// In az, this message translates to:
  /// **'Əməkdaşlıq tapılmadı'**
  String get noCollaborationsFound;

  /// No description provided for @noExpensesFound.
  ///
  /// In az, this message translates to:
  /// **'Xərc tapılmadı'**
  String get noExpensesFound;

  /// No description provided for @noPatientNotesFound.
  ///
  /// In az, this message translates to:
  /// **'Pasiyent qeydi tapılmadı'**
  String get noPatientNotesFound;

  /// No description provided for @noDataFound.
  ///
  /// In az, this message translates to:
  /// **'Məlumat tapılmadı'**
  String get noDataFound;

  /// No description provided for @general.
  ///
  /// In az, this message translates to:
  /// **'Ümumi'**
  String get general;

  /// No description provided for @debt.
  ///
  /// In az, this message translates to:
  /// **'Borc'**
  String get debt;

  /// No description provided for @paid.
  ///
  /// In az, this message translates to:
  /// **'Ödənilib'**
  String get paid;

  /// No description provided for @notifications.
  ///
  /// In az, this message translates to:
  /// **'Bildirişlər'**
  String get notifications;

  /// No description provided for @privacy.
  ///
  /// In az, this message translates to:
  /// **'Məxfilik'**
  String get privacy;

  /// No description provided for @security.
  ///
  /// In az, this message translates to:
  /// **'Təhlükəsizlik'**
  String get security;

  /// No description provided for @appointmentStatus.
  ///
  /// In az, this message translates to:
  /// **'Görüş statusu'**
  String get appointmentStatus;

  /// No description provided for @updateAppointmentStatus.
  ///
  /// In az, this message translates to:
  /// **'Görüş cari vəziyyətini yeniləyin'**
  String get updateAppointmentStatus;

  /// No description provided for @confirm.
  ///
  /// In az, this message translates to:
  /// **'Təsdiqlə'**
  String get confirm;

  /// No description provided for @status.
  ///
  /// In az, this message translates to:
  /// **'Status'**
  String get status;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['az', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'az':
      return AppLocalizationsAz();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
