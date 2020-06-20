library flutter_sidebar;

import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  final List<String> tabs;

  const Sidebar({Key key, @required this.tabs}) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      width: 300,
      constraints: BoxConstraints(
        maxWidth: mediaQuery.size.width * 0.7,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Container(color: Colors.blue),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  setState(() {
                    activeTab = index;
                  });
                },
                title: Text(widget.tabs[index]),
                selected: index == activeTab,
              ),
              itemCount: widget.tabs.length,
            ),
          )
        ],
      ),
    );
  }
}
