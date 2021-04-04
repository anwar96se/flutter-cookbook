import 'package:flutter/material.dart';

const title = 'Pass arguments to a named route';

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
      onGenerateRoute: (settings) {
        if (settings.name == DetailsAdvancedPage.routName) {
          final DetailsArgs args = settings.arguments as DetailsArgs;
          return MaterialPageRoute(builder: (context) {
            return DetailsAdvancedPage(
              title: args.title,
              message: args.message,
            );
          });
        }
        return null;
      },
    );
  }
}

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  DetailsPage.routName,
                  arguments: DetailsArgs(
                    'Extract Arguments Screen',
                    'This message is extracted in the build method.',
                  ),
                );
              },
              child: Text('Navigate'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  DetailsAdvancedPage.routName,
                  arguments: DetailsArgs(
                    'Extract Arguments Screen',
                    'This message is extracted in the build method.',
                  ),
                );
              },
              child: Text('Navigate Advanced'),
            ),
          ],
        ),
      ),
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

class DetailsAdvancedPage extends StatelessWidget {
  const DetailsAdvancedPage({Key key, this.title, this.message})
      : super(key: key);

  static const routName = '/details_advanced';

  final String title;
  final String message;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('Advanced\n$message'),
      ),
    );
  }
}

class DetailsArgs {
  final String title;
  final String message;

  DetailsArgs(this.title, this.message);
}
