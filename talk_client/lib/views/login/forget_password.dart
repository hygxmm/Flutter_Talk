import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/style.dart';

class ForgetPassPage extends StatefulWidget {
  @override
  _ForgetPassPageState createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  void submit() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text(
          '忘记密码',
          // style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(32),
              ),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: '请输入手机号',
                        prefixIcon: Text('手机号'),
                        suffix: Text('获取验证码'),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: '请输入验证码',
                        prefixIcon: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('验证码'),
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: '请输入新密码',
                        prefixIcon: Text('新密码'),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: '请再次输入新密码',
                        prefixIcon: Text('新密码'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: ScreenUtil().setWidth(32),
              bottom: ScreenUtil().setWidth(60),
              right: ScreenUtil().setWidth(32),
              child: Container(
                height: ScreenUtil().setWidth(100),
                child: RaisedButton(
                  child: Text('提 交', style: lgStyle),
                  color: Theme.of(context).accentColor,
                  onPressed: submit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
