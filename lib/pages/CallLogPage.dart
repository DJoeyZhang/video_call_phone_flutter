import 'dart:convert';

import 'package:video_call_flutter/constant/EventBusConstant.dart';
import 'package:video_call_flutter/entity/contact_entity.dart';
import 'package:video_call_flutter/pages/MessagePage.dart';
import 'package:video_call_flutter/res/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:video_call_flutter/repository/CommonApi.dart';
import 'package:video_call_flutter/entity/article_entity.dart';
import 'package:video_call_flutter/entity/banner_entity.dart';
import 'package:video_call_flutter/entity/common_entity.dart';
import 'package:video_call_flutter/http/httpUtil.dart';
import 'package:video_call_flutter/util/EventBus.dart';

import 'package:video_call_flutter/util/ToastUtil.dart';
import 'package:video_call_flutter/util/ColorUtils.dart';
import 'package:flutter/services.dart';
import 'package:video_call_flutter/util/LogUtil.dart';
import 'loginPage.dart';

class CallLogPage extends StatefulWidget {
  CallLogPage({Key key}) : super(key: key);

  @override
  _CallLogPageState createState() => _CallLogPageState();
}

class _CallLogPageState extends State<CallLogPage> {
  List<Contact> contactList = List();
  var bus = EventBus();
  String picPrefix = "lib/res/images/calllog/";
  String mockPrefix = "lib/res/mock/";

  @override
  void dispose() {
    super.dispose();
    bus.off(EventBusConstant.callLogPage);
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    bus.on(EventBusConstant.callLogPage, (arg) {
      LogUtils.d('CallLogPage', "update=$arg");
      // setState(() {});
    });
  }

  void _fetchData() async {
    try {
      rootBundle.loadString(mockPrefix + 'calllog.json').then((value) {
        var map = json.decode(value);
        var contactEntity = ContactEntity.fromJson(map);
        setState(() {
          contactList = contactEntity.data;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = ZStrings.callLog;
    LogUtils.d('CallLogPage', "build");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(title,
            textAlign: TextAlign.center, style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: Image.asset(
              picPrefix + 'call_log_message_icon_normal.png',
              height: 22,
              width: 22,
            ),
            tooltip: '消息',
            onPressed: () {
              // ZToast.show(context: context, msg: "消息");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessagePage()),
              );
            },
          ),
          IconButton(
            icon: Image.asset(
              picPrefix + 'right_top_black_plus_icon.png',
              height: 18,
              width: 18,
            ),
            tooltip: '多重操作',
            onPressed: () {
              ZToast.show(context: context, msg: "多重操作");
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => SearchPage()),
              // );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: _onKeyBoardShowClick,
          tooltip: '呼出键盘',
          child: Image.asset(
            'lib/res/images/calllog/call_log_keyboard_icon.png',
            width: 78,
            height: 78,
          )),
      body: Column(
        children: <Widget>[this._createHeadEntry(), this._createCallLogList()],
      ),
    );
  }

  Widget _getRow(int i, Contact data) {
    String name = data.nickName;
    String serialNumber = data.serialNumber.toString();
    String lead = name.substring(name.length - 1, name.length);
    // bool noDivider = i == contactList.length - 1;

    var row = Container(
        color: Colors.white,
        height: 65,
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 22),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  serialNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: Text(
                  lead,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  lead,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Divider(
              thickness: 1,
              height: 1,
            ),
          ],
        ));

    Color c = i % 2 == 0 ? Colors.red : Colors.greenAccent;
    return GestureDetector(
      child: row,
      onLongPress: () {
        ZToast.show(context: context, msg: "long click " + data.nickName);
      },
      onTap: () {
        ZToast.show(context: context, msg: "single click " + data.nickName);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ArticleDetail(
        //         title: articleDatas[i].title, url: articleDatas[i].link),
        //   ),
        // );
      },
    );
  }

  void _onKeyBoardShowClick() {
    ZToast.show(context: context, msg: "keyboard show");
  }

  Widget _createHeadEntry() {
    return Container(
      color: Colors.white,
      padding:
          EdgeInsets.only(left: 50.0, top: 20.0, right: 50.0, bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          this._headerBlockCreator(
              'link_home', 'call_log_phone_icon.png', ZStrings.linkMyHome),
          this._headerBlockCreator(
              'multi_call', 'call_log_people_icon.png', ZStrings.multiCall),
          this._headerBlockCreator(
              'appointment', 'call_log_clock_icon.png', ZStrings.appointment),
        ],
      ),
    );
  }

  void _onHeadBlockEntryClick(String type) {
    ZToast.show(context: context, msg: type);
  }

  Widget _headerBlockCreator(String type, String pic, String subTitle) {
    double iconWidth = 60.0;
    double iconHeight = 60.0;
    Color titleColor = ColorsUtil.hexStringColor("#333333");
    TextStyle titleStyle = TextStyle(fontSize: 18.0, color: titleColor);

    return GestureDetector(
      onTap: () => this._onHeadBlockEntryClick(type),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            picPrefix + pic,
            width: iconWidth,
            height: iconHeight,
          ),
          Text(subTitle, textDirection: TextDirection.ltr, style: titleStyle),
        ],
      ),
    );
  }

  Widget _createCallLogList() {
    return Expanded(
      // height: 500,
      child: EasyRefresh.custom(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < contactList.length)
                  return this._getRow(index, contactList[index]);
                return null;
              },
              childCount: contactList.length,
            ),
          ),
        ],
      ),
    );
  }
}
