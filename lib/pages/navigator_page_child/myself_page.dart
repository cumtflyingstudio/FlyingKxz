//"ๆ็"้กต้ข
import 'dart:io';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:flying_kxz/cumt_spider/cumt.dart';
import 'package:flying_kxz/flying_ui_kit/Text/text.dart';
import 'package:flying_kxz/flying_ui_kit/Theme/theme.dart';
import 'package:flying_kxz/flying_ui_kit/config.dart';
import 'package:flying_kxz/flying_ui_kit/container.dart';
import 'package:flying_kxz/flying_ui_kit/dialog.dart';
import 'package:flying_kxz/flying_ui_kit/loading.dart';
import 'package:flying_kxz/flying_ui_kit/toast.dart';
import 'package:flying_kxz/flying_ui_kit/webview.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/net_request/feedback_post.dart';
import 'package:flying_kxz/pages/app_upgrade.dart';
import 'package:flying_kxz/pages/login_page.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/balance/components/preview.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/balance/utils/provider.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/invite_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/power/components/preview.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/power/utils/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';
import '../../flying_ui_kit/toast.dart';
import 'myself_page_child/about_page.dart';
import 'myself_page_child/cumtLogin_view.dart';

class MyselfPage extends StatefulWidget {
  @override
  _MyselfPageState createState() => _MyselfPageState();
}

