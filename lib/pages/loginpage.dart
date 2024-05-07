//import 'package:campomart/components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marketit/components/textfield.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    showDialog(context: context, builder: (context)=> Center(child: CupertinoActivityIndicator(),));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);
      if(context.mounted)Navigator.pop(context);
    }on FirebaseAuthException catch (e){
      Navigator.pop(context);
      displayMessage (e.code);}
  }
  void displayMessage(String message){
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: Text(message),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text("Welcome Back!"),
                  SizedBox(
                    height: 50,
                  ),
                  MyTextField(
                      controller: emailTextController,
                      hintText: 'email@gmail.com',
                  
                      obscureText: false),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                      controller: passwordTextController,
                      hintText: 'password',
                      obscureText: true),
                  SizedBox(
                    height: 10,
                  ),
                  MyButton(
                   onTap: signIn,
                    text: 'Sign In',
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a Member?',style: TextStyle(color: Colors.white),),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
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
