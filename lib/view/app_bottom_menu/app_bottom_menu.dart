import 'package:flutter/material.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/view/home/home.dart';
import 'package:skin_care_traker/view/profile/profile.dart';


class AppBottomMenu extends StatefulWidget {
  const AppBottomMenu({Key? key}) : super(key: key);

  @override
  State<AppBottomMenu> createState() => _AppBottomMenuState();
}

class _AppBottomMenuState extends State<AppBottomMenu> {
  int _currentIndex = 0;
  List<Widget> _pages = [
    Home(),
    Home(),
    Home(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColor.bg2,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0,2)
            )
          ]
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppColor.bg2,
          selectedItemColor:  AppColor.mainColor,
          iconSize: 35,
          unselectedItemColor: AppColor.bottomMenuUnselect,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'SHOP',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.support_agent),
              label: 'SUPPORT',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'PERSON',
            ),
          ],
        ),
      ),
    );
  }
}
