import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_call_flutter/constant/EventBusConstant.dart';

import 'package:video_call_flutter/pages/AboutPage.dart';

import 'package:video_call_flutter/pages/CallLogPage.dart';
import 'package:video_call_flutter/pages/MinePage.dart';

import 'package:video_call_flutter/pages/CallDirectoryPage.dart';
import 'package:video_call_flutter/res/colors.dart';
import 'package:video_call_flutter/res/strings.dart';
import 'package:video_call_flutter/util/EventBus.dart';
import 'package:video_call_flutter/util/favoriteProvide.dart';
import 'package:video_call_flutter/util/themeProvide.dart';

import 'repository/CommonApi.dart';
import 'http/httpUtil.dart';

void main() async {
  //runApp前调用，初始化绑定，手势、渲染、服务等
  WidgetsFlutterBinding.ensureInitialized();

  //初始化
  var theme = ThemeProvide();
  var favorite = FavoriteProvide();
  var providers = Providers();
  //将theme,favorite加到providers中
  providers
    ..provide(Provider.function((context) => theme))
    ..provide(Provider.function((context) => favorite));

  int themeIndex = await getTheme();

  runApp(ProviderNode(
    providers: providers,
    child: MyApp(themeIndex),
  ));
}

Future<int> getTheme() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  int themeIndex = sp.getInt("themeIndex");
  return null == themeIndex ? 0 : themeIndex;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final int themeIndex;

  MyApp(this.themeIndex);

  @override
  Widget build(BuildContext context) {
    return Provide<ThemeProvide>(
      builder: (context, child, theme) {
        return MaterialApp(
          title: ZStrings.appName,
          theme: ThemeData(
              // This is the theme of your application.
              //除了primaryColor，还有brightness、iconTheme、textTheme等等可以设置
              primaryColor: YColors.themeColor[theme.value != null
                  ? theme.value
                  : themeIndex]["primaryColor"],
              primaryColorDark: YColors.themeColor[theme.value != null
                  ? theme.value
                  : themeIndex]["primaryColorDark"],
              accentColor: YColors.themeColor[theme.value != null
                  ? theme.value
                  : themeIndex]["colorAccent"]),
          home: MyHomePage(title: ZStrings.appName),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  var pages = <Widget>[CallLogPage(), CallDirectoryPage(), MinePage()];
  var bus = EventBus();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        items: this._getBottomBarConfig(),
        //当前选中下标
        currentIndex: _selectedIndex,
        //显示模式
        type: BottomNavigationBarType.fixed,
        //选中颜色
        fixedColor: Color.fromRGBO(0, 0, 0, 1),
        //点击事件
        onTap: _onItemTapped,
      ),
    );
  }

  void _notifyPageUpdate(int index) {
    String eventKey;
    switch (index) {
      case 0:
        eventKey = EventBusConstant.callLogPage;
        break;
      case 1:
        eventKey = EventBusConstant.callDirectoryPage;
        break;
      case 2:
        eventKey = EventBusConstant.minePage;
        break;
      default:
        break;
    }
    bus.send(eventKey);
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    this._notifyPageUpdate(index);

    setState(() {
      _selectedIndex = index;
    });
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: "选中最后一个",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: YColors.colorPrimaryDark,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  //for android back press call
  void showLogoutDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('确认退出吗？'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消', style: TextStyle(color: YColors.primaryText)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                //退出
                // HttpUtil().get(Api.LOGOUT);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<BottomNavigationBarItem> _getBottomBarConfig() {
    double iconWidth, iconHeight = 25;
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Image.asset(
          'lib/res/images/main/main_bottom_call_log_icon_normal.png',
          width: iconWidth,
          height: iconHeight,
        ),
        activeIcon: Image.asset(
          'lib/res/images/main/main_bottom_call_log_icon_selected.png',
          width: iconWidth,
          height: iconHeight,
        ),
        title: Text(ZStrings.callLog),
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          'lib/res/images/main/main_call_directory_icon_normal.png',
          width: iconWidth,
          height: iconHeight,
        ),
        activeIcon: Image.asset(
          'lib/res/images/main/main_call_directory_icon_selected.png',
          width: iconWidth,
          height: iconHeight,
        ),
        title: Text(ZStrings.callDirectory),
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          'lib/res/images/main/main_bottom_settings_icon_normal.png',
          width: iconWidth,
          height: iconHeight,
        ),
        activeIcon: Image.asset(
          'lib/res/images/main/main_bottom_settings_icon_selected.png',
          width: 25,
          height: 25,
        ),
        title: Text(ZStrings.settings),
      ),
    ];
  }

  void showThemeDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('切换主题'),
          content: SingleChildScrollView(
            child: Container(
              //包含ListView要指定宽高
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: YColors.themeColor.keys.length,
                itemBuilder: (BuildContext context, int position) {
                  return GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.only(bottom: 15),
                      color: YColors.themeColor[position]["primaryColor"],
                    ),
                    onTap: () async {
                      Provide.value<ThemeProvide>(context).setTheme(position);
                      //存储主题下标
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      sp.setInt("themeIndex", position);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('关闭',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
