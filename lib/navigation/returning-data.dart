import 'package:flutter/material.dart';

const title = 'Return data from a screen';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(fontFamily: 'Raleway'),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        SelectPage.routName: (context) => SelectPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _selectGender(context),
              child: Text('Navigate'),
            ),
          ],
        ),
      ),
    );
  }

  _selectGender(BuildContext context) async {
    final result = await Navigator.pushNamed(context, SelectPage.routName);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$result')));
  }
}

class SelectPage extends StatelessWidget {
  static const routName = '/select';
  final _items = ['Male', 'Female'];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gender')),
      body: Center(
        child: ListView.builder(
          itemBuilder: _buildItem,
          itemCount: _items.length,
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, _items[index]);
      },
      child: ListTile(title: Text(_items[index])),
    );
  }
}
