import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const title = 'Delete data on the internet';
const String baseURL = 'https://jsonplaceholder.typicode.com/albums/';

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
  Future<Album> _futureAlbum;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum('1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
            child: FutureBuilder<Album>(
          future: _futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var album = snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(album.title ?? 'Deleted'),
                    SizedBox(
                      height: 50.0,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _futureAlbum = deleteAlbum(album.id.toString());
                          });
                        },
                        child: Text('Delete')),
                  ],
                );
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

  Future<Album> deleteAlbum(String id) async {
    final response = await http.delete(
      Uri.parse(baseURL + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return Album.fromResponse(response.body);
    } else {
      throw Exception('Failed to delete album');
    }
  }

  Future<Album> fetchAlbum(String id) async {
    final response = await http.get(Uri.parse(baseURL + id));
    if (response.statusCode == 200) {
      return Album.fromResponse(response.body);
    } else {
      throw Exception('Failed to fetch album');
    }
  }
}

class Album {
  final int id;
  final String title;

  Album({this.id, this.title});

  factory Album.fromResponse(String response) {
    return Album.fromJson(jsonDecode(response));
  }

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(id: json['id'], title: json['title']);
  }
}
