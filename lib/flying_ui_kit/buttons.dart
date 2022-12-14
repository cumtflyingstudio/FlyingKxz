//各种按钮
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/flying_ui_kit/Text/text.dart';
import 'package:flying_kxz/flying_ui_kit/Theme/theme.dart';
import 'package:provider/provider.dart';

import 'config.dart';
class FlyTextButton extends StatefulWidget {
  final String title;
  final GestureTapCallback onTap;
  final Color color;
  final int maxLine;
  const FlyTextButton(this.title,{Key key, this.onTap, this.color,this.maxLine}) : super(key: key);
  @override
  _FlyTextButtonState createState() => _FlyTextButtonState();
}

class _FlyTextButtonState extends State<FlyTextButton> {
  ThemeProvider themeProvider;
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return InkWell(
      child: FlyText.main40(widget.title,color: widget.color??themeProvider.colorMain,fontWeight: FontWeight.bold,maxLine: widget.maxLine,),
      onTap: widget.onTap,
    );
  }
}

Widget FlyTitleIconButton(String title,String imageResource)=>Column(
  children: <Widget>[
    Material(
      borderRadius: BorderRadius.circular(borderRadiusValue),
      color: colorIconBackground,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        onTap: (){},
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadiusValue)
          ),
          width: ScreenUtil().setWidth(deviceWidth/5.5),
          padding: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(30), 0, ScreenUtil().setHeight(30)),
          child: Column(
            children: <Widget>[
              Center(
                child: Image.asset(imageResource,width: ScreenUtil().setWidth(80),),

              ),
              SizedBox(height: spaceCardMarginBigTB/2,),
              FlyText.main35(title,color: colorMainText,letterSpacing: 1)
            ],
          ),
        ),
      ),
    ),

  ],
);


Widget FlyRecFlatButton(String title,{double width=100,GestureTapCallback onTap})=>Material(
  color: colorMain,
  borderRadius: BorderRadius.circular(10),
  child: InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(0, fontSizeMini38*0.8, 0, fontSizeMini38*0.8),
      width: width,
      child: FlyText.title45(title,letterSpacing: 2,color: Colors.white),
    ),
  ),
);

Widget FlyRecFlatSecondButton(String title,{double width=100,GestureTapCallback onTap})=>Material(
  color: colorSecond,
  borderRadius: BorderRadius.circular(10),
  child: InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(0, fontSizeMini38*0.8, 0, fontSizeMini38*0.8),
      width: width,
      child: FlyText.title45(title,letterSpacing: 2,color: colorMain),
    ),
  ),
);


Widget FlyPreviewCardButton(
    {@required String title,
      @required String content,
      @required String subContent,
      Color color = Colors.green,
      GestureTapCallback onTap}) =>
    Material(
      color: color.withAlpha(10),
      borderRadius: BorderRadius.circular(borderRadiusValue),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(spaceCardPaddingTB),
          width: ScreenUtil().setWidth(deviceWidth / 2.3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FlyText.main35(title, color: Colors.black38),
              SizedBox(
                height: fontSizeMini38 / 6,
              ),
              Text(
                content,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(50),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: fontSizeMini38 / 6,
              ),
              FlyText.mini30(subContent, color: color.withAlpha(150)),
            ],
          ),
        ),
      ),
    );

//小按钮
Widget FlyGreyFlatButton(String text, {VoidCallback onPressed,double fontSize}) => FlatButton(
  onPressed: onPressed,
  highlightColor: Colors.transparent, //点击后的颜色为透明
  splashColor: Colors.transparent, //点击波纹的颜色为透明
  child: FlyText.mainTip35(text),
);


Widget FlyFloatButton(String heroTag,{@required IconData iconData,@required VoidCallback onPressed,bool mini = false}){
  return FloatingActionButton(
    heroTag: heroTag,
    mini: mini,
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(fontSizeMini38),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white.withAlpha(240),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withAlpha(20),
                blurRadius: 3,
              )
            ]
        ),
        child: Icon(iconData,color: colorMain.withAlpha(200),),
      ),
    ),
  );
}