import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class AppNetworkImage extends StatelessWidget {
  final String src;
  final double height;
  final double weight;
  final  BoxFit boxFit;
  const AppNetworkImage({Key? key, required this.src, this.height = 100, this.weight = 100, this.boxFit =  BoxFit.cover}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: src,
      height: height, width: weight, fit: boxFit,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
