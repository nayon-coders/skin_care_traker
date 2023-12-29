import 'dart:math';

import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skin_care_traker/app_config.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
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
  final List<Map<String, dynamic>> statusList = [
    {
      "user_id" : "20",
      "status" : "active",
      "day" : "2023-12-12",
      "upload_image" : "https://w7.pngwing.com/pngs/896/800/png-transparent-woman-s-face-face-woman-face-cosmetics-people-eye-thumbnail.png"
    },
    {
      "user_id" : "20",
      "status" : "active",
      "day" : "2023-12-13",
      "upload_image" : "https://w7.pngwing.com/pngs/896/800/png-transparent-woman-s-face-face-woman-face-cosmetics-people-eye-thumbnail.png"
    },
    {
      "user_id" : "20",
      "status" : "deactivate",
      "day" : "2023-12-14",
      "upload_image" : null
    },
    {
      "user_id" : "20",
      "status" : "active",
      "day" : "2023-12-15",
      "upload_image" : "https://w7.pngwing.com/pngs/896/800/png-transparent-woman-s-face-face-woman-face-cosmetics-people-eye-thumbnail.png"

    },
    {
      "user_id" : "20",
      "status" : "deactivate",
      "day" : "2023-12-16",
      "upload_image" : null
    },
    {
      "user_id" : "20",
      "status" : "deactivate",
      "day" : "2023-12-16",
    "upload_image" : null

    },
    {
      "user_id" : "20",
      "status" : "active",
      "day" : "2023-12-15",
      "upload_image" : "https://w7.pngwing.com/pngs/896/800/png-transparent-woman-s-face-face-woman-face-cosmetics-people-eye-thumbnail.png"

    },

  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppTopBar(),
            SizedBox(height: 20,),
            SizedBox(
              height: 400,
              child: StatusIndicator()
            ),
            Container(
              height: 100,
              width: double.infinity,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColor.mainColor,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
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
                        onPressed: ()=>Get.to(ViewAllUploadImages(), transition: Transition.downToUp),
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
              padding: EdgeInsets.only(left: 10, right: 10),
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: statusList.length,
                  itemBuilder: (_, index){
                    var data = statusList[index];
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
                              child: data["upload_image"] == null? Center() : ClipRRect(borderRadius: BorderRadius.circular(100), child: AppNetworkImage(src: "${data["upload_image"]}",))),
                          Positioned(
                            bottom: 0, right: 5,
                            child: Container(
                              width: 10, height: 10,
                              decoration: BoxDecoration(
                                color: data["status"] != "active" ? Colors.red: Colors.green,
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
        ),
      ),

    );
  }


}


class UserStatus {
  final String userId;
  final String status;
  final String day;

  UserStatus({required this.userId, required this.status, required this.day});
}




class StatusIndicator extends StatelessWidget {
  final List<UserStatus> userStatusList = [
    UserStatus(userId: "20", status: "active", day: "2023-12-12"),
    UserStatus(userId: "20", status: "active", day: "2023-12-13"),
    UserStatus(userId: "20", status: "deactivate", day: "2023-12-14"),
    UserStatus(userId: "20", status: "deactivate", day: "2023-12-14"),
    UserStatus(userId: "20", status: "active", day: "2023-12-15"),
    UserStatus(userId: "20", status: "active", day: "2023-12-15"),
    UserStatus(userId: "20", status: "active", day: "2023-12-15"),
    UserStatus(userId: "20", status: "active", day: "2023-12-15"),
    UserStatus(userId: "20", status: "active", day: "2023-12-15"),
    UserStatus(userId: "20", status: "active", day: "2023-12-15"),
    UserStatus(userId: "20", status: "active", day: "2023-12-15"),
    UserStatus(userId: "20", status: "active", day: "2023-12-15"),
    UserStatus(userId: "20", status: "active", day: "2023-12-15"),
    UserStatus(userId: "20", status: "deactivate", day: "2023-12-16"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-16"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-18"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-19"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-19"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-19"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-19"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-19"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-19"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-19"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-19"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-19"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-19"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-19"),
    UserStatus(userId: "20", status: "pending", day: "2023-12-19"),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StatusIndicatorPainter(userStatusList),
      child: Container(
        width: 300,
        height: 300,
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
            // Text("14 Days Completed",
            //   style: TextStyle(
            //     fontSize: 25,
            //     fontWeight: FontWeight.w800,
            //     color: AppColor.black
            //   ),
            // ),
            InkWell(
              onTap: ()=>_chooseImage(),
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

  ////////////////// choose image /////////////
  _chooseImage() {}
 ////////////////// choose image /////////////

}
class StatusIndicatorPainter extends CustomPainter {
  final List<UserStatus> userStatusList;

  StatusIndicatorPainter(this.userStatusList);

  @override
  void paint(Canvas canvas, Size size) {
    double totalItems = userStatusList.length.toDouble();
    double totalAngle = 360;
    double startAngle = -90;

    for (UserStatus userStatus in userStatusList) {
      Color color = getStatusColor(userStatus.status);
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
      case "deactivate":
        return Color(0xffbd4237);
      default:
        return Color(0xffffffff);
    }
  }
}



