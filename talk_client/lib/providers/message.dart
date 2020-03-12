import 'package:flutter/material.dart';
import 'package:talk_client/application.dart';

class MessageModel with ChangeNotifier {
  // state
  List<Map<String, dynamic>> _list = [
    {
      '_id': '55555555',
      'type': 'room',
      'name': '前端交流群',
      'lastMes': {'name': '佳佳', 'text': '来跟妲己玩耍吧', 'time': '11:12'},
      'unRead': '10'
    },
    {
      '_id': '66666666',
      'type': 'people',
      'name': '大魔王',
      'lastMes': {'name': '希尔', 'text': '呦呦切克闹', 'time': '13:00'},
      'unRead': '88'
    }
  ];

  // getter
  List<Map<String, dynamic>> get list => _list;
  int get total => _list.length;

  /* action */
  // 增加未读消息累计数字
  void addUnreadNumber(int index) {
    var n = _list[index]['unRead'];
    _list[index]['unRead'] = ++n;
  }

  // 清除未读消息累计数字
  void clearUnreadNumber(int index) {
    print("清除未读消息记录");
    var item = _list[index];
    _list[index] = {
      '_id': item['_id'],
      'type': item['type'],
      'name': item['name'],
      'lastMes': item['lastMes'],
      'unRead': 0
    };
    notifyListeners();
  }
}
