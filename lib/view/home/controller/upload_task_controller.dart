import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_care_traker/app_config.dart';
import 'package:skin_care_traker/model/daily_task_add_model.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/view/app_bottom_menu/app_bottom_menu.dart';
import 'package:skin_care_traker/view/home/image_preview.dart';
import 'package:skin_care_traker/widget/app_snackbar.dart';

class UploadTaskController{

  static User? user;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static String? picture;
  static File? image;

  //date format

  //get start challenges//
  static Future getStartTaskPopUp({required BuildContext context})async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start Challenges'),
          content: SingleChildScrollView(
            child: Text('This is 60 days Challenges. Are you ready to take this Challenges? If yes, then you need to upload your today picture.'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                //if user click yes.... 
                //then choose is open
                Navigator.pop(context);
                chooseImage(context: context);

              },
            ),
          ],
        );
      },
    );
  }

  //choose image from gallery or camera
  static Future chooseImage({required BuildContext context})async{
    showModalBottomSheet(
        shape: RoundedRectangleBorder(		//the rounded corner is created here
          borderRadius: BorderRadius.circular(30.0),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: AppColor.bg2,
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("Choose Image",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.white,),
                  ),
                  title: Text('Camera'),
                  onTap: () {
                    takenImage(ImageSource.camera, context);
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Icon(Icons.photo, color: Colors.white,),
                  ),
                  title: Text('Gallery'),
                  onTap: () {
                    takenImage(ImageSource.gallery, context);
                  },
                ),

              ],
            ),
          );
        });
  }

  //take images
  static Future takenImage(ImageSource source, context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    print("pickedFile taken === ${File(pickedFile!.path)}");

    if (pickedFile != null) {
      //redirect to preview screen
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ImagePreView(image: File(pickedFile.path)!)));
      //once you are get the image now this time to get 60 days from to day
      print("image taken === ${File(pickedFile.path)}");
    }
  }

  //image preview


  //next 60 days
  static List<DateTime> generateDates(DateTime startDate, int numberOfDays) {
    List<DateTime> dateList = [];

    for (int i = 0; i < numberOfDays; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      dateList.add(currentDate);
    }

    return dateList;
  }

  //uploaded into server
  static Future storeData({required BuildContext context, required File file})async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var email = _pref.getString("email");
    getChallenges(); //show the data
    final docRef = FirebaseFirestore.instance.collection('task').doc('$email');

    List<TaskList> task = [];

    //current date
    var currentDate = AppConfig.dateFormat(date: DateTime.now());
    //var currentDate = "2023-12-31";


    var data, existingTaskList;
    final docSnapshot = await docRef.get();

    if(docSnapshot.data() !=null ){
      data = docSnapshot.data() as Map<String, dynamic>; // Convert to a Map
      // Access the 'task' list
      existingTaskList = data['task'] as List<dynamic>;
    }



    List<DateTime> dateList = generateDates(DateTime.now(), 60);

    // Upload image and get download URL
    String imageUrl = await uploadImageToFirebaseStorage(file);



    //we upload data with this list
    for (DateTime date in dateList) {
      //convert the date
      var convertedDate = AppConfig.dateFormat(date: DateTime.parse("${date.toString()}"));
      if(convertedDate == currentDate){
        task.add(TaskList(date: convertedDate, image: imageUrl, status: 'Active', isDone: 'Done'));
      }else{
        task.add(TaskList(date: convertedDate, image: "null", status: 'Pending',  isDone: 'no'));
      }

    }


    // Sample user data with image URL
    DailyTaskAddModel dailyTaskAddModel = DailyTaskAddModel(
      start: 1,
      startDate: '$currentDate',
      task: task
    );

    try {
      if(startData != null && startData!["start"] == 1){
        existingTaskList.asMap().forEach((index, task) {
          if (task['date'] == currentDate) {
            task['status'] = 'Active'; // Example update
            task['image'] = imageUrl; // Example update
            task['date'] = currentDate; // Example update
            task['isDone'] = "Done"; // Example update

            // Update the specific task at its index
            existingTaskList[index] = task;
          }
        });
        await docRef.update({'task': existingTaskList});
        AppSnackBar.appSnackBar(text: "${currentDate} task is done. ", bg: Colors.green, context: context);

        print("add new ------");
      }else{
        await _firestore.collection('task').doc("${email}").set(dailyTaskAddModel.toMap());
        AppSnackBar.appSnackBar(text: "${currentDate} task is done. ", bg: Colors.green, context: context);

        // for(var i in taskData){
        //   if(i["date"] == currentDate && i["status"]=="Pending"){
        //
        //   }
        // }

      }
      //await FirebaseFirestore.instance.collection('task').doc(user?.uid).set(dailyTaskAddModel.toMap());
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AppBottomMenu()), (route) => false);
    } catch (e) {
      print('Error storing user data: $e');
      AppSnackBar.appSnackBar(text: "Something went wrong. Try again.", bg: Colors.red, context: context);
    }

  }


  //get uploaded data
  static Map<String, dynamic>? startData;
  static List<dynamic> taskData = [];
  static Future getChallenges()async{
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
      startData = userData['start'] as Map<String, dynamic>? ?? {};
      taskData = userData['task'] as List<dynamic>? ?? [];

      print('Start Data: $startData');
      print('Task Data: $taskData');
      print('Task Data: $userData');
      return documentSnapshot;
    } else {
      print('Document does not exist ${documentSnapshot}');
      return documentSnapshot;
    }
  }


  //conver image for firebase
  static Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      var storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
      var uploadTask = storageReference.putFile(imageFile);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return '';
    }
  }



}
