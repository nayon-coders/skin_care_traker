


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController{

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //signing with email
  static Future<bool> signInWithEmailAndPassword({required String email, required String pass}) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      User? user = userCredential.user;
      _pref.setString("user_id", user!.uid.toString());
      _pref.setString("email", user!.email.toString());
      print('User signed in: ${user?.hashCode}');
      return true;
    } on FirebaseAuthException catch (e) {
      print('Error during email/password sign in: $e');
      return false;

      // Handle different Firebase Auth exceptions (e.g., invalid email, wrong password)
    }
  }




  //signup
  static Future<bool> signUp({required BuildContext context, required String email, required String pass,required String fullName,  required String gender}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: pass.trim(),
      );

      User? user = userCredential.user;
      // Update user profile in Firestore without a profile image
      await _firestore.collection('users').doc(user?.uid).set({
        'full_name': fullName.trim(),
        'email': user!.email,
        "profile" : null,
        "gender" : gender,
        "status" : "1"
        // Add other profile information as needed
      });

      print('User signed up: ${user.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      print('Error during signup: $e');
      if(e.code == 'email-already-in-use'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("The email address is already in use by another account."),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 3000),
        ));
      }
      return false;
      // Handle different Firebase Auth exceptions
    }
  }

}