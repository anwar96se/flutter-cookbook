import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const title = 'Store key-value data on disk';

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

  Future<void> _incrementCounter() {
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
  static const _counterKey = 'counter';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  Future<int> readCounter() async {
    try {
      final prefs = await _prefs;
      return prefs.getInt(_counterKey);
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<void> writeCounter(int counter) async {
    final prefs = await _prefs;
    prefs.setInt(_counterKey, counter);
  }
}
