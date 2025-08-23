import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
// add these along with existing imports
import 'blockchain/wallet_manager.dart';
import 'blockchain/tx_submitter.dart';
import 'blockchain/providers/wallet_provider.dart';
import 'blockchain/providers/tx_provider.dart';
import 'blockchain/ui/wallet_screen.dart';
import 'blockchain/ui/tx_screen.dart';
import 'blockchain/ui/tx_history_screen.dart';
import 'blockchain/ui/subsidy_screen.dart';


// 🌍 Localization
import 'l10n/app_localizations.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/onboarding_login_screen.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up.dart';
import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/tips_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/alert_screen.dart';

// Providers
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';

// ✅ Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// ✅ Global notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔔 Initialize local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload == "alert") {
        navigatorKey.currentState?.pushNamed("/alert");
      }
    },
  );
// create blockchain helpers
final walletManager = WalletManager();
final txSubmitter = TxSubmitter(baseUrl: 'https://your-backend.example.com'); // <- change this

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
         // add these two:
    ChangeNotifierProvider(
      create: (_) => WalletProvider(
        manager: walletManager,
        backendBaseUrl: 'https://your-backend.example.com',
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => TxProvider(
        submitter: txSubmitter,
        notifications: flutterLocalNotificationsPlugin,
      ),
    ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: "VitaStream",

          // ✅ Theme
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.teal,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.teal,
          ),

          // 🌍 Localization setup
          locale: localeProvider.locale ?? const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // ✅ Routes
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingLoginScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/tips': (context) => const TipsScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/alert': (context) => const AlertScreen(),
            '/wallet': (context) => const WalletScreen(),
  '/tx': (context) => const TxScreen(),
  '/tx_history': (context) => const TxHistoryScreen(),
  '/subsidy': (context) => const SubsidyScreen(),
          },
        );
      },
    );
  }
}
