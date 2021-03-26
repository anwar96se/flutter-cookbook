import 'package:flutter/material.dart';

final title = 'Use a custom font';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Custom App Fonts'),
            SizedBox(
              height: 50.0,
            ),
            Text(
              'RobotoMono Font',
              style: TextStyle(fontFamily: 'RobotoMono'),
            ),
          ],
        ),
      ),
    );
  }
}
