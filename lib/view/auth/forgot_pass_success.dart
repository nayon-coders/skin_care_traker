import 'package:flutter/material.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/view/auth/login.dart';
import 'package:skin_care_traker/widget/app_button.dart';


class ForgotPasswordSuccess extends StatefulWidget {
  final String email;
  const ForgotPasswordSuccess({Key? key, required this.email}) : super(key: key);

  @override
  State<ForgotPasswordSuccess> createState() => _ForgotPasswordSuccessState();
}

class _ForgotPasswordSuccessState extends State<ForgotPasswordSuccess> {
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
                const Text("We send a password rest link to your mail. Please check you email.",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15
                  ),
                ),
                SizedBox(height: 20,),
                 Text("Email: ${widget.email}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18
                  ),
                ),

                SizedBox(height: 50,),
                Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: AppButton(
                    text: "Login",
                    isLoading: false,
                    onClick: ()=>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false)
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
}
