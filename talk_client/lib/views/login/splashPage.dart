import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talk_client/application.dart';
import 'package:talk_client/providers/user.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 500), () {
          navTo();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void navTo() {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    userModel.initUser();
    if (userModel.user != null) {
      Application.router.navigateTo(context, '/main', replace: true);
    } else {
      Application.router.navigateTo(context, '/login', replace: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    _controller.forward();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: FadeTransition(
          opacity: _animation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.tealAccent,
              image: DecorationImage(
                image: AssetImage('assets/images/splash.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
