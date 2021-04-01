import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

final title = 'Images';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildNetworkImage(),
              SizedBox(height: 16),
              _buildFadeImage(),
              SizedBox(height: 16),
              _buildCachedImage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkImage() {
    return SizedBox(
      height: 250,
      child: Image.network('https://picsum.photos/250?image=9'),
    );
  }

  Widget _buildFadeImage() {
    return SizedBox(
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: CircularProgressIndicator(),
          ),
          Center(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: 'https://picsum.photos/250?image=9',
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCachedImage() {
    return SizedBox(
      child: CachedNetworkImage(
        imageUrl: 'https://picsum.photos/250?image=9',
        placeholder: (context, url) =>
            SizedBox(child: CircularProgressIndicator()),
      ),
    );
  }
}
