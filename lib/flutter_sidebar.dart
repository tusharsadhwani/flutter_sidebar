library flutter_sidebar;

import 'dart:math';

import 'package:flutter/material.dart';

import 'custom_expansion_tile.dart';

class Sidebar extends StatefulWidget {
  final List<Map<String, dynamic>> tabs;
  final List<int> activeTabIndices;
  final Function(List<int> tabIndices) selectTab;

  const Sidebar(this.tabs, [this.activeTabIndices, this.selectTab]);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  List<int> activeTabIndices;

  void setActiveTabIndices(List<int> newIndices) {
    setState(() {
      activeTabIndices = newIndices;
    });
  }

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
              itemBuilder: (BuildContext context, int index) => SidebarItem(
                widget.tabs[index],
                activeTabIndices,
                setActiveTabIndices,
                index: index,
              ),
              itemCount: widget.tabs.length,
            ),
          )
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<int> activeTabIndices;
  final void Function(List<int> newIndices) setActiveTabIndices;
  final int index;
  final List<int> indices;

  const SidebarItem(
    this.data,
    this.activeTabIndices,
    this.setActiveTabIndices, {
    this.index,
    this.indices,
  }) : assert(
          (index == null && indices != null) ||
              (index != null && indices == null),
          'Exactly one parameter out of [index, indices] has to be provided',
        );

  bool _indicesMatch(List<int> a, List<int> b) {
    for (int i = 0; i < min(a.length, b.length); i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Widget _buildTiles(Map<String, dynamic> root) {
    final _indices = indices ?? [index];
    if (root['children'] == null)
      return ListTile(
        selected: activeTabIndices != null &&
            _indicesMatch(_indices, activeTabIndices),
        title: Text(root['title']),
        onTap: () => setActiveTabIndices(_indices),
      );

    List<Widget> children = [];
    for (int i = 0; i < root['children'].length; i++) {
      Map<String, dynamic> item = root['children'][i];
      final itemIndices = [..._indices, i];
      children.add(SidebarItem(item, activeTabIndices, setActiveTabIndices,
          indices: itemIndices));
    }

    return CustomExpansionTile(
      selected:
          activeTabIndices != null && _indicesMatch(_indices, activeTabIndices),
      title: Text(root['title']),
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(data);
  }
}
