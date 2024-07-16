import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marketit/auth/auth.dart';
import 'package:marketit/firebase_options.dart';
import 'package:marketit/pages/btmnavbar.dart';
import 'package:marketit/theme/theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      themeMode: ThemeMode.system,
      theme: lightMode,
        darkTheme: darkMode,

    );
  }
}
