import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/widget/app_network_image.dart';
import 'package:skin_care_traker/widget/app_topbar.dart';

class ViewAllUploadImages extends StatefulWidget {
  const ViewAllUploadImages({Key? key}) : super(key: key);

  @override
  State<ViewAllUploadImages> createState() => _ViewAllUploadImagesState();
}

class _ViewAllUploadImagesState extends State<ViewAllUploadImages> {
  bool isOpenView = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: Column(
        children: [
          AppTopBar(),
          isOpenView
              ? Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const AppNetworkImage( boxFit: BoxFit.cover, height: double.infinity, weight: double.infinity, src: "https://i.redd.it/lfpgqc2zcu371.jpg",),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        isOpenView = false;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(100)
                      ),
                      child: Center(child: Text("Close", style: TextStyle(fontSize: 12, color: Colors.white),),),
                    ),
                  ),
                )
              ],
            ),
          )
              : Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
              child: GridView.builder(
                //physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: 90,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      setState(() {
                        isOpenView = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height:50, width: 50,
                              child: AppNetworkImage(src: "https://i.redd.it/lfpgqc2zcu371.jpg")),
                         SizedBox(height: 10,),
                          Text("Dec 12, 2023"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      )
    );
  }
}
