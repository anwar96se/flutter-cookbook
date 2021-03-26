import 'package:flutter/material.dart';

final title = 'Export fonts from a package';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Using the Exo2 font from the awesome_package',
          style: TextStyle(fontFamily: 'Exo2'),
        ),
      ),
    );
  }
}
