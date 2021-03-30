import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

final title = 'Create gradient chat bubbles';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Message> data;

  @override
  void initState() {
    super.initState();
    data = MessageGenerator.generate(60, 1337);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF4F4F4F),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          reverse: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final message = data[index];
            return MessageBubble(
              message: message,
              child: Text(message.text),
            );
          },
        ),
      ),
    );
  }
}

enum MessageOwner { myself, other }

@immutable
class Message {
  const Message({
    this.owner,
    this.text,
  });

  final MessageOwner owner;
  final String text;

  bool get isMine => owner == MessageOwner.myself;
}

class MessageGenerator {
  static List<Message> generate(int count, [int seed]) {
    final random = Random(seed);
    return List.unmodifiable(List<Message>.generate(count, (index) {
      return Message(
        owner: random.nextBool() ? MessageOwner.myself : MessageOwner.other,
        text: _exampleData[random.nextInt(_exampleData.length)],
      );
    }));
  }

  static final _exampleData = [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'In tempus mauris at velit egestas, sed blandit felis ultrices.',
    'Ut molestie mauris et ligula finibus iaculis.',
    'Sed a tempor ligula.',
    'Test',
    'Phasellus ullamcorper, mi ut imperdiet consequat, nibh augue condimentum nunc, vitae molestie massa augue nec erat.',
    'Donec scelerisque, erat vel placerat facilisis, eros turpis egestas nulla, a sodales elit nibh et enim.',
    'Mauris quis dignissim neque. In a odio leo. Aliquam egestas egestas tempor. Etiam at tortor metus.',
    'Quisque lacinia imperdiet faucibus.',
    'Proin egestas arcu non nisl laoreet, vitae iaculis enim volutpat. In vehicula convallis magna.',
    'Phasellus at diam a sapien laoreet gravida.',
    'Fusce maximus fermentum sem a scelerisque.',
    'Nam convallis sapien augue, malesuada aliquam dui bibendum nec.',
    'Quisque dictum tincidunt ex non lobortis.',
    'In hac habitasse platea dictumst.',
    'Ut pharetra ligula libero, sit amet imperdiet lorem luctus sit amet.',
    'Sed ex lorem, lacinia et varius vitae, sagittis eget libero.',
    'Vestibulum scelerisque velit sed augue ultricies, ut vestibulum lorem luctus.',
    'Pellentesque et risus pretium, egestas ipsum at, facilisis lectus.',
    'Praesent id eleifend lacus.',
    'Fusce convallis eu tortor sit amet mattis.',
    'Vivamus lacinia magna ut urna feugiat tincidunt.',
    'Sed in diam ut dolor imperdiet vehicula non ac turpis.',
    'Praesent at est hendrerit, laoreet tortor sed, varius mi.',
    'Nunc in odio leo.',
    'Praesent placerat semper libero, ut aliquet dolor.',
    'Vestibulum elementum leo metus, vitae auctor lorem tincidunt ut.',
  ];
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key key,
    this.message,
    this.child,
  }) : super(key: key);

  final Message message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final messageAlignment =
        message.isMine ? Alignment.topLeft : Alignment.topRight;
    return FractionallySizedBox(
      alignment: messageAlignment,
      widthFactor: 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: BubbleBackground(
            colors: message.isMine
                ? [const Color(0xFF6C7689), const Color(0xFF3A364B)]
                : [const Color(0xFF19B7FF), const Color(0xFF491CCB)],
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BubbleBackground extends StatelessWidget {
  const BubbleBackground({
    Key key,
    this.bubbleContext,
    this.scrollable,
    this.colors,
    this.child,
  }) : super(key: key);

  final BuildContext bubbleContext;
  final ScrollableState scrollable;
  final List<Color> colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        bubbleContext: context,
        scrollable: Scrollable.of(context),
        colors: colors,
      ),
      child: child,
    );
  }
}

class BubblePainter extends CustomPainter {
  BubblePainter({
    BuildContext bubbleContext,
    ScrollableState scrollable,
    List<Color> colors,
  })  : _bubbleContext = bubbleContext,
        _scrollable = scrollable,
        _colors = colors;

  final BuildContext _bubbleContext;
  final ScrollableState _scrollable;
  final List<Color> _colors;

  @override
  void paint(Canvas canvas, Size size) {
    final scrollableBox = _scrollable.context.findRenderObject() as RenderBox;
    final scrollableRect = Offset.zero & scrollableBox.size;
    final bubbleBox = _bubbleContext.findRenderObject() as RenderBox;

    final origin =
        bubbleBox.localToGlobal(Offset.zero, ancestor: scrollableBox);
    Paint paint = Paint()
      ..shader = ui.Gradient.linear(
        scrollableRect.topCenter,
        scrollableRect.bottomCenter,
        _colors,
        [0.0, 1.0],
        TileMode.clamp,
        Matrix4.translationValues(-origin.dx, -origin.dy, 0.0).storage,
      );
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    return oldDelegate._bubbleContext != _bubbleContext ||
        oldDelegate._scrollable != _scrollable ||
        oldDelegate._colors != _colors;
  }
}
