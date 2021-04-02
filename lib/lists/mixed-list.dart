import 'package:flutter/material.dart';

final title = 'Create lists with different types of items';

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
  final _items = List<ListItem>.generate(
      100,
      (index) => index % 6 == 0
          ? HeaderListItem('Header $index')
          : MessageListItem('Sender $index', 'Message body $index'));

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          ListItem item = _items[index];
          return ListTile(
            title: item.buildTitle(context),
            subtitle: item.buildSubTitle(context),
          );
        },
      ),
    );
  }
}

abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubTitle(BuildContext context);
}

class HeaderListItem extends ListItem {
  HeaderListItem(this.header);

  final String header;

  @override
  Widget buildTitle(BuildContext context) => Text(
        header,
        style: Theme.of(context).textTheme.headline4,
      );

  @override
  Widget buildSubTitle(BuildContext context) => null;
}

class MessageListItem extends ListItem {
  MessageListItem(this.sender, this.body);

  final String sender;
  final String body;

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubTitle(BuildContext context) => Text(body);
}
