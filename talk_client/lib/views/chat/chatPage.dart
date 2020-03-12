import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talk_client/providers/chat.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.data}) : super(key: key);
  final data;
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Map<String, dynamic> props;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      var list = List<int>();
      jsonDecode(widget.data).forEach(list.add);
      final String val = Utf8Decoder().convert(list);
      var mapVal = json.decode(val);
      print(mapVal);
      props = mapVal;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('聊天页 build');
    return ChangeNotifierProvider(
      create: (_) => ChatModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${props['name']}'),
          centerTitle: true,
          actions: <Widget>[],
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: Consumer(
                builder: (BuildContext context, ChatModel store, _) {
                  print('聊天列表 build');
                  return ListView.builder(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                    reverse: true,
                    itemCount: store.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setWidth(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(32),
                              ),
                              child: CircleAvatar(
                                child: Text('${store.list[index]['name'][0]}'),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${store.list[index]['name']}',
                                  style: Theme.of(context).textTheme.subhead,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(10),
                                  ),
                                  child:
                                      Text('${store.list[index]['content']}'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Consumer(
              builder: (BuildContext context, ChatModel store, _) {
                return Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setWidth(20),
                    horizontal: ScreenUtil().setWidth(30),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: '发送消息',
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20),
                          vertical: ScreenUtil().setWidth(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (String text) {
                        if (text.trim().isEmpty) {
                          return;
                        }
                        _controller.clear();
                        store.sendMes(text);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
