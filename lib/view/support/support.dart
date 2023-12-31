import 'package:get/get.dart';
import 'package:skin_care_traker/utilitys/app_color.dart';
import 'package:skin_care_traker/view/app_bottom_menu/app_bottom_menu.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  late WebViewController controller;
  final String initialUrl = 'https://www.example.com';



  void initState() {
    super.initState();
    // Enable virtual display.
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://agerestore.us/pages/contact/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://agerestore.us/pages/contact'));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.bg,
        title: Text('Support',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AppBottomMenu(pageIndex: 0,))),
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
      ),
      body: WebViewWidget(controller: controller),

    );
  }
}
