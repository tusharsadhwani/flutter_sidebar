import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

import 'package:flutter_sidebar/flutter_sidebar.dart';

void main() {
  runApp(DevicePreview(builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const title = 'Flutter Sidebar Test';

    return MaterialApp(
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.of(context).locale,
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          Sidebar(
            tabs: ['Home', 'Browse', 'Help', 'Settings'],
          ),
        ],
      ),
    );
  }
}