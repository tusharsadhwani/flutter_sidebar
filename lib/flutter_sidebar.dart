library flutter_sidebar;

import 'package:flutter/material.dart';

import 'custom_expansion_tile.dart';

class Sidebar extends StatefulWidget {
  final List<Map<String, dynamic>> tabs;

  const Sidebar({Key key, @required this.tabs}) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  List<int> activeTabIndices = [];

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
              itemBuilder: (BuildContext context, int index) =>
                  SidebarItem(widget.tabs[index]),
              itemCount: widget.tabs.length,
            ),
          )
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  const SidebarItem(this.data);

  final Map<String, dynamic> data;

  Widget _buildTiles(Map<String, dynamic> root) {
    if (root['children'] == null)
      return ListTile(
        title: Text(root['title']),
        onTap: () {},
      );

    List<Widget> children = [];
    for (Map<String, dynamic> item in root['children']) {
      children.add(_buildTiles(item));
    }

    return CustomExpansionTile(
      title: Text(root['title']),
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(data);
  }
}
