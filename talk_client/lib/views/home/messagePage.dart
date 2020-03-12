import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talk_client/application.dart';
import 'package:talk_client/providers/message.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    print('消息页 build');
    return ChangeNotifierProvider(
      create: (_) => MessageModel(),
      child: Scaffold(
        body: Selector<MessageModel, MessageModel>(
          shouldRebuild: (pre, next) => false,
          selector: (context, store) => store,
          builder: (context, store, child) {
            return ListView.separated(
              itemCount: store.total,
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(32),
              ),
              itemBuilder: (BuildContext context, int index) {
                return Selector<MessageModel, Map<String, dynamic>>(
                  selector: (context, store) => store.list[index],
                  builder: (context, data, child) {
                    print('No.${index + 1} is rebuild');
                    return ListTile(
                      title: Text('${data['name']}'),
                      subtitle: Text(
                        '${data['lastMes']['name']}: ${data['lastMes']['text']}',
                      ),
                      trailing: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('${data['lastMes']['time']}'),
                            Text(
                                '${data['unRead'] == 0 ? '' : data['unRead']}'),
                          ],
                        ),
                      ),
                      onTap: () {
                        String params = json.encode(data);
                        String jsonStr =
                            jsonEncode(Utf8Encoder().convert(params));
                        store.clearUnreadNumber(index);
                        Application.router.navigateTo(
                          context,
                          '/chat?data=$jsonStr',
                        );
                      },
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
          },
        ),
      ),
    );
  }
}
