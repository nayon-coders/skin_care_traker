import 'package:flutter/material.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
  });

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
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: AppColor.mainColor,
                borderRadius: BorderRadius.circular(100)
            ),
            child: Center(child: Icon(Icons.person, color: Colors.white, size: 30,),),
          ),
          Container(
            width: 180,
            height: 70,
            child: Image.asset("assets/images/logo.png", fit: BoxFit.cover,),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: AppColor.bg,
                borderRadius: BorderRadius.circular(100)
            ),
            child: Center(child: Icon(Icons.check, color: AppColor.mainColor,),),
          ),

        ],
      ),
    );
  }
}
