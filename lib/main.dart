import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Cookbook')),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
                'This cookbook contains recipes that demonstrate how to solve common problems while writing Flutter apps. Each recipe is self-contained and can be used as a reference to help you build up an application.'),
          ),
        ),
      ),
    );
  }
}
