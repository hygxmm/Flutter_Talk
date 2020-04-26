import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk_client/application.dart';
import 'package:talk_client/views/home/MomentPage.dart';
import 'package:talk_client/views/home/friendPage.dart';
import 'package:talk_client/views/home/messagePage.dart';

class BottomTabBar extends StatefulWidget {
  @override
  _BottomTabBarState createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  final List<BottomNavigationBarItem> tabs = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('消息')),
    BottomNavigationBarItem(icon: Icon(Icons.person_pin), title: Text('联系人')),
    BottomNavigationBarItem(icon: Icon(Icons.camera), title: Text('动态')),
  ];
  final List<Widget> views = [
    MessagePage(),
    FriendPage(),
    MomentPage(),
  ];
  static final List<String> titles = ['消息', '联系人', '动态'];
  static int curIndex = 0;
  String title = titles[curIndex];

  @override
  void initState() {
    // Application.initSocket(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        centerTitle: true,
        leading: Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
          child: InkWell(
            child: ClipOval(
              child: Image.asset('assets/images/avatar.png'),
            ),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.add),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
                    title: Text('加好友/群'),
                    leading: Icon(Icons.person_add),
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    title: Text('创建群聊'),
                    leading: Icon(Icons.group_add),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: curIndex,
        children: views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: curIndex,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.grey,
        items: tabs,
        onTap: (int index) {
          setState(() {
            curIndex = index;
            title = titles[curIndex];
          });
        },
      ),
    );
  }
}
