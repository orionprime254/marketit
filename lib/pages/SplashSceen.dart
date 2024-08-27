import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:marketit/ads/openad.dart';
import 'package:marketit/auth/auth.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appOpenAdManager.loadAd();
    Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      appOpenAdManager.showAdIfAvailable();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const AuthPage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(child: Lottie.asset('lib/animations/loading.json')),
    );
  }
}
