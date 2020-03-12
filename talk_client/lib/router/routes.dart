import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './route_handlers.dart';

class Routes {
  static String root = '/';
  static String login = '/login';
  static String register = '/register';
  static String main = '/main';
  static String chat = '/chat';

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return Scaffold(
          body: Center(
            child: Text(
              '404',
              style: TextStyle(fontSize: 48, color: Colors.grey[500]),
            ),
          ),
        );
      },
    );
    router.define(root, handler: rootHandler);
    router.define(login, handler: loginHandler);
    router.define(register, handler: registerHandler);
    router.define(main, handler: mainHandler);
    router.define(chat, handler: chatHandler);
  }
}
