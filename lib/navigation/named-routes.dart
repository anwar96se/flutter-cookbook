import 'package:flutter/material.dart';

const title = 'Navigate with named routes';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(fontFamily: 'Raleway'),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/details': (context) => DetailsPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/details');
          },
          child: Text('Navigate'),
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
          child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Go Back!'),
      )),
    );
  }
}
