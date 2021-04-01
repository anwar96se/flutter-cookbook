import 'package:flutter/material.dart';

final title = 'Gestures';

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
  final _items = List<String>.generate(20, (index) => 'Item $index');

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () => ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Oh yeah!'))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Fuck me'),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onDoubleTap: () => ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Oh yeah!'))),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.all(12.0),
                child: Text('Fuck me twice'),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Oh yeah!'))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Fuck me'),
              ),
            ),
            _buildDismissibleList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissibleList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Dismissible(
            key: Key(item),
            onDismissed: (direction) {
              setState(() {
                final removeItem = _items.removeAt(index);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$removeItem removed'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      setState(() {
                        _items.insert(index, removeItem);
                      });
                    },
                  ),
                ));
              });
            },
            background: Container(color: Colors.red),
            child: ListTile(title: Text(item)),
          );
        },
      ),
    );
  }
}
