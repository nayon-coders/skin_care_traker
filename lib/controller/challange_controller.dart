import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_care_traker/model/daily_task_add_model.dart';
import 'package:skin_care_traker/view/auth/login.dart';
import 'package:skin_care_traker/widget/app_snackbar.dart';

class ChallengeController{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //upload daily image
  static Future<DocumentSnapshot> fetchData() async {
    Map<String, dynamic> data = {};
    String email = FirebaseAuth.instance.currentUser?.email ?? '';

    // Reference to the "users" collection
    CollectionReference users = FirebaseFirestore.instance.collection('task');

    // Reference to the document with the user ID as the document ID
    DocumentReference userDocument = users.doc(email);

    // Get the document snapshot
    DocumentSnapshot documentSnapshot = await userDocument.get();

    if (documentSnapshot.exists) {
      // Explicitly cast to Map<String, dynamic>
      Map<String, dynamic> userData = documentSnapshot.data() as Map<String, dynamic>;

      // Access 'start' and 'task' fields from the userData map
      Map<String, dynamic> startData = userData['start'] as Map<String, dynamic>? ?? {};
      List<dynamic> taskData = userData['task'] as List<dynamic>? ?? [];

      print('Start Data: $startData');
      print('Task Data: $taskData');
      print('Task Data: $userData');
        return documentSnapshot;
      } else {
        print('Document does not exist ${documentSnapshot}');
        return documentSnapshot;
      }
    }
}