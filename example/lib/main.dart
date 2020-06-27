import 'package:flutter/material.dart';

import 'package:flutter_sidebar/flutter_sidebar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const title = 'Flutter Sidebar Test';

    return MaterialApp(
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
  static const _mobileThreshold = 700.0;
  bool isMobile = false;
  bool sidebarOpen = false;

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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final mediaQuery = MediaQuery.of(context);
      setState(() {
        isMobile = mediaQuery.size.width < _mobileThreshold;
        sidebarOpen = isMobile;
      });
    });
  }

  void _toggleSidebar() {
    setState(() {
      sidebarOpen = !sidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    const _textStyle = TextStyle(fontSize: 26);
    final sidebar = Sidebar(
      tabData,
      key: ValueKey(sidebarOpen),
      isOpen: sidebarOpen,
      setTab: setTab,
    );
    final mainContent = Center(
      child: tab != null
          ? Text(
              'Selected tab: $tab',
              style: _textStyle,
            )
          : Text(
              'No tab selected',
              style: _textStyle,
            ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu), onPressed: _toggleSidebar),
        title: Text(widget.title),
      ),
      body: isMobile
          ? Stack(children: [mainContent, sidebar])
          : Row(
              children: [
                sidebar,
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
