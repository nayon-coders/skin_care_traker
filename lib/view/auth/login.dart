import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skin_care_traker/controller/auth_controller.dart';
import 'package:skin_care_traker/routing/routing.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/view/admin/dashboard/admin_dashboard.dart';
import 'package:skin_care_traker/view/app_bottom_menu/app_bottom_menu.dart';
import 'package:skin_care_traker/view/auth/forget_pass.dart';
import 'package:skin_care_traker/view/auth/signup.dart';
import 'package:skin_care_traker/widget/app_button.dart';
import 'package:skin_care_traker/widget/app_input.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final password = TextEditingController();

  late bool _passwordVisible;
  @override
  void initState() {
    _passwordVisible = true;
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

                const Text("Login",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30
                  ),
                ),
                SizedBox(height: 10,),
                const Text("Enter your email & password to login your account.",
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
                SizedBox(height: 20,),
                AppInput(
                  title: "Password",
                  hintText: "Password",
                  controller: password,
                  obscureText: _passwordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColor.bg,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: ()=>Get.to(ForgetPassword()),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: AppColor.black
                      ),
                    ),

                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: AppButton(
                    text: "Login",
                    isLoading: isLoading,
                    onClick: ()=>_login(),
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: ()=>Get.to(SignUp()),
                  child: Padding( 
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "I don't have account. ",
                          style: TextStyle(
                              color: AppColor.black
                          ),
                        ),
                        Text("Signup Now",
                          style: TextStyle(
                              color: AppColor.mainColor,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
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

  void _login() async{
    setState(() => isLoading = true);
    var res = await AuthController.signInWithEmailAndPassword(email: email.text, pass: password.text,);
    if(res){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login Success."),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 3000),
      ));
      Get.offAll(AdminDashboard());
      //Get.offAll(AppBottomMenu());
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email or password is invalid."),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 3000),
      ));
    }
    setState(() => isLoading = false);
  }
}
