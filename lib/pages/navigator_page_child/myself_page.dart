//"我的"页面

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:flying_kxz/FlyingUiKit/buttons.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/dialog.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/NetRequest/feedback_post.dart';
import 'package:flying_kxz/NetRequest/power_get.dart';
import 'package:flying_kxz/NetRequest/rank_get.dart';
import 'package:flying_kxz/pages/login_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/about_page.dart';


class MyselfPage extends StatefulWidget {
  @override
  _MyselfPageState createState() => _MyselfPageState();
}

class _MyselfPageState extends State<MyselfPage> with AutomaticKeepAliveClientMixin{

  void getShowPowerInfo()async{
    if(await powerGet(context,token: Global.prefs.getString(Global.prefsStr.token))){
      setState(() {});
    }
  }
  void getRankInfo()async{
    if(await rankGet(username: Global.prefs.getString(Global.prefsStr.username))){
      setState(() {
      });
    }
  }
  void signOut(){
    Global.clearPrefsData();
    toLoginPage(context);
  }
  //确定退出
  Future<bool> willSignOut(context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: FlyTextMain40('你确定要退出登录吗?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => signOut(),
            child: FlyTextMain40('确定',color: colorMain),),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: FlyTextMain40('取消',color: Colors.black38),
          ),
        ],
      ),
    ) ??
        false;
  }
  Widget topIconButton(IconData icon, {VoidCallback onPressed}) => IconButton(
        onPressed: onPressed,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        icon: Icon(
          icon,
          color: Color.fromARGB(255, 150, 150, 150),
          size: fontSizeMini38 * 1.3,
        ),
      );

  Widget previewItem({@required String title,@required String subTitle})=>Container(
    alignment: Alignment.center,
    child: Wrap(
      spacing: 5,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.vertical,
      children: <Widget>[
        FlyTextMain40(title),
        FlyTextTip30(subTitle),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    getShowPowerInfo();
    getRankInfo();
  }


  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          topIconButton(Entypo.logout,onPressed: ()=>willSignOut(context))
        ],
      ),
      body: Container(
        height: ScreenUtil().setHeight(deviceHeight),
        child: Column(
          children: <Widget>[
            //个人资料区域
            Container(
                child: Column(
                  children: <Widget>[
                    FlyMyselfCard(
                        imageResource: 'images/avatar.png',
                        name: Global.prefs.getString(Global.prefsStr.name),
                        id: Global.prefs.getString(Global.prefsStr.username),
                        classs: Global.prefs.getString(Global.prefsStr.iClass),
                        college: Global.prefs.getString(Global.prefsStr.college)),
                    SizedBox(
                      height: spaceCardMarginBigTB,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: previewItem(title: "0.0",subTitle: "校园卡余额 (元)")
                        ),
                        Container(
                          color: Colors.black12.withAlpha(20),
                          height: fontSizeMini38*2,
                          width: 1,
                        ),
                        Expanded(
                          flex: 1,
                          child: previewItem(title: "${Global.prefs.getString(Global.prefsStr.power)??'0.0'}",subTitle: "宿舍电量 (${Global.prefs.getString(Global.prefsStr.power)==null?"loading":"度"})"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: spaceCardMarginBigTB,
                    ),
                  ],
                )),
            //可滚动功能区
            Expanded(
              child: Container(
                color: colorPageBackground,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: spaceCardMarginTB,),
                    FlyRowMyselfItemButton(
                        imageResource: 'images/2.1.png',
                        title: '关于我们',
                        onTap: () => toAboutPage(context)
                    ),
                        Divider(height: 0,),
                        FlyRowMyselfItemButton(
                            imageResource: 'images/2.2.png',
                            title: '反馈与建议',
                            onTap: () async{
                              String text = await FlyInputDialogShow(context,hintText: "感谢您提出宝贵的建议，这对我们非常重要！（完全匿名）\n*｡٩(ˊᗜˋ*)و*｡");
                              if(text!=null){
                                await feedbackPost(context, text: text);
                              }
                            }
                        ),
                    SizedBox(height: fontSizeMini38,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlyTextTip30("矿小助-内测版 0.5.6  （暂无法预览校园卡余额）"),
                          SizedBox(height: fontSizeMini38/2,),
                          FlyTextTip30('内测结束时间：2020年12月31日，"内测会员"勋章可保留至公测',maxLine: 5),
                          SizedBox(height: fontSizeMini38/2,),
                          FlyTextTip30('内测期间的版本更新均在反馈群中进行',maxLine: 5),
                          SizedBox(height: fontSizeMini38/2,),



                        ],
                      ),
                    )

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
