import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/view/app_bottom_menu/app_bottom_menu.dart';

class AppTopBar extends StatefulWidget {
  const AppTopBar({
    super.key,
  });

  @override
  State<AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends State<AppTopBar> {
  //get user profile 
  bool isLoading = false;
  var userId, profileImage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
        profileImage = userDoc.get("profile");
      } else {
        // User data not found in Firestore
        print('User Data not found');
      }
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData(); 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColor.bg,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0,-3)
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AppBottomMenu(pageIndex: 3,))),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: AppColor.mainColor,
                  borderRadius: BorderRadius.circular(100)
              ),
              child: Center( 
                child: profileImage != null  
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                    child: Image.network(profileImage, height: 40, width: 40,)) 
                    : Icon(Icons.person, color: Colors.white, size: 30,),
              ),
            ),
          ),
          Container(
            width: 180,
            height: 70,
            child:  Image.asset("assets/images/logo.png", fit: BoxFit.cover,),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: AppColor.bg,
                borderRadius: BorderRadius.circular(100)
            ),
           // child: Center( child: Icon(Icons.check, color: AppColor.mainColor,),),
          ),

        ],
      ),
    );
  }
}
