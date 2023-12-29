import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/widget/app_input.dart';
import 'package:skin_care_traker/widget/app_network_image.dart';

import '../auth/login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final fullName = TextEditingController();
  final lname = TextEditingController();
  final email = TextEditingController();
  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final confirmNewPass = TextEditingController();

  final List<String> items = [
    'Male',
    'Female',
    'Others',
  ];
  String? selectedValue;


  late bool _passwordVisible;

  // Future<SingleUserInfo>? _getSingleUserInfo;

  bool isLoading = false;
  var userId, profileImage;
  File? profile;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? _user;
  Future<void> _getUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        // User data exists in Firestore
        setState(() {
          _user = user;
        });

        fullName.text = userDoc.get("full_name");
        email.text = userDoc.get("email");
        selectedValue = userDoc.get("gender");
        profileImage = userDoc.get("profile");

        print('User Data: ${userDoc.data()}');
        print('User Data: ${userDoc.get("full_name")}');
      } else {
        // User data not found in Firestore
        print('User Data not found');
      }
    }
  }


  @override
  void initState() {
    _passwordVisible = true;
    _getUserData();
    //getUserInfoAndStore();
    //_getSingleUserInfo = UserController.getSingleUser();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Text("My Profile",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(height: 30,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: profile != null
                            ? Image.file(profile!,
                          height: 100, width: 100,
                        )
                            : profileImage != null
                            ? AppNetworkImage(src: "$profileImage",)
                            :AppNetworkImage(src: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkdPUrvq_PqcJ6xThm45NFBRnGYPElU28gAw&usqp=CAU",)
                    ),
                    Positioned(
                      right: 0, bottom: 0,
                      child:   InkWell(
                        onTap: ()=>_chooseImage(),
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: AppColor.mainColor,
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: Icon(Icons.edit, color: AppColor.white,),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,),
                AppInput(
                  title: "First Name",
                  hintText: "Enter First Name",
                  controller: fullName,
                ),
                SizedBox(height: 20,),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      '${selectedValue != null ? selectedValue : "Select Gender"}',
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
                  title: "Email",
                  hintText: "Enter your email",
                  controller: email,
                  redOnly:  true,
                ),

                SizedBox(height: 30,),
                InkWell(
                  // onTap:()=>_changeInfo(),
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text("Change", style: TextStyle(color: AppColor.white),),),
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Text("Change Password",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(height: 30,),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInput(
                  title: "Old Password",
                  hintText: "Old Password",
                  controller: oldPass,
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
                ),
                SizedBox(height: 20,),
                AppInput(
                  title: "New Password",
                  hintText: "New Password",
                  controller: newPass,
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
                ),
                SizedBox(height: 20,),
                AppInput(
                  title: "Confirm Password",
                  hintText: "Confirm",
                  controller: confirmNewPass,
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
                ),
                SizedBox(height: 30,),
                InkWell(
                  //onTap: ()=>_changePassword(),
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text("Change", style: TextStyle(color: AppColor.white),),),
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Divider(height: 1, color: Colors.grey,),
            SizedBox(height: 20,),
            Row(
              children: [
                InkWell(
                  onTap: ()=>Get.to(Login()),
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Center(child: Text("Logout", style: TextStyle(color: AppColor.white),),),
                  ),
                ),
                SizedBox(width: 30,),
                InkWell(
                  onTap:(){
                    Get.defaultDialog(
                      title: "Delete account",
                      content: Text("Are you sure? Do you want to delete account?"),
                      cancel: TextButton(onPressed: ()=>Get.back(), child: Text("No")),
                      confirm: TextButton(onPressed: (){}, child: Text("Yes")),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Center(child: Text("Delete Account", style: TextStyle(color: AppColor.white),),),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,)
          ],
        ),

      ),

    );
  }


  //change info
  bool isChangeInfo = false;
  // void _changeInfo() async{
  //   setState(() =>isLoading = true);
  //   var res = await UserController.editUserInfo(fname: fName.text, lname: lname.text);
  //   if(res.statusCode == 200){
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Profile Info Update Success."),
  //       backgroundColor: Colors.green,
  //       duration: Duration(milliseconds: 3000),
  //     ));
  //     getUserInfoAndStore();
  //     setState(() {
  //
  //     });
  //   }else{
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("Something went wrong."),
  //       backgroundColor: Colors.red,
  //       duration: Duration(milliseconds: 3000),
  //     ));
  //   }
  //   setState(() =>isLoading = true);
  // }
  // void _deletingAccount() async{
  //   setState(() =>isLoading = true);
  //   var res = await UserController.deleteUser();
  //   if(res.statusCode == 200){
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Your account permanently deleted."),
  //       backgroundColor: Colors.green,
  //       duration: Duration(milliseconds: 3000),
  //     ));
  //     AuthController.logout();
  //     setState(() {
  //     });
  //   }else{
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("Something went wrong."),
  //       backgroundColor: Colors.red,
  //       duration: Duration(milliseconds: 3000),
  //     ));
  //   }
  //   setState(() =>isLoading = true);
  // }

  _chooseImage() {
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
                Text("Choose Image",
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
                  title: new Text('Camera'),
                  onTap: () {
                    _takenImage(ImageSource.camera);
                    Navigator.pop(context);
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
                    _takenImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),

              ],
            ),
          );
        });
  }


  //take image
  Future<void> _takenImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        profile = File(pickedFile.path);
      });
      _uploadProfileImageToServer();
    }
  }

  //upload profile in to server
  void _uploadProfileImageToServer()async{
    setState(() =>isLoading = true);
    try{
      User? user = _auth.currentUser;
      // Upload the new profile image to Firebase Storage
      String imagePath = 'profile_images/${user?.uid}.jpg';
      UploadTask uploadTask = _storage.ref().child(imagePath).putFile(profile!);
      await uploadTask.whenComplete(() => null);

      // Get the download URL of the uploaded image
      String downloadURL = await _storage.ref(imagePath).getDownloadURL();

      // Update the user's profile in Firebase Authentication
      await user?.updateProfile(photoURL: downloadURL);

      // Update the profile image URL in Firestore
      await _firestore.collection('users').doc(user?.uid).update({
        'profile': downloadURL,
      });

      // Refresh the user data
      await _getUserData();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Profile picture is uploaded success."),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 3000),
      ));
    }catch(e){
      print("profile error $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong.. Try again."),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 3000),
      ));
    }

    setState(() =>isLoading = false);
  }

  // void _changePassword() async{
  //   setState(() =>isLoading = true);
  //   print(" ====== ${oldPass.text}");
  //   print(" ====== ${newPass.text}");
  //   print(" ====== ${confirmNewPass.text}");
  //
  //   var res = await UserController.changePassword(oldPass: oldPass.text, newPass: newPass.text, confirmNewPass: confirmNewPass.text);
  //   print(" ====== ${jsonDecode(res.body)}");
  //   if(res.statusCode == 200){
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Password changed success."),
  //       backgroundColor: Colors.green,
  //       duration: Duration(milliseconds: 3000),
  //     ));
  //     AuthController.logout();
  //   }else{
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("${jsonDecode(res.body)["message"]}"),
  //       backgroundColor: Colors.red,
  //       duration: Duration(milliseconds: 3000),
  //     ));
  //   }
  //   setState(() =>isLoading = false);
  // }

}