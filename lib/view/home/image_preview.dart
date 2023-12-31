import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/view/home/controller/upload_task_controller.dart';
import 'package:skin_care_traker/widget/app_topbar.dart';

class ImagePreView extends StatefulWidget {
  final File image;
  const ImagePreView({Key? key, required this.image}) : super(key: key);

  @override
  State<ImagePreView> createState() => _ImagePreViewState();
}

class _ImagePreViewState extends State<ImagePreView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("image === ${widget.image!.path}");
  }
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: Column(
        children: [
          AppTopBar(),
          SizedBox(
            height: MediaQuery.of(context).size.height-200, width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(widget.image,)
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: EdgeInsets.only(left: 50, right: 50, bottom: 20),
        decoration: BoxDecoration(
          color: AppColor.bg
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: ()=>UploadTaskController.chooseImage(context: context),
              child: Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text("Re-Take"),),
              ),
            ),
            InkWell(
              onTap: ()async{
                setState(() =>isLoading = true);
                await UploadTaskController.storeData(context: context, file: widget.image);
                setState(() =>isLoading = false);
              },
              child: Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColor.mainColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: isLoading ? CircularProgressIndicator(color: Colors.white,) : Text("Upload",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
