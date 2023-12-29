import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/view/app_bottom_menu/app_bottom_menu.dart';
import 'package:skin_care_traker/view/auth/login.dart';
import 'package:skin_care_traker/widget/app_button.dart';
import 'package:skin_care_traker/widget/app_input.dart';

import '../../controller/auth_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _signUpKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final lname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final Cpassword = TextEditingController();

  final List<String> items = [
    'Male',
    'Female',
    'Others',
  ];
  String? selectedValue;



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

                  const Text("Create account.",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30
                    ),
                  ),
                  SizedBox(height: 10,),
                  const Text("Create a new account.",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15
                    ),
                  ),
                  SizedBox(height: 50,),
                  AppInput(
                    title: "Full Name",
                    hintText: "Enter your full name",
                    controller: fullName,
                    validator: (v){
                      if(v!.isEmpty){
                        return "Full name is required.";
                      }else{
                        return null;
                      }
                    },
                  ),

                  SizedBox(height: 20,),
                  AppInput(
                    title: "Email",
                    hintText: "Enter your email",
                    controller: email,
                    validator: (v){
                      if(v!.isEmpty){
                        return "Email name is required.";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 20,),
                  Text("Select Gender",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: 10,),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select Gender',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: items
                          .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        )
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                    ),
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
                      text: "Signup",
                      onClick: ()=>_signUp(),
                    ),
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: ()=>Get.to(Login()),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "I have an account. ",
                            style: TextStyle(
                                color: AppColor.black
                            ),
                          ),
                          Text("Login",
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

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = false;
  void _signUp() async{
    setState(() =>isLoading = true);
    if(_signUpKey.currentState!.validate()){
      var res = await AuthController.signUp(context: context, fullName: fullName.text, email: email.text, pass: password.text, gender: selectedValue!);
      if(res){
        Get.to(AppBottomMenu());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registration success."),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 300),
        ));
      }
    }

    setState(() =>isLoading = false);
  }



}
