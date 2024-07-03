// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// class AuthProviderr with ChangeNotifier{
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User? _user;
//
// User? get user => _user;
//   AuthProvider(){
//     _auth.authStateChanges().listen((user) {
//       _user = user;
//       notifyListeners();
//     });
//   }
//   Future<void> signOut() async{
//     await _auth.signOut();
//     notifyListeners();
//   }
//   Future<void> signUp(String email,String password)async{
//     try{
//       await _auth.createUserWithEmailAndPassword(email: email, password: password);
//     }on FirebaseAuthException catch (e){
//       throw e;
//     }
//   }
//   Future<void> signIn(String email,String password)async{
//     try{
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//     }on FirebaseAuthException catch (e){
//       throw e;
//     }
//   }
//
// }