import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/widget/app_network_image.dart';
import 'package:skin_care_traker/widget/app_topbar.dart';

class ViewAllUploadImages extends StatefulWidget {
  final List<dynamic> taskData;

  const ViewAllUploadImages({Key? key, required this.taskData}) : super(key: key);

  @override
  State<ViewAllUploadImages> createState() => _ViewAllUploadImagesState();
}

class _ViewAllUploadImagesState extends State<ViewAllUploadImages> {
  bool isOpenView = false;

  String existingImage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        backgroundColor: AppColor.bg,
        title: Text("Challenges",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black
          ),
        ),
        leading: IconButton(
          onPressed: (){
            if(isOpenView){
              setState(() {
                isOpenView = false;
              });
            }else{
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
      ),
      body: isOpenView
          ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:  AppNetworkImage( src: existingImage!, boxFit: BoxFit.cover, height: double.infinity, weight: double.infinity, ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        isOpenView = false;
                        existingImage = "";
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
          : Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20, right: 20, bottom: 10),
            child: GridView.builder(
              //physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: widget.taskData.length,
              itemBuilder: (context, index) {
                var data = widget.taskData[index];
                return InkWell(
                  onTap: (){
                    if(data["image"] != "null"){
                      setState(() {
                        isOpenView = true;
                        existingImage = data["image"];
                      });
                    }

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
                            child: data["image"] != "null" ? AppNetworkImage(src: "${data["image"]}") : Container(color: Colors.grey,)),
                        SizedBox(height: 10,),
                        Text("${data["date"]}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }
}
