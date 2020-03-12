import 'package:flutter/material.dart';
import 'package:talk_client/application.dart';

class ChatModel with ChangeNotifier {
  // state
  List<Map<String, dynamic>> _list = [
    {
      'avatar': 'N',
      'name': '裴雅婷',
      'content': '你愁啥',
    },
    {
      'avatar': 'M',
      'name': '默默',
      'content': '瞅你咋地',
    },
  ];
  // getter
  List<Map<String, dynamic>> get list => _list;

  // action
  // 发送消息
  void sendMes(String text) {
    print(text);
    Application.io.emit('mes', text);
    _addMes(text);
    _savedMes(text);
  }

  // 消息列表增加一条记录
  void _addMes(String text) {}
  // 保存聊天记录
  void _savedMes(String text) {
    // Application.prefs.getStringList('mes');
  }
}
