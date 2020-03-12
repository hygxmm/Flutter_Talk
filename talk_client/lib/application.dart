import 'package:fluro/fluro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_client/router/routes.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Application {
  static Router router;
  static SharedPreferences prefs;
  static IO.Socket io;

  // 初始化 fluro
  static initRouter() {
    final Router _router = Router();
    Routes.configureRoutes(_router);
    router = _router;
  }

  // 初始化 shared_preferences
  static initSp() async {
    prefs = await SharedPreferences.getInstance();
  }

  // 初始化 socket
  static initSocket() {
    io = IO.io('http://192.168.0.107:7001', <String, dynamic>{
      'transports': ['websocket'],
      'query': {
        'room': 'demo',
        'userId': 'client_aaaaaaa',
      },
    });
    io.on('connect', (_) {
      print('连接上啦');
      print('');
    });
    io.on('connect_error', (_) => print('连接错误'));
    io.on('connect_timeout', (_) => print('连接超时'));
    io.on('connecting', (_) => print('连接中'));
    io.on('disconnect', (_) => print('连接断啦'));
    io.on('error', (_) => print('错误'));
    io.on('reconnect', (_) => print('重连'));
    io.on('reconnect_attempt', (_) => print(''));
    io.on('reconnect_failed', (_) => print('重连失败'));
    io.on('reconnect_error', (_) => print('重连错误'));
    io.on('reconnecting', (_) => print('重连中'));
    io.on('ping', (_) => print('ping'));
    io.on('pong', (_) => print('pong'));
    io.on('message', (data) {
      final dataList = data as List;
      final ack = dataList.last as Function;
      ack(null);
    });
  }
}
