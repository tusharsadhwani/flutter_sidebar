import 'package:flutter/material.dart';
// import 'package:device_preview/device_preview.dart';

import 'package:flutter_sidebar/flutter_sidebar.dart';

void main() {
  // runApp(DevicePreview(builder: (context) => MyApp()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const title = 'Flutter Sidebar Test';

    return MaterialApp(
      // builder: DevicePreview.appBuilder,
      // locale: DevicePreview.of(context).locale,
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
  final List<Map<String, dynamic>> tabData = [
    {
      'title': 'Chapter A',
      'children': [
        {'title': 'Chapter A1'},
        {'title': 'Chapter A2'},
      ],
    },
    {
      'title': 'Chapter B',
      'children': [
        {'title': 'Chapter B1'},
        {
          'title': 'Chapter B2',
          'children': [
            {'title': 'Chapter B2a'},
            {'title': 'Chapter B2b'},
          ],
        },
      ],
    },
    {'title': 'Chapter C'},
  ];
  String tab;
  void setTab(String newTab) {
    setState(() {
      tab = newTab;
    });
  }

  @override
  Widget build(BuildContext context) {
    const _textStyle = TextStyle(fontSize: 26);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          Sidebar(tabData, setTab: setTab),
          Expanded(
            child: Center(
              child: tab != null
                  ? Text(
                      'Selected tab: $tab',
                      style: _textStyle,
                    )
                  : Text(
                      'No tab selected',
                      style: _textStyle,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
