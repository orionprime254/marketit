//import 'package:campomart/components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lottie/lottie.dart';
import 'package:marketit/auth/auth_services.dart';
import 'package:marketit/components/textfield.dart';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketit/pages/btmnavbar.dart';
import 'package:marketit/pages/forgotpasswordpage.dart';

import '../components/button.dart';
import '../components/textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  void signIn() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CupertinoActivityIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);
      if (context.mounted) Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNavBar()));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  void signInWithGoogle() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CupertinoActivityIndicator(),
            ));
    try {
      final userCredential = await AuthService().signInWithGoogle();
      if (userCredential != null) {

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNavBar()));
        if (context.mounted) Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
     // Navigator.pop(context);
      displayMessage(e.code);
      Navigator.pop(context);

    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Icon(
                  //   Icons.lock,
                  //   size: 100,
                  // ),
                  Lottie.asset('lib/animations/welcome.json'),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                      child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Welcome Back to "
                            "MarketIt",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w700),
                          ))),
                  Container(
                      margin: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                      child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'A Comrade\'s Shopping Choice',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ))),

                  MyTextField(
                      controller: emailTextController,
                      hintText: 'email@gmail.com',
                      obscureText: false),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                      controller: passwordTextController,
                      hintText: 'password',
                      obscureText: true),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ForgotPasswordPage();
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot Password',

                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(
                    onTap: signIn,
                    text: 'Sign In',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        )),
                        Text('Or Continue with'),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: ()=>AuthService().signInWithGoogle(),
                        child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white),
                                color: Colors.grey[200]
                            ),
                            child: Image.asset('lib/imgs/search.png',height: 40,)),
                      ),
                      SizedBox(width: 15.0,),
                      // Container(
                      //     padding: EdgeInsets.all(20),
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(16),
                      //         border: Border.all(color: Colors.white),
                      //         color: Colors.grey[200]
                      //     ),
                      //     child: Image.asset('lib/imgs/facebook.png',height: 40,)),

                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not a Member?',
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          ' Register Now',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
