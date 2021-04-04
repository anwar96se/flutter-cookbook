import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const title = 'Parse JSON in the background';
const String baseURL = 'https://jsonplaceholder.typicode.com/photos/';

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client.get(Uri.parse(baseURL));
  if (response.statusCode == 200) {
    return compute(parsePhotos, response.body);
  } else {
    throw Exception('Failed to fetch photo');
  }
}

List<Photo> parsePhotos(String response) {
  final parsed = jsonDecode(response).cast<Map<String, dynamic>>();
  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
            child: FutureBuilder<List<Photo>>(
          future: fetchPhotos(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return PhotoList(photos: snapshot.data);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            }
            return CircularProgressIndicator();
          },
        )),
      ),
    );
  }

}

class PhotoList extends StatelessWidget {
  final List<Photo> photos;

  const PhotoList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return Image.network(photos[index].thumbnailUrl);
        },
        itemCount: photos.length);
  }
}

class Photo {
  final int id;
  final String title;
  final String thumbnailUrl;

  Photo({this.id, this.title, this.thumbnailUrl});

  factory Photo.fromResponse(String response) {
    return Photo.fromJson(jsonDecode(response));
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}
