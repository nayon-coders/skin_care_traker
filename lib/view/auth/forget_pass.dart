import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:otp/otp.dart';
import 'package:skin_care_traker/routing/routing.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/view/auth/otp.dart';
import 'package:skin_care_traker/view/auth/signup.dart';
import 'package:skin_care_traker/widget/app_button.dart';
import 'package:skin_care_traker/widget/app_input.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final email = TextEditingController();

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor.bg,
          body: SingleChildScrollView(
            padding: EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [

                Center(child: Image.asset("assets/images/logo.png", height: 150,)),

                const Text("Forgot Password",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30
                  ),
                ),
                SizedBox(height: 10,),
                const Text("Enter your email to recovery password.",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15
                  ),
                ),
                SizedBox(height: 50,),
                AppInput(
                  title: "Email",
                  hintText: "Enter your email",
                  controller: email,
                ),
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: AppButton(
                    text: "Submit",
                    isLoading: isLoading,
                    onClick: ()=>Get.to(OTPVerify()),
                  ),
                ),

                SizedBox(height: 20,),
                // Center(
                //   child: Text("Social Signin",
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.w500
                //     ),
                //   ),
                // ),
                // SizedBox(height: 15,),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       child:Image.asset("assets/images/google.png", height: 40, width: 40,)
                //     ),
                //     SizedBox(width: 20,),
                //     Container(
                //         child:Image.asset("assets/images/apple.png", height: 40, width: 40,)
                //     )
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = false;
// void _login() async{
//   setState(() => isLoading = true);
//   var res = await AuthController.login(email: email.text, password: password.text, device_token: deviceTokenToSendPushNotification);
//   if(res.statusCode == 200){
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text("Login Success."),
//       backgroundColor: Colors.green,
//       duration: Duration(milliseconds: 3000),
//     ));
//     Get.offAll(AppBottomNavigation());
//   }else{
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text("${jsonDecode(res.body)["message"]}"),
//       backgroundColor: Colors.red,
//       duration: Duration(milliseconds: 3000),
//     ));
//   }
//   setState(() => isLoading = false);
// }
}
