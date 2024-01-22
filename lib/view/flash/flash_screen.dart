import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/view/admin/dashboard/admin_dashboard.dart';
import 'package:skin_care_traker/view/app_bottom_menu/app_bottom_menu.dart';
import 'package:skin_care_traker/view/auth/login.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({Key? key}) : super(key: key);

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {

  var user_id;
  getLogin()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      user_id = _pref.getString("user_id");
    });
    Future.delayed(Duration(seconds: 1), () {
      // 5s over, navigate to a new page
      if(user_id != null){
        Get.offAll(AdminDashboard());
        //Get.offAll(AppBottomMenu());
      }else{
        Get.offAll(Login());
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLogin();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: Center(
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }
}
