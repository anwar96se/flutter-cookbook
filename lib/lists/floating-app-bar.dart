import 'package:flutter/material.dart';

final title = 'Place a floating app bar above a list';

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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(title),
            floating: true,
            flexibleSpace: Image.network(
              'https://picsum.photos/250?image=9',
              fit: BoxFit.cover,
            ),
            expandedHeight: 200,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text(_items[index]),
              ),
              childCount: _items.length,
            ),
          ),
        ],
      ),
    );
  }
}
