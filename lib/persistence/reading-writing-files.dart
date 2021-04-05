import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as provider;

const title = 'Use a custom font';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: 'Raleway'),
      home: HomePage(storage: CounterStorage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.storage}) : super(key: key);

  final CounterStorage storage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });
    return widget.storage.writeCounter(_counter);
  }

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        _counter = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontFamily: 'Exo2'),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final dir = await provider.getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      var contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }
}
