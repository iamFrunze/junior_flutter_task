import 'package:flutter/cupertino.dart';

class MallLogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: Stack(children: [
          Image(
            image: AssetImage('assets/images/app_background.jpg'),
            fit: BoxFit.cover,
          ),
          /*  Container(
              margin: EdgeInsets.only(left: 24.0, top: 24.0, bottom: 8.0),
              child: Image(image: AssetImage('mall_logo_transparent.png')))*/
        ]),
        fit: BoxFit.cover);
  }
}
