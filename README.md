# flutter_sidebar

An easy to configure sidebar widget for your flutter mobile/web apps

![2020-06-29-225932_1124x667_scrot](https://user-images.githubusercontent.com/43412083/86037559-285b0500-ba5d-11ea-9b1d-0d690b7b3aae.png)

## Usage

```dart
import 'package:flutter_sidebar/flutter_sidebar.dart';
```

Simple Sidebar with few sidebar items:

```dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Sidebar')),
      drawer: Sidebar(
        [
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
        ],
      ),
    );
  }
}
```
