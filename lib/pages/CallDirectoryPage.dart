import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:video_call_flutter/constant/EventBusConstant.dart';
import 'package:video_call_flutter/repository/CommonApi.dart';
import 'package:video_call_flutter/entity/contact_entity.dart';
import 'package:video_call_flutter/entity/tree_entity.dart';
import 'package:video_call_flutter/http/httpUtil.dart';

import 'package:video_call_flutter/res/colors.dart';
import 'package:video_call_flutter/res/strings.dart';
import 'package:video_call_flutter/util/EventBus.dart';
import 'package:video_call_flutter/util/LogUtil.dart';
import 'package:video_call_flutter/util/ToastUtil.dart';

import 'AddContactPage.dart';

class CallDirectoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CallDirectoryPageState();
  }
}

class _CallDirectoryPageState extends State<CallDirectoryPage> {
  String picPrefix = "lib/res/images/callDirectory/";
  String mockPrefix = "lib/res/mock/";
  List<Contact> contactList = List();
  var bus = EventBus();

  @override
  void dispose() {
    super.dispose();
    bus.off(EventBusConstant.callDirectoryPage);
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    bus.on(EventBusConstant.callDirectoryPage, (arg) {
      LogUtils.d('CallDirectoryPage', "update=$arg");
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
    String title = ZStrings.callDirectory;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                picPrefix + 'call_directory_right_top_add_icon.png',
                height: 18,
                width: 18,
              ),
              tooltip: '添加联系人',
              onPressed: () {
                // ZToast.show(context: context, msg: "添加联系人");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddContactPage()),
                );
              },
            ),
            IconButton(
              icon: Image.asset(
                picPrefix + 'call_directory_right_top_edit_icon.png',
                height: 18,
                width: 18,
              ),
              tooltip: '多选',
              onPressed: () {
                ZToast.show(context: context, msg: "多选");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SearchPage()),
                // );
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            this._createSearchBar(),
            this._createList(),
          ],
        ));
  }

  Widget _createSearchBar() {
    return Text('搜索', style: TextStyle(height: 4));
  }

  Widget _createList() {
    return Expanded(
      flex: 1,
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
}
