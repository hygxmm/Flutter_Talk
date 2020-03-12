import 'package:flutter/material.dart';

class MomentPage extends StatefulWidget {
  @override
  _MomentPageState createState() => _MomentPageState();
}

class _MomentPageState extends State<MomentPage> {
  @override
  Widget build(BuildContext context) {
    print("动态页 build");
    return Scaffold(
      appBar: AppBar(
        title: Text('动态'),
        centerTitle: true,
      ),
    );
  }
}
