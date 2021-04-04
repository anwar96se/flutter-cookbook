import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const title = 'Send data to the internet';
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

  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: (_futureAlbum == null) ? _buildForm() : _buildResult(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _inputController,
          decoration: InputDecoration(hintText: 'Enter Title'),
        ),
        SizedBox(height: 16),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _futureAlbum = createAlbum(_inputController.text);
              });
            },
            child: Text('Create Data'))
      ],
    );
  }

  Widget _buildResult() {
    return FutureBuilder<Album>(
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
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<Album> createAlbum(String title) async {
    final response = await http.post(
      Uri.parse(baseURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
      }),
    );
    if (response.statusCode == 201) {
      print(response.body);
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
