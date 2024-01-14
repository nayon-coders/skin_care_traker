import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skin_care_traker/app_config.dart';
import 'package:skin_care_traker/controller/challange_controller.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/view/home/controller/upload_task_controller.dart';
import 'package:skin_care_traker/view/home/view_all.dart';
import 'package:skin_care_traker/widget/app_network_image.dart';
import 'package:skin_care_traker/widget/app_topbar.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentDate = AppConfig.dateFormat(date: DateTime.now());
  //get user profile
  bool isLoading = false;





  Map<String, dynamic>? startData;
  List<dynamic> taskData = [];
  List<dynamic> lastSevDays = [];
  bool isTodayDone = false;
  int totalDays = 1;

  Future getChallenges()async{
    setState(() =>isLoading = true);
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

      for(var i in taskData){
        if(i["date"] == currentDate && i["status"] == "Active"){
          setState(() =>isTodayDone = true);
        }
      }
      countTasksWithDate(taskData, currentDate);

      setState(() {
        lastSevDays = getPreviousTwoList(taskData, currentDate);
      });

      print('Start Data: $startData');
      print('Task Data: $taskData');
      print('Task Data: $userData');
      setState(() =>isLoading = false);

      return documentSnapshot;
    } else {
      print('Document does not exist ${documentSnapshot}');
      setState(() =>isLoading = false);

      return documentSnapshot;
    }

  }

  ////////////////// day count image /////////////
  void countTasksWithDate(List tasks, String targetDate) {
    print("totalDays === ${totalDays}");

    for (var i = 0; i < tasks.length; i++) {
      print("totalDays === ${totalDays}");
      if (tasks[i]['date'] == targetDate) {
        return;
      }else{
        setState((){
          totalDays++;
        });
      }
    }

    print("totalDays === ${totalDays}");

  }
  ////////////////// choose image /////////////

  ////////////////// last 7 days /////////////
  List getPreviousTwoList(List tasks, String targetDate) {
    int targetIndex = tasks.indexWhere((task) => task['date'] == targetDate);
    if (targetIndex >= 7) {
      // Return the sublist of the previous two items
      return tasks.sublist(targetIndex - 7, targetIndex);
    } else {
      // Return the entire list if there are less than two items before the target date
      return tasks.sublist(0, targetIndex + 1);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChallenges();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading? Center(child: CircularProgressIndicator(color: AppColor.mainColor,),) : SingleChildScrollView(
        child: Column(
          children: [
            AppTopBar(),
            SizedBox(height: 20,),
            SizedBox(
              height: MediaQuery.of(context).size.height*.37,
              child: StatusIndicator(taskData: taskData, startData: startData, totalDays: totalDays, lastSevDays: lastSevDays,)
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: ()=>isTodayDone ? null : UploadTaskController.chooseImage(context: context),
              child: Container(
                height: 100,
                width: double.infinity,
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isTodayDone ? Colors.grey : AppColor.mainColor,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.cloud_upload, color: Colors.white, size: 50,),
                    Text("Upload Picture",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 17
                      ),
                    ),
                  ],
                ),
              ),
            ),
          lastSevDays.isNotEmpty ?  Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Last 7 Days Activity",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                            onPressed: ()=>Get.to(ViewAllUploadImages(taskData: taskData,), transition: Transition.downToUp),
                            child: Text("SEE ALL",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.mainColor
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 10, right: 10,),
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: lastSevDays.length,
                      itemBuilder: (_, index){
                        var data = lastSevDays[index];
                        print("data === ${data["upload_image"]}");
                        return Container(
                          margin: EdgeInsets.only(right: 5),
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 1, color: AppColor.mainColor),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                  width: 50, height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(width: 1, color: AppColor.bg2),
                                  ),
                                  child: data["image"] == "null"? Center() : ClipRRect(borderRadius: BorderRadius.circular(100), child: AppNetworkImage(src: "${data["image"]}",))),
                              Positioned(
                                bottom: 0, right: 5,
                                child: Container(
                                  width: 10, height: 10,
                                  decoration: BoxDecoration(
                                    color: data["status"] != "Active" ? Colors.red: Colors.green,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                ),
              ],
            ) : Center()
          ],
        ),
      ),
    );
  }


}


