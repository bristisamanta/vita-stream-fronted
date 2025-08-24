import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'VitaStream'**
  String get appName;

  /// No description provided for @pairDevice.
  ///
  /// In en, this message translates to:
  /// **'Pair Device'**
  String get pairDevice;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @safeWaterSources.
  ///
  /// In en, this message translates to:
  /// **'Safe Water Sources'**
  String get safeWaterSources;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @languageBengali.
  ///
  /// In en, this message translates to:
  /// **'Bengali'**
  String get languageBengali;

  /// No description provided for @notificationUnsafeTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsafe Water Quality!'**
  String get notificationUnsafeTitle;

  /// No description provided for @notificationUnsafeBody.
  ///
  /// In en, this message translates to:
  /// **'Tap to view details'**
  String get notificationUnsafeBody;

  /// No description provided for @riskBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsafe Water Quality Detected!'**
  String get riskBannerTitle;

  /// No description provided for @riskBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Immediate action required ⚠️'**
  String get riskBannerSubtitle;

  /// No description provided for @helloName.
  ///
  /// In en, this message translates to:
  /// **'Hello {name} 👋'**
  String helloName(String name);

  /// No description provided for @dashboardMotto.
  ///
  /// In en, this message translates to:
  /// **'Trust yourself and keep going.'**
  String get dashboardMotto;

  /// No description provided for @readingPH.
  ///
  /// In en, this message translates to:
  /// **'pH'**
  String get readingPH;

  /// No description provided for @readingTDS.
  ///
  /// In en, this message translates to:
  /// **'TDS'**
  String get readingTDS;

  /// No description provided for @readingNitrate.
  ///
  /// In en, this message translates to:
  /// **'Nitrate'**
  String get readingNitrate;

  /// No description provided for @readingHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get readingHigh;

  /// No description provided for @farmHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Farm Health Score'**
  String get farmHealthTitle;

  /// No description provided for @farmHealthHint.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Healthy - Monitor water quality closely'**
  String farmHealthHint(int percent);

  /// No description provided for @featureWaterIntake.
  ///
  /// In en, this message translates to:
  /// **'Water Intake'**
  String get featureWaterIntake;

  /// No description provided for @featureReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get featureReminders;

  /// No description provided for @featureDeviceStatus.
  ///
  /// In en, this message translates to:
  /// **'Device Status'**
  String get featureDeviceStatus;

  /// No description provided for @featureSafeSources.
  ///
  /// In en, this message translates to:
  /// **'Safe Sources'**
  String get featureSafeSources;

  /// No description provided for @featureAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get featureAlerts;

  /// No description provided for @videoComingSoon.
  ///
  /// In en, this message translates to:
  /// **'🎥 Tutorial Video Coming Soon'**
  String get videoComingSoon;

  /// No description provided for @blockchainServices.
  ///
  /// In en, this message translates to:
  /// **'Blockchain Services'**
  String get blockchainServices;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @sendTx.
  ///
  /// In en, this message translates to:
  /// **'Send Tx'**
  String get sendTx;

  /// No description provided for @subsidy.
  ///
  /// In en, this message translates to:
  /// **'Subsidy'**
  String get subsidy;

  /// No description provided for @fetchRiskFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch risk data'**
  String get fetchRiskFailed;

  /// No description provided for @bottomPair.
  ///
  /// In en, this message translates to:
  /// **'Pair'**
  String get bottomPair;

  /// No description provided for @bottomDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get bottomDashboard;

  /// No description provided for @bottomMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get bottomMap;

  /// No description provided for @bottomTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get bottomTips;

  /// No description provided for @waterIntakeTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Intake'**
  String get waterIntakeTitle;

  /// No description provided for @setDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Daily Goal'**
  String get setDailyGoal;

  /// No description provided for @enterGoal.
  ///
  /// In en, this message translates to:
  /// **'Enter goal in ml'**
  String get enterGoal;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// No description provided for @consumed.
  ///
  /// In en, this message translates to:
  /// **'Consumed'**
  String get consumed;

  /// No description provided for @hydrationRemindersOn.
  ///
  /// In en, this message translates to:
  /// **'Hydration Reminders: ON'**
  String get hydrationRemindersOn;

  /// No description provided for @hydrationRemindersOff.
  ///
  /// In en, this message translates to:
  /// **'Hydration Reminders: OFF'**
  String get hydrationRemindersOff;

  /// No description provided for @nextReminder.
  ///
  /// In en, this message translates to:
  /// **'Next reminder'**
  String get nextReminder;

  /// No description provided for @weeklyTrend.
  ///
  /// In en, this message translates to:
  /// **'Weekly Intake Trend'**
  String get weeklyTrend;

  /// No description provided for @todayLogs.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Logs'**
  String get todayLogs;

  /// No description provided for @addWater.
  ///
  /// In en, this message translates to:
  /// **'Add 250 ml'**
  String get addWater;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop Watering Reminders'**
  String get remindersTitle;

  /// No description provided for @recommendedTimes.
  ///
  /// In en, this message translates to:
  /// **'Recommended Watering Times'**
  String get recommendedTimes;

  /// No description provided for @setCustomTimes.
  ///
  /// In en, this message translates to:
  /// **'Set Custom Watering Times'**
  String get setCustomTimes;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @saveReminder.
  ///
  /// In en, this message translates to:
  /// **'Save Reminder'**
  String get saveReminder;

  /// No description provided for @activeReminders.
  ///
  /// In en, this message translates to:
  /// **'Active Reminders'**
  String get activeReminders;

  /// No description provided for @tipsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Tips / Alerts'**
  String get tipsAlerts;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'Water early morning or late evening'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'Avoid watering during heavy rain'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In en, this message translates to:
  /// **'Ensure irrigation lasts at least 2 hours'**
  String get tip3;

  /// No description provided for @safeWaterSourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe Water Sources'**
  String get safeWaterSourcesTitle;

  /// No description provided for @searchSourcesHint.
  ///
  /// In en, this message translates to:
  /// **'Search sources...'**
  String get searchSourcesHint;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @river.
  ///
  /// In en, this message translates to:
  /// **'River'**
  String get river;

  /// No description provided for @well.
  ///
  /// In en, this message translates to:
  /// **'Well'**
  String get well;

  /// No description provided for @pond.
  ///
  /// In en, this message translates to:
  /// **'Pond'**
  String get pond;

  /// No description provided for @stream.
  ///
  /// In en, this message translates to:
  /// **'Stream'**
  String get stream;

  /// No description provided for @statusGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get statusGood;

  /// No description provided for @statusModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get statusModerate;

  /// No description provided for @statusSafe.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get statusSafe;

  /// No description provided for @statusUnsafe.
  ///
  /// In en, this message translates to:
  /// **'Unsafe'**
  String get statusUnsafe;

  /// No description provided for @deviceStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Device Status'**
  String get deviceStatusTitle;

  /// No description provided for @connectedDevice.
  ///
  /// In en, this message translates to:
  /// **'Connected Device'**
  String get connectedDevice;

  /// No description provided for @batteryLevel.
  ///
  /// In en, this message translates to:
  /// **'Battery Level'**
  String get batteryLevel;

  /// No description provided for @deviceConnection.
  ///
  /// In en, this message translates to:
  /// **'Device Connection'**
  String get deviceConnection;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @startSync.
  ///
  /// In en, this message translates to:
  /// **'Start Sync'**
  String get startSync;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last Update'**
  String get lastUpdate;

  /// No description provided for @lastUpdateMessage.
  ///
  /// In en, this message translates to:
  /// **'Device synced 10 minutes ago'**
  String get lastUpdateMessage;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @unsafeWaterTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Unsafe Water Quality Detected!'**
  String get unsafeWaterTitle;

  /// No description provided for @unsafeWaterMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your water filter device or switch to a safe source.'**
  String get unsafeWaterMessage;

  /// No description provided for @lowFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Low Filter Efficiency'**
  String get lowFilterTitle;

  /// No description provided for @lowFilterMessage.
  ///
  /// In en, this message translates to:
  /// **'Your filter may need cleaning or replacement soon.'**
  String get lowFilterMessage;

  /// No description provided for @resolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get resolve;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back 👋'**
  String get welcomeBack;

  /// No description provided for @loginContinue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get loginContinue;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @errorPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get errorPhone;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent'**
  String get otpSent;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get invalidOtp;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @getOtp.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get getOtp;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;
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
      <String>['bn', 'en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
