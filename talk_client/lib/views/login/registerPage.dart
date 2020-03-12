import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talk_client/application.dart';
import 'package:talk_client/providers/user.dart';
import '../../utils/style.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _passCtrl = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: ScreenUtil().setWidth(750),
          height: ScreenUtil().setHeight(1334),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(750),
                  height: ScreenUtil().setWidth(430),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(56)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setWidth(100),
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            Application.router.pop(context);
                          },
                          child: Container(
                            width: ScreenUtil().setWidth(48),
                            height: ScreenUtil().setWidth(48),
                            child: Image.asset(
                              'assets/images/back.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('您好,', style: titleStyle),
                            Text('欢迎来到中犇商城', style: titleStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(56),
                  ),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameCtrl,
                          keyboardType: TextInputType.text,
                          maxLength: 12,
                          style: TextStyle(color: Colors.white60),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone_iphone,
                              color: Colors.white60,
                            ),
                            hintText: '请输入昵称',
                            hintStyle: TextStyle(color: Colors.white60),
                          ),
                        ),
                        TextFormField(
                          controller: _passCtrl,
                          keyboardType: TextInputType.visiblePassword,
                          maxLength: 12,
                          style: TextStyle(color: Colors.white60),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.white60,
                            ),
                            hintText: '请输入密码(6~12位)',
                            hintStyle: TextStyle(color: Colors.white60),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(56),
                    right: ScreenUtil().setWidth(56),
                    top: ScreenUtil().setWidth(50),
                  ),
                  child: Opacity(
                    opacity: 0.73,
                    child: Container(
                      width: ScreenUtil().setWidth(638),
                      height: ScreenUtil().setWidth(88),
                      child: RaisedButton(
                        child: Text('注 册', style: lgStyle),
                        color: Theme.of(context).accentColor,
                        onPressed: register,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() async {
    if (loading) {
      return;
    }
    if (_nameCtrl.text.trim().isEmpty) {
      BotToast.showText(text: '请输入昵称');
      return;
    }
    if (_passCtrl.text.trim().isEmpty) {
      BotToast.showText(text: '请输入密码');
      return;
    }
    loading = true;
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    var result =
        await userModel.register(_nameCtrl.text.trim(), _passCtrl.text.trim());
    if (result != null) {
      BotToast.showText(text: '注册成功');
      Future.delayed(Duration(milliseconds: 800), () {
        Application.router.pop(context);
      });
    }
    loading = false;
  }
}
