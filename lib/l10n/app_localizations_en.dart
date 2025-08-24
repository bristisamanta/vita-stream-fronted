// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'VitaStream';

  @override
  String get pairDevice => 'Pair Device';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get map => 'Map';

  @override
  String get tips => 'Tips';

  @override
  String get safeWaterSources => 'Safe Water Sources';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languageBengali => 'Bengali';

  @override
  String get notificationUnsafeTitle => 'Unsafe Water Quality!';

  @override
  String get notificationUnsafeBody => 'Tap to view details';

  @override
  String get riskBannerTitle => 'Unsafe Water Quality Detected!';

  @override
  String get riskBannerSubtitle => 'Immediate action required ⚠️';

  @override
  String helloName(String name) {
    return 'Hello $name 👋';
  }

  @override
  String get dashboardMotto => 'Trust yourself and keep going.';

  @override
  String get readingPH => 'pH';

  @override
  String get readingTDS => 'TDS';

  @override
  String get readingNitrate => 'Nitrate';

  @override
  String get readingHigh => 'High';

  @override
  String get farmHealthTitle => 'Farm Health Score';

  @override
  String farmHealthHint(int percent) {
    return '$percent% Healthy - Monitor water quality closely';
  }

  @override
  String get featureWaterIntake => 'Water Intake';

  @override
  String get featureReminders => 'Reminders';

  @override
  String get featureDeviceStatus => 'Device Status';

  @override
  String get featureSafeSources => 'Safe Sources';

  @override
  String get featureAlerts => 'Alerts';

  @override
  String get videoComingSoon => '🎥 Tutorial Video Coming Soon';

  @override
  String get blockchainServices => 'Blockchain Services';

  @override
  String get wallet => 'Wallet';

  @override
  String get sendTx => 'Send Tx';

  @override
  String get subsidy => 'Subsidy';

  @override
  String get fetchRiskFailed => 'Failed to fetch risk data';

  @override
  String get bottomPair => 'Pair';

  @override
  String get bottomDashboard => 'Dashboard';

  @override
  String get bottomMap => 'Map';

  @override
  String get bottomTips => 'Tips';

  @override
  String get waterIntakeTitle => 'Water Intake';

  @override
  String get setDailyGoal => 'Set Daily Goal';

  @override
  String get enterGoal => 'Enter goal in ml';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get consumed => 'Consumed';

  @override
  String get hydrationRemindersOn => 'Hydration Reminders: ON';

  @override
  String get hydrationRemindersOff => 'Hydration Reminders: OFF';

  @override
  String get nextReminder => 'Next reminder';

  @override
  String get weeklyTrend => 'Weekly Intake Trend';

  @override
  String get todayLogs => 'Today\'s Logs';

  @override
  String get addWater => 'Add 250 ml';

  @override
  String get remindersTitle => 'Crop Watering Reminders';

  @override
  String get recommendedTimes => 'Recommended Watering Times';

  @override
  String get setCustomTimes => 'Set Custom Watering Times';

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stop';

  @override
  String get select => 'Select';

  @override
  String get saveReminder => 'Save Reminder';

  @override
  String get activeReminders => 'Active Reminders';

  @override
  String get tipsAlerts => 'Tips / Alerts';

  @override
  String get tip1 => 'Water early morning or late evening';

  @override
  String get tip2 => 'Avoid watering during heavy rain';

  @override
  String get tip3 => 'Ensure irrigation lasts at least 2 hours';

  @override
  String get safeWaterSourcesTitle => 'Safe Water Sources';

  @override
  String get searchSourcesHint => 'Search sources...';

  @override
  String get status => 'Status';

  @override
  String get distance => 'Distance';

  @override
  String get river => 'River';

  @override
  String get well => 'Well';

  @override
  String get pond => 'Pond';

  @override
  String get stream => 'Stream';

  @override
  String get statusGood => 'Good';

  @override
  String get statusModerate => 'Moderate';

  @override
  String get statusSafe => 'Safe';

  @override
  String get statusUnsafe => 'Unsafe';

  @override
  String get deviceStatusTitle => 'Device Status';

  @override
  String get connectedDevice => 'Connected Device';

  @override
  String get batteryLevel => 'Battery Level';

  @override
  String get deviceConnection => 'Device Connection';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get connect => 'Connect';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get startSync => 'Start Sync';

  @override
  String get lastUpdate => 'Last Update';

  @override
  String get lastUpdateMessage => 'Device synced 10 minutes ago';

  @override
  String get alerts => 'Alerts';

  @override
  String get unsafeWaterTitle => '⚠️ Unsafe Water Quality Detected!';

  @override
  String get unsafeWaterMessage =>
      'Please check your water filter device or switch to a safe source.';

  @override
  String get lowFilterTitle => 'Low Filter Efficiency';

  @override
  String get lowFilterMessage =>
      'Your filter may need cleaning or replacement soon.';

  @override
  String get resolve => 'Resolve';
}
