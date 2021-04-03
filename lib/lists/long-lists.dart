import 'package:flutter/material.dart';

final title = 'Work with long lists';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(fontFamily: 'Raleway'),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final _items = List<String>.generate(100, (index) => 'Item ${index + 1}');

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView.builder(
          itemBuilder: (context, index) => ListTile(
            title: Text(_items[index]),
          ),
          itemCount: _items.length,
        ));
  }
}
