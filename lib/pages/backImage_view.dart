//背景图片
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/flying_ui_kit/config.dart';

GlobalKey<BackImgViewState> backImgViewKey = new GlobalKey<BackImgViewState>();
class BackImgView extends StatefulWidget {
  @override
  BackImgViewState createState() => BackImgViewState();
}
class BackImgViewState extends State<BackImgView> {
  @override
  Widget build(BuildContext context) {
    return backImgFile==null?Positioned.fill(
      child: Image.asset("images/background.png",fit: BoxFit.cover,),
    ):Positioned.fill(
      child: Image.file(backImgFile,fit: BoxFit.cover,),
    );
  }
}