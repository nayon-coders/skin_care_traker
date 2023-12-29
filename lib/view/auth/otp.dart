import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skin_care_traker/routing/routing.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/view/auth/change_password.dart';
import 'package:skin_care_traker/view/auth/signup.dart';
import 'package:skin_care_traker/widget/app_button.dart';
import 'package:skin_care_traker/widget/app_input.dart';

class OTPVerify extends StatefulWidget {
  const OTPVerify({Key? key}) : super(key: key);

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
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

                const Text("OTP Verify",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30
                  ),
                ),
                SizedBox(height: 10,),
                const Text("We send 4 digit pin code to you email.",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15
                  ),
                ),
                SizedBox(height: 50,),
                OtpTextField(
                  numberOfFields: 4,
                  filled: true,
                  fieldWidth: 50,
                  margin: EdgeInsets.only(right: 20),
                  fillColor: Colors.white,
                  borderColor: AppColor.bg2,
                  enabledBorderColor: AppColor.bg2,
                  focusedBorderColor: AppColor.mainColor,
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode){
                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text("Verification Code"),
                            content: Text('Code entered is $verificationCode'),
                          );
                        }
                    );
                  }, // end onSubmit
                ),
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: AppButton(
                    text: "Verify",
                    isLoading: isLoading,
                    onClick: ()=>Get.to(ChangePassword()),
                  ),
                ),

                SizedBox(height: 20,),
                Center(
                  child: TextButton(
                    onPressed: (){},
                    child: Text("Resend Code"),
                  ),
                )
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
