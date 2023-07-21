import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junior_test/tools/MyColors.dart';
import 'package:junior_test/tools/Tools.dart';

class CustomNetworkImageLoader extends StatelessWidget {
  String url = "";
  Widget placeHolder;
  bool isColorFiltered = true;

  CustomNetworkImageLoader(this.url, this.placeHolder, this.isColorFiltered,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.6),
        // Настройте прозрачность и цвет затемнения
        BlendMode.darken,
      ),
      child: Image.network(
        Tools.getImagePath(url),
        colorBlendMode: BlendMode.darken,
        fit: BoxFit.cover,
        loadingBuilder:
            (context, Widget child, ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            color: MyColors.grey,
            child: placeHolder,
          );
        },
        errorBuilder: (context, _, __) => Container(
          color: MyColors.grey,
          child: placeHolder,
        ),
      ),
    );
  }
}
