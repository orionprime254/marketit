//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../auth/auth_services.dart';
import '../components/button.dart';
import '../components/textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  void signUp() async {
    showDialog(
        context: context,
        builder: (context) => Center(
          child: CupertinoActivityIndicator(),
        ));
    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context);
      displayMessage("Passwords don't match!");
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'username': emailTextController.text.split('@')[0],

      });
      if (this.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message),
        ));
  }
  Future<void> createUserDocument (UserCredential? userCredential)async{
    if (userCredential !=null && userCredential.user != null){
      await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set(
          {'email':userCredential.user!.email,
            // 'upload_items':_items
          });
    }
  }
  late Stream<QuerySnapshot> _stream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stream = FirebaseFirestore.instance.collection('upload_items').snapshots();
  }
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
                  // Icon(
                  //   Icons.lock,
                  //   size: 100,
                  // ),
                  //Image.asset('lib/imgs/open-enrollment.png'),
                  Lottie.asset('lib/imgs/welcome.json'),
                  SizedBox(
                    height: 50,
                  ),
                  Text("Let's Create An Account For You!",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25),),
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
                  MyTextField(
                      controller: confirmPasswordTextController,
                      hintText: ' confirm password',
                      obscureText: true),
                  SizedBox(
                    height: 50,
                  ),

                  MyButton(
                    onTap: signUp,
                    text: 'Sign Up',
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
                        SizedBox(
                          height: 50,
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
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
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already a Member?',
                         ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          ' Sign In ',
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