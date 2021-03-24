import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sidebar/flutter_sidebar.dart';

void main() {
  test('adds one to input values', () {
    final sidebar = Sidebar.fromJson(
      tabs: [],
    );
    expect(sidebar.runtimeType, Sidebar);
  });

  testWidgets('activeTabIndices parameter', (WidgetTester tester) async {
    final sidebar = Sidebar.fromJson(
      tabs: [
        {
          'title': 'Chapter A',
        },
        {
          'title': 'Chapter B',
        }
      ],
      activeTabIndices: [1],
    );
    await tester.pumpWidget(MaterialApp(
      home: sidebar,
    ));
    await tester.pumpAndSettle();

    Finder finder = find.byWidgetPredicate((w) {
      if (w is ListTile && w.selected) {
        final text = w.title as Text;
        if (text.data == 'Chapter B') return true;
      }
      return false;
    });
    expect(finder, findsOneWidget);
  });
}
