import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
import 'package:talk_client/application.dart';
import 'package:talk_client/providers/message.dart';
import 'package:talk_client/providers/user.dart';

void main() async {
  // 确保可以初始化 shared_preferences
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化 路由
  Application.initRouter();
  // 初始化 shared_preferences
  Application.initSp();
  // 安卓状态栏透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>.value(value: UserModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BotToastInit(
      child: MaterialApp(
        title: 'Flutter Talk',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorObservers: [BotToastNavigatorObserver()],
        onGenerateRoute: Application.router.generator,
      ),
    );
  }
}
