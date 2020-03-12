import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:talk_client/views/chat/chatPage.dart';
import 'package:talk_client/views/home/bottomBar.dart';
import 'package:talk_client/views/login/loginPage.dart';
import 'package:talk_client/views/login/registerPage.dart';
import 'package:talk_client/views/login/splashPage.dart';

// 根路由
var rootHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return SplashPage();
  },
);
// 登录页
var loginHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return LoginScreen();
  },
);
// 注册页
var registerHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return RegisterScreen();
  },
);
// 首页
var mainHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return BottomTabBar();
  },
);
// 聊天界面
var chatHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    var data = params['data']?.first;
    print("参数是:");
    print(data);
    return ChatPage(data: data);
  },
);
