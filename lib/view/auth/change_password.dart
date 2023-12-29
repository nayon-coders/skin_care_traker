import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/view/auth/login.dart';
import 'package:skin_care_traker/widget/app_button.dart';
import 'package:skin_care_traker/widget/app_input.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _signUpKey = GlobalKey<FormState>();
  final password = TextEditingController();
  final Cpassword = TextEditingController();



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
            child: Form(
              key: _signUpKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Center(child: Image.asset("assets/images/logo.png", height: 120,)),

                  const Text("Set New Password",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30
                    ),
                  ),
                  SizedBox(height: 10,),
                  const Text("Setup new password.",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15
                    ),
                  ),
                  SizedBox(height: 50,),
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
                        color: AppColor.mainColor,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    validator: (v){
                      if(v!.isEmpty){
                        return "Password name is required.";
                      }else if(v!.length > 9){
                        return "Password must be 8 character.";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 20,),
                  AppInput(
                    title: "Confirm Password",
                    hintText: "Confirm",
                    controller: Cpassword,
                    obscureText: _passwordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColor.mainColor,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },



                    ),

                    validator: (v){
                      if(v! != password.text){
                        return "Confirm Password don't match.";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 30,),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: AppButton(
                      isLoading: isLoading,
                      text: "Setup",
                      onClick: ()=>Get.offAll(Login()), 
                    ),
                  ),
                  SizedBox(height: 20,),
                

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = false;
// void _signUp() async{
//   setState(() =>isLoading = true);
//   if(_signUpKey.currentState!.validate()){
//     var res = await AuthController.singUp(fname: fname.text, lname: lname.text, email: email.text, password: password.text, deviceToken: deviceTokenToSendPushNotification);
//     if(res.statusCode == 200){
//       Get.to(AppBottomNavigation());
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text("Registration success."),
//         backgroundColor: Colors.green,
//         duration: Duration(milliseconds: 300),
//       ));
//     }else{
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text("Something went wrong."),
//         backgroundColor: Colors.red,
//         duration: Duration(milliseconds: 300),
//       ));
//     }
//   }
//
//   setState(() =>isLoading = false);
// }



}
