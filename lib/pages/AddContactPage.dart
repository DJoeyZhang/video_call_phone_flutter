import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:video_call_flutter/res/strings.dart';
import 'package:video_call_flutter/util/ToastUtil.dart';

class AddContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(ZStrings.addContactTitle),
            expandedHeight: 230.0,
            floating: false,
            pinned: true,
            snap: false,
          ),
          SliverFixedExtentList(
            itemExtent: 800.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "video_call_flutter V1.0",
                        style: TextStyle(fontSize: 25, fontFamily: 'mononoki'),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
