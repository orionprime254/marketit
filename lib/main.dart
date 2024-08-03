

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marketit/auth/auth.dart';
import 'package:marketit/components/item_provider.dart';
import 'package:marketit/components/theme_provider.dart';
import 'package:marketit/firebase_options.dart';
import 'package:marketit/theme/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=> ItemProvider(),
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
        themeMode: ThemeMode.system,
        theme: Provider.of<ThemeProvider>(context).themeData

      //darkTheme: darkMode,
    ),);
  }
}
