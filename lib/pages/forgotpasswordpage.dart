import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketit/components/textfield.dart';
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailcontroller = TextEditingController();
  @override
  void dispose() {
    _emailcontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  Future passwordReset()async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailcontroller.text.trim());
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text('Password Reset Link Sent!Check Email'),
        );
      });
    }on FirebaseAuthException catch (e){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 20),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text('Reset Password',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25),)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 20),
            child: Align(alignment: Alignment.topLeft,
                child: Text('Enter Your Email And We Will Send You A Reset Link',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)),
          ),

          SizedBox(height: 14,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(controller: _emailcontroller, hintText: '', obscureText: false),
          ),
          SizedBox(height: 14,),
          MaterialButton(onPressed: passwordReset,
          child: Text('Reset Password'),color: Colors.orange,)
        ],
      ),
    );
  }
}
