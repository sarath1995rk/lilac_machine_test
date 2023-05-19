import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lilac_machine_test/app_config/theme_provider.dart';
import 'package:lilac_machine_test/features/auth/screen/phone_auth_screen.dart';
import 'package:lilac_machine_test/features/auth/view_model/auth_view_model.dart';
import 'package:lilac_machine_test/features/home/screen/home_screen.dart';
import 'package:lilac_machine_test/features/home/view_model/home_view_model.dart';
import 'package:lilac_machine_test/features/splash/screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'app_config/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  runApp(
    ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp(
        title: 'Lilac Sample',
        themeMode: themeChanger.getTheme,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.orange,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: const SplashScreen(),
        routes: {
          kSplashScreen: (context) => const SplashScreen(),
          kHomeScreen: (context) => const HomeScreen(),
          kPhoneAuthScreen: (context) => const PhoneAuthScreen(),
        },
      ),
    );
  }
}
