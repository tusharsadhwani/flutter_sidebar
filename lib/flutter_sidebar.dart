library flutter_sidebar;

import 'dart:math';

import 'package:flutter/material.dart';

import 'custom_expansion_tile.dart';

class Sidebar extends StatefulWidget {
  final List<Map<String, dynamic>> tabs;
  final void Function(String) setTab;
  final bool isOpen;
  final List<int> activeTabIndices;

  const Sidebar(
    this.tabs, {
    Key key,
    this.activeTabIndices,
    this.setTab,
    this.isOpen,
  }) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  static const double _maxSidebarWidth = 300;
  double _sidebarWidth = _maxSidebarWidth;
  List<int> activeTabIndices;
  AnimationController _animationController;
  Animation _animation;

  void setActiveTabIndices(List<int> newIndices) {
    setState(() {
      activeTabIndices = newIndices;
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: widget.isOpen ? 1 : 0,
    );
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutQuad);
    if (!widget.isOpen)
      _animationController.forward();
    else
      _animationController.reverse();

    Future.delayed(Duration.zero, () {
      final mediaQuery = MediaQuery.of(context);
      _sidebarWidth = min(mediaQuery.size.width * 0.7, _maxSidebarWidth);
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => ClipRect(
        child: SizedOverflowBox(
          size: Size(_sidebarWidth * _animation.value, double.infinity),
          child: Container(
            color: Colors.white,
            width: _sidebarWidth,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Container(color: Colors.blue),
                ),
                Expanded(
                  child: Material(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) =>
                          SidebarItem(
                        widget.tabs[index],
                        widget.setTab,
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
          ),
        ),
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final void Function(String) setTab;
  final List<int> activeTabIndices;
  final void Function(List<int> newIndices) setActiveTabIndices;
  final int index;
  final List<int> indices;

  const SidebarItem(
    this.data,
    this.setTab,
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
        onTap: () {
          setActiveTabIndices(_indices);
          setTab(root['title']);
        },
      );

    List<Widget> children = [];
    for (int i = 0; i < root['children'].length; i++) {
      Map<String, dynamic> item = root['children'][i];
      final itemIndices = [..._indices, i];
      children.add(
        SidebarItem(
          item,
          setTab,
          activeTabIndices,
          setActiveTabIndices,
          indices: itemIndices,
        ),
      );
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