class UserStatus {
  final String status;

  UserStatus({required this.status,});
}




class StatusIndicator extends StatelessWidget {
  List<dynamic> taskData = [];
  List<dynamic> lastSevDays = [];
  int totalDays;
  Map<String, dynamic>? startData;
  StatusIndicator({required this.taskData, required this.startData, required this.lastSevDays, required this.totalDays});

  final List<UserStatus> userStatusList = [
  ];

  var currentDate = AppConfig.dateFormat(date: DateTime.now());



  @override
  Widget build(BuildContext context) {
    int targetIndex = taskData.indexWhere((task) => task['date'] == currentDate);
    print("targetIndex == ${targetIndex}");
    for(var i = 0; i < taskData.length; i++ ){
      if(i <= targetIndex){
        if(taskData[i]["status"] == "Pending"){
          userStatusList.add(UserStatus(status: "Pass"));
        }else if(taskData[i]["status"] == "Active"){
          userStatusList.add(UserStatus(status: "Active"));
        }
      }else{
        userStatusList.add(UserStatus(status: "${taskData[i]["status"]}"));
      }
    }

    return CustomPaint(
      painter: userStatusList.isEmpty ? BuDefStatusIndicatorPainter() : StatusIndicatorPainter(userStatusList),
      child: Container(
        width: MediaQuery.of(context).size.height*.35,
        height: MediaQuery.of(context).size.height*.35,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text:  TextSpan(
                children: [
                  TextSpan(text: "Today: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16
                    )
                  ),
                  TextSpan(text: "${AppConfig.getCurrentDate()}",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 15
                      )
                  )
                ]
              ),
            ),
            SizedBox(height: 10,),

            startData != null && startData!["start"] != 0
             ? Text("${totalDays} Days Completed",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: AppColor.black
              ),
            ) : InkWell(
              onTap: ()=>UploadTaskController.getStartTaskPopUp(context: context),
              child: Container(
                width: 140,
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  color: AppColor.mainColor,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Center(child: Text("Start Now",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 15
                  ),
                ),),
              ),
            ),
            SizedBox(height: 10,),
            Text("60 Days Challange",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColor.black
              ),
            )
          ],
        )
      ),
    );
  }



}
class StatusIndicatorPainter extends CustomPainter {
  final List<UserStatus> userStatusList;

  StatusIndicatorPainter(this.userStatusList);

  @override
  void paint(Canvas canvas, Size size) {
    double totalItems = userStatusList.isEmpty ? 60 : userStatusList.length.toDouble();
    double totalAngle = 360;
    double startAngle = -90;

    for (UserStatus userStatus in userStatusList) {
      Color color = userStatus != null ? getStatusColor(userStatus.status) : Colors.white;
      double sweepAngle = totalAngle / totalItems;
      drawArc(canvas, size, color, startAngle, sweepAngle);
      startAngle += sweepAngle;
    }
  }

  void drawArc(Canvas canvas, Size size, Color color, double startAngle, double sweepAngle) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      radians(startAngle),
      radians(sweepAngle),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  double radians(double degrees) {
    return degrees * (pi / 210);  //
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "active":
        return Color(0xff1ab03d);
      case "pending":
        return Color(0xffffffff);
      case "pass":
        return Color(0xffbd4237);
      default:
        return Color(0xffffffff);
    }

  }
}


class BuDefStatusIndicatorPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    double totalItems = 60;
    double totalAngle = 360;
    double startAngle = -90;

    for (var i = 0; i < 60; i++) {
      Color color = Colors.white;
      double sweepAngle = totalAngle / totalItems;
      drawArc(canvas, size, color, startAngle, sweepAngle);
      startAngle += sweepAngle;
    }
  }

  void drawArc(Canvas canvas, Size size, Color color, double startAngle, double sweepAngle) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      radians(startAngle),
      radians(sweepAngle),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  double radians(double degrees) {
    return degrees * (pi / 210);  //
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "active":
        return Color(0xff1ab03d);
      case "pending":
        return Color(0xffffffff);
      case "pass":
        return Color(0xffbd4237);
      default:
        return Color(0xffffffff);
    }

  }
}



