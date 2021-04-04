import 'package:flutter/material.dart';

const title = 'Send data to a new screen';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(fontFamily: 'Raleway'),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        DetailsPage.routName: (context) => DetailsPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final _items = List<DetailsArgs>.generate(
      100,
      (index) => DetailsArgs('ToDo ${index + 1}',
          'A description od what needs to be done for ToDo ${index + 1}'));

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemBuilder: _buildItem,
        itemCount: _items.length,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailsPage.routName,
          arguments: _items[index],
        );
      },
      child: ListTile(title: Text(_items[index].title)),
    );
  }
}

class DetailsPage extends StatelessWidget {
  static const routName = '/details';

  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context).settings.arguments as DetailsArgs;
    return Scaffold(
      appBar: AppBar(title: Text(arguments.title)),
      body: Center(
        child: Text(arguments.message),
      ),
    );
  }
}

class DetailsArgs {
  final String title;
  final String message;

  DetailsArgs(this.title, this.message);
}
