import 'package:flutter/material.dart';
import 'package:talk_client/application.dart';
import 'dart:convert';

import 'package:talk_client/utils/request.dart';

class UserModel with ChangeNotifier {
  Map<String, dynamic> _user;
  String _token;

  Map<String, dynamic> get user => _user;
  String get token => _token;

  // 初始化 用户信息
  void initUser() {
    if (Application.prefs.containsKey('user')) {
      String _str = Application.prefs.getString('user');
      _user = json.decode(_str);
    }
    if (Application.prefs.containsKey('token')) {
      String _str = Application.prefs.getString('token');
      _token = _str;
    }
  }

  // 保存 用户信息
  void _savedUser(Map<String, dynamic> user, String token) {
    _user = user;
    _token = token;
    Application.prefs.setString('user', json.encode(user));
    Application.prefs.setString('token', token);
  }

  // 登录
  Future login(String username, String password) async {
    print('登录请求');
    var result = await HttpUtil().post(
      'user/login',
      data: {'username': username, 'password': password},
    );
    if (result['code'] == 0) {
      _savedUser(result['data']['user'], result['data']['token']);
      return result['data'];
    } else {
      return null;
    }
  }

  // 注册
  Future register(String name, String password) async {
    print('注册请求');
    var result = await HttpUtil().post(
      'user/register',
      data: {'username': name, 'password': password},
    );
    print(result);
    if (result['code'] == 0) {
      return result['data'];
    } else {
      return null;
    }
  }
}
