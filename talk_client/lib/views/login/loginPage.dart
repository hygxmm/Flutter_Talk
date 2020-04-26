import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talk_client/application.dart';
import 'package:talk_client/providers/user.dart';
import '../../utils/style.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _passCtrl = TextEditingController();
  bool loading = false;

  void login() async {
    if (loading) {
      return;
    }
    if (_nameCtrl.text.trim() == '') {
      BotToast.showText(text: '请输入昵称');
      return;
    }
    if (_passCtrl.text.trim() == '') {
      BotToast.showText(text: '请输入密码');
      return;
    }
    loading = true;
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    var res =
        await userModel.login(_nameCtrl.text.trim(), _passCtrl.text.trim());
    if (res != null) {
      BotToast.showText(text: '登录成功');
      Future.delayed(Duration(milliseconds: 800), () {
        Application.router.navigateTo(context, '/main', replace: true);
      });
    } else {
      BotToast.showText(text: '账号或密码错误');
    }
  }

  void toRegister() {
    Application.router.navigateTo(context, '/register');
  }

  void forgetpassword() {
    Application.router.navigateTo(context, '/forgetPassword');
  }

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
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(750),
                  height: ScreenUtil().setWidth(430),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(56)),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('您好,', style: titleStyle),
                      Text('欢迎来到星网', style: titleStyle),
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
                              Icons.person,
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
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(50),
                          ),
                          child: Opacity(
                            opacity: 0.73,
                            child: Container(
                              width: ScreenUtil().setWidth(638),
                              height: ScreenUtil().setWidth(88),
                              child: RaisedButton(
                                child: Text('登 录', style: lgStyle),
                                color: Theme.of(context).accentColor,
                                onPressed: login,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                child: Text('注册账号', style: smStyle),
                                onTap: toRegister,
                              ),
                              Text('  |  ', style: smStyle),
                              InkWell(
                                child: Text('忘记密码', style: smStyle),
                                onTap: forgetpassword,
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
