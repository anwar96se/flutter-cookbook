import 'package:flutter/material.dart';

const title = 'Animate a widget across screens';

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
      body: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailsPage();
          }));
        },
        child: SizedBox(
          width: 250,
          child: Hero(
            tag: 'image',
            child: Image.network('https://picsum.photos/250?image=9'),
          ),
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: SizedBox(
          width: 400,
          child: Hero(
            tag: 'image',
            child: Image.network(
              'https://picsum.photos/250?image=9',
              fit: BoxFit.cover,
            ),
          ),
        ),
      )),
    );
  }
}
