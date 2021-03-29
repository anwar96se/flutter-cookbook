import 'dart:math';

import 'package:flutter/material.dart';

const title = 'Create a typing indicator';

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
  bool _isSomeoneTyping = false;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Expanded(
            child: _buildMessages(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: TypingIndicator(
              showIndicator: _isSomeoneTyping,
            ),
          ),
          _buildIsTypingSimulator(),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: 25,
      reverse: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 100.0),
          child: FakeMessage(isBig: index.isOdd),
        );
      },
    );
  }

  Widget _buildIsTypingSimulator() {
    return Container(
      color: Colors.grey,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Switch(
          onChanged: (newValue) {
            setState(() {
              _isSomeoneTyping = newValue;
            });
          },
          value: _isSomeoneTyping,
        ),
      ),
    );
  }
}

@immutable
class FakeMessage extends StatelessWidget {
  const FakeMessage({
    Key key,
    this.isBig,
  }) : super(key: key);

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      height: isBig ? 128.0 : 36.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey.shade300,
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    this.showIndicator = false,
    this.bubbleColor = const Color(0xFF646b7f),
    this.flashingCircleDarkColor = const Color(0xFF333333),
    this.flashingCircleBrightColor = const Color(0xFFaec1dd),
  });

  final bool showIndicator;
  final Color bubbleColor;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  AnimationController _appearanceController;

  Animation<double> _indicatorSpaceAnimation;
  Animation<double> _smallBubbleAnimation;
  Animation<double> _mediumBubbleAnimation;
  Animation<double> _largeBubbleAnimation;

  AnimationController _repeatingController;
  final List<Interval> _dotIntervals = const [
    Interval(0.25, 0.8),
    Interval(0.35, 0.9),
    Interval(0.45, 1.0),
  ];

  @override
  void initState() {
    super.initState();
    _appearanceController = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {});
      });
    _indicatorSpaceAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 0.1, curve: Curves.easeOut),
    ).drive(Tween<double>(begin: 0.0, end: 60.0));

    _smallBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );

    _mediumBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );

    _largeBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _repeatingController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));

    if (widget.showIndicator) {
      _showIndicator();
    }
  }

  @override
  void dispose() {
    _appearanceController?.dispose();
    _repeatingController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showIndicator != oldWidget.showIndicator) {
      if (widget.showIndicator)
        _showIndicator();
      else
        _hideIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appearanceController,
      builder: (context, child) => SizedBox(
        height: _indicatorSpaceAnimation.value,
        child: child,
      ),
      child: Stack(
        children: <Widget>[
          _buildAnimatedBubble(
              animation: _smallBubbleAnimation,
              left: 8,
              bottom: 8,
              bubble: _buildCircleBubble(8)),
          _buildAnimatedBubble(
              animation: _mediumBubbleAnimation,
              left: 10,
              bottom: 10,
              bubble: _buildCircleBubble(16)),
          _buildAnimatedBubble(
              animation: _largeBubbleAnimation,
              left: 12,
              bottom: 12,
              bubble: _buildStatusBubble()),
        ],
      ),
    );
  }

  Widget _buildAnimatedBubble({
    Animation<double> animation,
    double left,
    double bottom,
    Widget bubble,
  }) {
    return Positioned(
      left: left,
      bottom: bottom,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(
            scale: animation.value,
            alignment: Alignment.bottomLeft,
            child: child,
          );
        },
        child: bubble,
      ),
    );
  }

  Widget _buildCircleBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: widget.bubbleColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildStatusBubble() {
    return Container(
      width: 85,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        color: widget.bubbleColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildFlashingCircle(0),
          _buildFlashingCircle(1),
          _buildFlashingCircle(2),
        ],
      ),
    );
  }

  Widget _buildFlashingCircle(int index) {
    return AnimatedBuilder(
      animation: _repeatingController,
      builder: (context, child) {
        final circleFlashPercent =
            _dotIntervals[index].transform(_repeatingController.value);
        final circleColorPercent = sin(pi * circleFlashPercent);
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.lerp(widget.flashingCircleDarkColor,
                  widget.flashingCircleBrightColor, circleColorPercent)),
        );
      },
    );
  }

  void _showIndicator() {
    _appearanceController
      ..duration = const Duration(milliseconds: 750)
      ..forward();
    _repeatingController.repeat();
  }

  void _hideIndicator() {
    _appearanceController
      ..duration = const Duration(milliseconds: 150)
      ..reverse();
    _repeatingController.stop();
  }
}
