library flutter_sidebar;

import 'dart:math';

import 'package:flutter/material.dart';

import 'custom_expansion_tile.dart';

class Sidebar extends StatefulWidget {
  final List<Map<String, dynamic>> tabs;
  final void Function(String) onTabChanged;
  final List<int> activeTabIndices;

  // const Sidebar({
  //   Key key,
  //   @required this.tabs,
  //   this.onTabChanged,
  //   this.activeTabIndices,
  // }) : super(key: key);

  const Sidebar.fromJson({
    Key key,
    @required this.tabs,
    this.onTabChanged,
    this.activeTabIndices,
  }) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  static const double _maxSidebarWidth = 300;
  double _sidebarWidth = _maxSidebarWidth;
  List<int> activeTabIndices;

  void setActiveTabIndices(List<int> newIndices) {
    setState(() {
      activeTabIndices = newIndices;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    _sidebarWidth = min(mediaQuery.size.width * 0.7, _maxSidebarWidth);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      width: _sidebarWidth,
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: Container(color: Theme.of(context).primaryColor),
          ),
          Expanded(
            child: Material(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) => SidebarItem(
                  widget.tabs[index],
                  widget.onTabChanged,
                  activeTabIndices,
                  setActiveTabIndices,
                  index: index,
                ),
                itemCount: widget.tabs.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final void Function(String) onTabChanged;
  final List<int> activeTabIndices;
  final void Function(List<int> newIndices) setActiveTabIndices;
  final int index;
  final List<int> indices;

  const SidebarItem(
    this.data,
    this.onTabChanged,
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
        contentPadding:
            EdgeInsets.only(left: 16.0 + 20.0 * (_indices.length - 1)),
        title: Text(root['title']),
        onTap: () {
          setActiveTabIndices(_indices);
          if (onTabChanged != null) onTabChanged(root['id'] ?? root['title']);
        },
      );

    List<Widget> children = [];
    for (int i = 0; i < root['children'].length; i++) {
      Map<String, dynamic> item = root['children'][i];
      final itemIndices = [..._indices, i];
      children.add(
        SidebarItem(
          item,
          onTabChanged,
          activeTabIndices,
          setActiveTabIndices,
          indices: itemIndices,
        ),
      );
    }

    return CustomExpansionTile(
      tilePadding: EdgeInsets.only(
        left: 16.0 + 20.0 * (_indices.length - 1),
        right: 12.0,
      ),
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
