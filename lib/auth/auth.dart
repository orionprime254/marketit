import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/verifyemail.dart';
import 'authprovider.dart';
import 'login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/btmnavbar.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          User? user = snapshot.data;
          if (user != null && user.emailVerified) {
            return BottomNavBar();
          } else {
            return const VerifyScreen();
          }
        } else {
          return const LoginOrRegister();
        }
      },
    );
  }
}
