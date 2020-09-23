import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:video_call_flutter/constant/EventBusConstant.dart';
import 'package:video_call_flutter/repository/CommonApi.dart';
import 'package:video_call_flutter/entity/navi_entity.dart';
import 'package:video_call_flutter/http/httpUtil.dart';
import 'package:video_call_flutter/res/colors.dart';
import 'package:video_call_flutter/res/strings.dart';
import 'package:video_call_flutter/util/ColorUtils.dart';
import 'package:video_call_flutter/util/EventBus.dart';
import 'package:video_call_flutter/util/LogUtil.dart';
import 'package:video_call_flutter/util/ToastUtil.dart';

import 'AboutPage.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> {
  String picPrefix = "lib/res/images/mine/";
  String mockPrefix = "lib/res/mock/";
  var bus = EventBus();
  @override
  void initState() {
    super.initState();
    bus.on(EventBusConstant.minePage, (arg) {
      LogUtils.d('MinePage', "update=$arg");
      // setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off(EventBusConstant.minePage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  child: Column(children: [
                this._createHeader(),
                this._createItem("room_num"),
                this._createItem("setting"),
                this._createItem("about")
              ]))),
        ]));
  }

  Widget _createHeader() {
    return GestureDetector(
      onTap: () {
        ZToast.show(context: context, msg: "user info");
      },
      child: Stack(children: [
        Container(
          width: double.infinity,
          height: 240,
          child: Image.asset(
            picPrefix + 'mine_fragment_top_bg.png',
            fit: BoxFit.fitWidth,
          ),
        ),
        Container(
            width: double.infinity,
            height: 240,
            padding: EdgeInsets.only(right: 24, bottom: 52),
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Image.asset(
              picPrefix + 'mine_fragment_right_arrow.png',
              width: 7,
              height: 15,
            )),
        Container(
          height: 240,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 60),
          width: double.infinity,
          child: Text(
            ZStrings.setting,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        Container(
          height: 240,
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(left: 40, bottom: 40),
          width: double.infinity,
          child: new ClipOval(
            child: Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: Text(
                'H',
                style: TextStyle(fontSize: 36, color: Colors.white),
              ),
              color: ColorsUtil.getRandomColor(),
            ),
          ),
        ),
        Container(
            height: 240,
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(left: 140, bottom: 50),
            child: Text(
              'Lydia',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ))
      ]),
    );
  }

  Widget _createItem(String type) {
    var _left = "";
    var _right;
    var _onTap;
    switch (type) {
      case "room_num":
        _left = ZStrings.roomNum;
        _right = Text("12345",
            style: TextStyle(
                color: ColorsUtil.hexStringColor("#777777"), fontSize: 18));
        _onTap = null;
        break;
      case "setting":
        _left = ZStrings.setting;
        _right = Image.asset(
          picPrefix + 'black_right_arrow.png',
          height: 17,
          width: 9,
        );
        // ignore: sdk_version_set_literal
        _onTap = () => {ZToast.show(context: context, msg: "setting")};
        break;
      case "about":
        _left = ZStrings.about;
        _right = Image.asset(
          picPrefix + 'black_right_arrow.png',
          height: 17,
          width: 9,
        );
        // ignore: sdk_version_set_literal
        _onTap = () => {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => AboutPage(),
                ),
              )
            };
        break;
    }

    return GestureDetector(
      onTap: _onTap,
      child: Container(
          height: 64,
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _left,
                      style: TextStyle(
                          color: ColorsUtil.hexStringColor("#333333"),
                          fontSize: 18),
                    ),
                    _right
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: ColorsUtil.hexStringColor("#E6E6E6"),
              )
            ],
          )),
    );
  }
}
