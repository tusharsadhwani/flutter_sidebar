import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_sidebar/flutter_sidebar.dart';

void main() {
  test('adds one to input values', () {
    final sidebar = Sidebar(
      tabs: [],
    );
    expect(sidebar.runtimeType, Sidebar);
  });
}