class _MyselfPageState extends State<MyselfPage>
    with AutomaticKeepAliveClientMixin {
  ThemeProvider themeProvider;
  Cumt cumt;

  @override
  void initState() {
    super.initState();
    _initInstance();
    _initBalanceAndPowerProvider();
    sendInfo('ๆ็', 'ๅๅงๅๆ็้กต้ข');
  }

  void _initInstance(){
    cumt = Cumt.getInstance();
  }

  void _signOut() async {
    sendInfo('้ๅบ็ปๅฝ', '้ๅบไบ็ปๅฝ');
    await Global.clearPrefsData();
    backImgFile = null;
    await cumt.clearCookie();
    cumt.init();
    toLoginPage(context);
  }

  Future<bool> _initBalanceAndPowerProvider()async{
    bool ok = false;
    await Future.wait([cumt.login(Prefs.username??"", Prefs.password??"")]).then((value)async{
      ok = await Provider.of<BalanceProvider>(context,listen: false).getBalance();
    }).then((value)async{
      ok = await Provider.of<PowerProvider>(context,listen: false).getPreview();
    });
    return ok;
  }


  Future<void> _feedback() async {
    String text = await FlyDialogInputShow(context,
        hintText:
            "ๆ่ฐขๆจๆๅบๅฎ่ดต็ๅปบ่ฎฎ๏ผ่ฟๅฏนๆไปฌ้ๅธธ้่ฆ๏ผ\n*๏ฝกูฉ(หแห*)ู*๏ฝก\n\n(ไนๅฏไปฅ็ไธๆจ็่็ณปๆนๅผ๏ผๆนไพฟๆไปฌๅๆถ่็ปๆจ)",
        confirmText: "ๅ้",
        maxLines: 10);
    if (text != null) {
      await feedbackPost(context, text: text);
      sendInfo('ๅ้ฆไธๅปบ่ฎฎ', 'ๅ้ไบๅ้ฆ:$text');
    }
  }

  Future<void> _refresh() async {
    if(await _initBalanceAndPowerProvider()){
      showToast("ๅทๆฐๆๅ๏ผ");
    }else{
      showToast("ๅทๆฐๅคฑ่ดฅ๏ฝ");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    return _myselfScaffold(children: [
      SizedBox(
        height: kToolbarHeight,
      ),
      _header(), // ไธชไบบ่ตๆๅบๅ
      Wrap(
        runSpacing: spaceCardMarginTB,
        children: [
          // NoticeCard(),
          _preview(), // ๆ?กๅญๅกใๅฎฟ่็ต้
          _container1(), // ๆ?กๅญ็ฝ็ปๅฝใใ
          _container2(), // ๅณไบๆไปฌใใ
          _container3() // ้ๅบ็ปๅฝใใ
        ],
      ),
      SizedBox(
        height: 10,
      ),
      _privacyTextButton()
    ]);
  }

  Widget _myselfScaffold({@required List<Widget> children}) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          leading: Container(),
          backgroundColor: Colors.transparent,
          systemOverlayStyle: themeProvider.simpleMode ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        ),
      ),
      body: RefreshIndicator(
        color: themeProvider.colorMain,
        onRefresh: () => _refresh(),
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // ่งฆๆธๆถ่ตท้ฎ็
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    spaceCardMarginRL, 0, spaceCardMarginRL, 0),
                child: Column(
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Wrap(
      runSpacing: spaceCardMarginBigTB * 2,
      children: <Widget>[
        _buildInfoCard(context,
            imageResource: 'images/avatar.png',
            name: Prefs.name ?? '',
            id: Prefs.username ?? '',
            classs: Prefs.className ?? '',
            college: Prefs.college ?? ''),
        Container(),
        Container()
      ],
    );
  }

  Widget _preview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: BalancePreviewView(),
        ),
        SizedBox(
          width: spaceCardMarginRL,
        ),
        Expanded(
          child: PowerPreviewView(),
        ),
      ],
    );
  }

  Widget _myselfIconTitleButton(
      {@required IconData icon,
      @required String title,
      GestureTapCallback onTap,
      bool loading = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, fontSizeMain40 * 1.3,
            spaceCardPaddingRL, fontSizeMain40 * 1.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                loading
                    ? loadingAnimationIOS()
                    : Icon(
                        icon,
                        size: sizeIconMain50,
                        color: themeProvider.colorNavText,
                      ),
                SizedBox(
                  width: spaceCardPaddingTB * 3,
                ),
                FlyText.main40(
                  title,
                  color: themeProvider.colorNavText,
                )
              ],
            ),
            FlyIconRightGreyArrow(
                color: themeProvider.colorNavText.withOpacity(0.5))
          ],
        ),
      ),
    );
  }

  Widget _privacyTextButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => FlyWebView(
                      title: "้็งๆฟ็ญ",
                      initialUrl: "https://kxz.atcumt.com/privacy.html",
                    )));
      },
      child: FlyText.main35(
        "้็งๆฟ็ญ",
        color: themeProvider.colorNavText.withOpacity(0.5),
      ),
    );
  }

  Widget _container1() {
    return _buttonList(children: <Widget>[
      FlyFlexibleButton(
        icon: Icons.language_outlined,
        title: 'ๆ?กๅญ็ฝ็ปๅฝ',
        secondChild: CumtLoginView(),
      ),
      FlyFlexibleButton(
        title: "ไธชๆงๅ",
        icon: LineariconsFree.shirt,
        secondChild: _buildPersonalise(),
      ),
    ]);
  }

  Widget _container2() {
    return _buttonList(children: <Widget>[
      // ๅณไบๆไปฌ
      _myselfIconTitleButton(
          icon: Icons.people_outline,
          title: 'ๅณไบๆไปฌ',
          onTap: () => toAboutPage(context)),
      //ๅ้ฆไธๅปบ่ฎฎ
      _myselfIconTitleButton(
          icon: Icons.feedback_outlined,
          title: 'ๅ้ฆไธๅปบ่ฎฎ',
          onTap: () => _feedback()),
      //ๅไบซApp
      _myselfIconTitleButton(
          icon: Icons.share_outlined,
          title: 'ๅไบซApp',
          onTap: () => FlyDialogDIYShow(context, content: InvitePage())),
      UniversalPlatform.isIOS
          ? Container()
          : _myselfIconTitleButton(
              icon: CommunityMaterialIcons.download_outline,
              title: 'ๆฃๆฅๆดๆฐ',
              onTap: () => checkUpgrade(context, auto: false)),
    ]);
  }

  Widget _container3() {
    return _buttonList(children: [
      _myselfIconTitleButton(
          icon: Icons.logout, title: "้ๅบ็ปๅฝ", onTap: () => _willSignOut(context))
    ]);
  }

  Widget _buildPersonalise() {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
      child: Wrap(
        children: [
          _buildDiyButton("็ฎ็บฆ็ฝ",
              child: _buildSwitch(themeProvider.simpleMode, onChanged: (v) {
                setState(() {
                  themeProvider.simpleMode = !themeProvider.simpleMode;
                });
              })),
          _buildDiyButton("ๆทฑ้้ป",
              child: _buildSwitch(themeProvider.darkMode, onChanged: (v) {
                setState(() {
                  themeProvider.darkMode = !themeProvider.darkMode;
                });
              })),
          !UniversalPlatform.isWindows
              ? Wrap(
                  children: [
                    _buildDiyButton("ๆดๆข่ๆฏ",
                        onTap: () => _changeBackgroundImage(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.arrow_right_sharp,
                              size: sizeIconMain50,
                              color:
                                  themeProvider.colorNavText.withOpacity(0.5),
                            )
                          ],
                        )),
                    _buildDiyButton("่ๆฏ้ๆ",
                        child: _buildSliver(themeProvider.transBack,
                            onChanged: (v) {
                          themeProvider.transBack = v;
                        })),
                    _buildDiyButton("่ๆฏๆจก็ณ",
                        child: _buildSliver(themeProvider.blurBack, max: 30.0,
                            onChanged: (v) {
                          themeProvider.blurBack = v;
                        })),
                    _buildDiyButton("ๅก็้ๆ",
                        child: _buildSliver(themeProvider.transCard,
                            min: 0.01,
                            max: themeProvider.darkMode
                                ? 0.8
                                : themeProvider.simpleMode
                                    ? 1.0
                                    : 0.2, onChanged: (v) {
                          themeProvider.transCard = v;
                        })),
                    _buildDiyButton("ไธป้ข้ข่ฒ", child: _buildColorSelector()),
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildColorSelector() {
    List<Color> themeColors = [
      Color.fromARGB(255, 0, 196, 169),
      Color.fromARGB(255, 0, 186, 253),
      Color.fromARGB(255, 255, 64, 58),
      Color.fromARGB(255, 255, 116, 152),
      Color.fromARGB(255, 0, 109, 252),
      Color.fromARGB(255, 255, 206, 38),
      Color.fromARGB(255, 48, 54, 56),
      Color.fromARGB(255, 200, 200, 200),
    ];
    return Container(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, 0, 0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 10,
          children: themeColors.map((item) {
            return _buildColorCir(item);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildColorCir(Color color) {
    return InkWell(
      onTap: () => themeProvider.colorMain = color,
      child: Container(
        height: fontSizeMain40 * 2,
        width: fontSizeMain40 * 2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: color),
      ),
    );
  }

  Widget _buildDiyButton(String title,
      {@required Widget child, GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: fontSizeMain40 * 3.5,
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: FlyText.main35(
                title,
                color: themeProvider.colorNavText,
              ),
            ),
            Expanded(
              flex: 5,
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(bool value, {@required ValueChanged<bool> onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Switch(
          activeColor: themeProvider.colorMain,
          value: value,
          onChanged: onChanged,
        )
      ],
    );
  }

  Widget _buildSliver(double value,
      {double max = 1.0,
      double min = 0.0,
      @required ValueChanged<double> onChanged}) {
    return Slider(
      inactiveColor: Theme.of(context).unselectedWidgetColor,
      activeColor: themeProvider.colorMain,
      value: value,
      min: min,
      max: max,
      onChanged: onChanged,
    );
  }

  void _changeBackgroundImage() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final File tempImgFile = File(pickedFile.path);
    String imageFileName = tempImgFile.path.substring(
        tempImgFile.path.lastIndexOf('/') + 1, tempImgFile.path.length);
    Directory tempDir = await getApplicationDocumentsDirectory();
    Directory directory = new Directory('${tempDir.path}/images');
    if (!directory.existsSync()) {
      directory.createSync();
    }
    backImgFile = await tempImgFile.copy('${directory.path}/$imageFileName');
    backImg = new Image.file(
      backImgFile,
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
    await precacheImage(new FileImage(backImgFile), context);
    Prefs.backImg = backImgFile.path;
    navigatorPageController.jumpToPage(0);
  }

  //็กฎๅฎ้ๅบ
  Future<bool> _willSignOut(context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: FlyText.main40(
              'ไฝ?็กฎๅฎ่ฆ้ๅบ็ปๅฝๅ?\n\n'
              '่ฟไผๆธ้คๆๆๆฌๅฐ็ผๅญ\n\n๏ผๅๆฌ่ชๅฎไน่ๆฏใ่ชๅฎไน่ฏพ่กจใ่ชๅฎไนๅ่ฎกๆถใๆ?กๅญ็ฝ็ปๅฝ่ดฆๆทไฟกๆฏใๅฎฟ่็ต้็ปๅฎไฟกๆฏโฆโฆ๏ผ',
              maxLine: 100,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => _signOut(),
                child: FlyText.main40('็กฎๅฎ', color: colorMain),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: FlyText.mainTip40(
                  'ๅๆถ',
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buttonList({List<Widget> children = const <Widget>[]}) {
    return FlyContainer(
        child: Column(
      children: children,
    ));
  }

//ไธชไบบ่ตๆๅก
  Widget _buildInfoCard(BuildContext context,
      {String imageResource = "",
      String name = "",
      String id = "",
      String classs = "",
      String college = ""}) {
    String title = "ๆฉไธๅฅฝ";
    Map subText = {
      0: "โบ๏ธ ่ฏฅ็ก่งไบๅฆ๏ฝใ",
      1: "๐ ๅทๅทๅชๅ๏ผๆไปฌ้ฝไผๆไธบๅซไบบ็ๆขฆๆณใ",
      2: "๐ ๅทๅทๅชๅ๏ผๆไปฌ้ฝไผๆไธบๅซไบบ็ๆขฆๆณใ",
      3: "๐ช ๅฐๅฉๅฟซ่ฆ็ฌไธๅจไบ๏ฝ",
      4: "๐ด ๅผๅๅๅๅๅ๏ฝ",
      5: "๏ธ๐ฅฐ ๆฉ่ตท็้ธๅฟๆ่ซๅใ",
      6: "๐ โไธๆฅไน่ฎกๅจไบๆจใ",
      7: "๐ ๆฒกๆ้ไธๆฅ็ๆฉๆจ๏ผๅชๆไธๆข่ฟฝ็ๆขฆใ",
      8: "๐ฆ ่ถๆฏๆงๆฌ๏ผๅฐฑ่ถ่ฆ้ฃ้จๅผ็จใ",
      9: "โ๏ธ ่ฆๅผๅฟ๏ผไฝ?่ฟๆฉๆฏๅซไบบ็ๅฎ่ใ",
      10: "๐ ่ฟๅนไธๅบ่คถ็ๅนณ้ๆฅๅญ๏ผไนๅจ้ชๅใ",
      11: "๐ ๅ่ทฏๆผซๆผซไบฆ็ฟ็ฟใ",
      12: "๐ฅณ ไธ่ฏพๅฆ๏ผๅปๅ้ฅญๅง๏ฝ",
      13: "โ๏ธ ็ป็ๆดๆ๏ผๆฉๅญ่พ็ใ",
      14: "โ๏ธ ไฟกๆๆๆฅ็ไปๅฎน๏ผ้ฝๆฏๅ็งฏ่ๅ็ๆฒๆทใ",
      15: "โ๏ธ ไฟกๆๆๆฅ็ไปๅฎน๏ผ้ฝๆฏๅ็งฏ่ๅ็ๆฒๆทใ",
      16: "โบ๏ธ ไฟๆ็ญ็ฑ๏ผๅฅ่ตดๅฑฑๆฒณใ",
      17: "โบ๏ธ ไฟๆ็ญ็ฑ๏ผๅฅ่ตดๅฑฑๆฒณใ",
      18: "๐ค ๆ้ฅญๆถ้ดๅฐ๏ฝ",
      19: "๐ซ ๅซๆ๏ผๆไบฎไนๅจๅคงๆตทๆๅค่ฟท่ซใ",
      20: "โญ๏ธ ้่ฟ่ฝๆฅไฝๆ๏ผ่ฏท่ฎฐๅพ่ฟๆๆผซๅคฉๆ่พฐใ",
      21: "โจ ๆๅไธ้ฎ่ตถ่ทฏไบบ๏ผๆถๅไธ่ดๆๅฟไบบใ",
      22: "โจ ๆๅไธ้ฎ่ตถ่ทฏไบบ๏ผๆถๅไธ่ดๆๅฟไบบใ",
      23: "๐ ่ฟๆๆๆๅฏๅฏๆ๏ผ่ฟๆๅฎๅฎๆตชๆผซไธๆญขใ",
    };
    int hour = DateTime.now().hour;
    String sentence = subText[hour];
    if (hour < 5) title = "ๅคๆทฑไบ";
    if (hour >= 19) {
      title = "ๆไธๅฅฝ";
    } else if (hour >= 18) {
      title = "ๅๆไบ";
    } else if (hour >= 14) {
      title = "ไธๅๅฅฝ";
    } else if (hour >= 11) {
      title = "ไธญๅๅฅฝ";
    } else if (hour >= 8) {
      title = "ไธๅๅฅฝ";
    }

    return Container(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: spaceCardMarginRL * 2,
          ),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "$title๏ผ" + name,
                    style: TextStyle(
                        color: themeProvider.colorNavText,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(60)),
                  ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       padding: EdgeInsets.fromLTRB(
                  //           fontSizeMini38 / 2, 0, fontSizeMini38 / 2, 0),
                  //       decoration: BoxDecoration(
                  //           color: colorMain.withAlpha(200),
                  //           borderRadius: BorderRadius.circular(2)),
                  //       child: (Prefs.rank!=null&&int.parse(Prefs.rank)<=2000)?Row(
                  //         children: [
                  //           FlyText.mini30("ๅๆตไผๅ",
                  //               color: Colors.white,
                  //               textAlign: TextAlign.center),
                  //           FlyText.mini30(
                  //               " No.${Prefs.rank}",
                  //               color: Colors.white)
                  //         ],
                  //       ):Container(),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: FlyText.main40(
                      sentence,
                      color: themeProvider.colorNavText.withOpacity(0.5),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FlyFlexibleButton extends StatefulWidget {
  final Widget secondChild;
  final String title;
  final IconData icon;
  final String previewStr;
  final GestureTapCallback onTap;

  const FlyFlexibleButton(
      {Key key,
      this.secondChild,
      this.title,
      this.icon,
      this.previewStr,
      this.onTap})
      : super(key: key);

  @override
  _FlyFlexibleButtonState createState() => _FlyFlexibleButtonState();
}

class _FlyFlexibleButtonState extends State<FlyFlexibleButton> {
  bool showSecond = false;
  double opacity = 0;
  ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    if (opacity > 0) opacity = themeProvider.transCard;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Theme.of(context).cardColor.withOpacity(opacity)),
      child: Column(
        children: [
          _button(),
          AnimatedCrossFade(
            alignment: Alignment.topCenter,
            firstCurve: Curves.easeOutCubic,
            secondCurve: Curves.easeOutCubic,
            sizeCurve: Curves.easeOutCubic,
            firstChild: Container(),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(
                  spaceCardMarginRL, 0, spaceCardMarginRL, spaceCardMarginTB),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                    color: Theme.of(context).cardColor.withOpacity(opacity)),
                child: Column(
                  children: [
                    themeProvider.simpleMode
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(
                                spaceCardMarginRL, 0, spaceCardMarginRL, 0),
                            child: Divider(
                              height: 0,
                            ),
                          )
                        : Container(),
                    widget.secondChild ?? Container()
                  ],
                ),
              ),
            ),
            duration: Duration(milliseconds: 200),
            crossFadeState: showSecond
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          )
        ],
      ),
    );
  }

  Widget _button() => InkWell(
        onTap: widget.onTap ??
            () {
              setState(() {
                showSecond = !showSecond;
                if (showSecond) {
                  opacity = themeProvider.transCard;
                } else {
                  opacity = 0;
                }
              });
            },
        child: Padding(
          padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, fontSizeMain40 * 1.3,
              spaceCardPaddingRL, fontSizeMain40 * 1.3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      widget.icon,
                      size: sizeIconMain50,
                      color: themeProvider.colorNavText,
                    ),
                    SizedBox(
                      width: spaceCardPaddingTB * 3,
                    ),
                    FlyText.main40(
                      widget.title,
                      color: themeProvider.colorNavText,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          widget.previewStr != null
                              ? FlyText.main35(
                                  widget.previewStr,
                                  color: themeProvider.colorNavText
                                      .withOpacity(0.5),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    SizedBox(
                      width: fontSizeMini38,
                    )
                  ],
                ),
              ),
              Icon(
                showSecond
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                size: sizeIconMain50,
                color: themeProvider.colorNavText.withOpacity(0.5),
              )
            ],
          ),
        ),
      );
}
