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
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  static const _mobileThreshold = 700.0;
  bool isMobile = false;
  bool sidebarOpen = false;

  AnimationController _animationController;

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
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    Future.delayed(Duration.zero, () {
      final mediaQuery = MediaQuery.of(context);
      setState(() {
        isMobile = mediaQuery.size.width < _mobileThreshold;
        sidebarOpen = !isMobile;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      sidebarOpen = !sidebarOpen;
      if (sidebarOpen)
        _animationController.forward();
      else
        _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    const _textStyle = TextStyle(fontSize: 26);
    final sidebar = Sidebar(
      tabData,
      key: ValueKey(sidebarOpen), //TODO: prevent rebuilds on sidebarOpen change
      isOpen: sidebarOpen,
      setTab: setTab,
    );
    final mainContent = Center(
      child: tab != null
          ? Text.rich(
              TextSpan(
                text: 'Selected tab: ',
                style: _textStyle,
                children: [
                  TextSpan(
                    text: '$tab',
                    style: _textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Text(
              'No tab selected',
              style: _textStyle,
            ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu), onPressed: _toggleSidebar),
        title: Text('Flutter Sidebar'),
      ),
      body: isMobile
          ? Stack(children: [
              mainContent,
              AnimatedBuilder(
                animation: _animationController,
                builder: (_, __) => _animationController.value > 0
                    ? GestureDetector(
                        onTap: _toggleSidebar,
                        child: Container(
                          color: Colors.black.withAlpha(
                              (150 * _animationController.value).toInt()),
                        ),
                      )
                    : IgnorePointer(),
              ),
              sidebar,
            ])
          : Row(
              children: [
                sidebar,
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
