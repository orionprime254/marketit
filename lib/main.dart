import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marketit/auth/auth.dart';
import 'package:marketit/auth/firebase_api.dart';
import 'package:marketit/components/item_provider.dart';
import 'package:marketit/components/theme_provider.dart';
import 'package:marketit/firebase_options.dart';
import 'package:marketit/pages/SplashSceen.dart';
import 'package:marketit/pages/notificationspage.dart';
import 'package:marketit/pages/onboarding_screen.dart';
import 'package:marketit/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isOnboardingComplete = prefs.getBool('onboardingComplete');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(MyApp(isOnboardingComplete: isOnboardingComplete));
}

class MyApp extends StatelessWidget {
  final bool? isOnboardingComplete;

  const MyApp({Key? key, this.isOnboardingComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ItemProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: isOnboardingComplete == true ? SplashScreen() : OnBoardingScreen(),
            themeMode: ThemeMode.system,
            theme: themeProvider.themeData,
            navigatorKey: navigatorKey,
            routes: {
              '/notification_screen':(context)=> NotificationPage()
            },
          );
        },
      ),
    );
  }
}
