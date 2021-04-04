import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const title = 'Work with WebSockets';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(fontFamily: 'Raleway'),
      home: HomePage(
        channel: IOWebSocketChannel.connect(Uri.parse('wss://echo.websocket.org')),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final WebSocketChannel channel;

  const HomePage({Key key, this.channel}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        tooltip: 'Send message',
        onPressed: _sendMessage,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _inputController,
                decoration: InputDecoration(hintText: 'Enter Title'),
              ),
              SizedBox(height: 24),
              StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? '${snapshot.data}' : '');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sendMessage() {
    if (_inputController.text.isNotEmpty)
      widget.channel.sink.add(_inputController.text);
  }
}
