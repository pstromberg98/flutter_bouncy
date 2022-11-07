import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bouncy/src/spring.dart';

class BouncyDebug extends StatefulWidget {
  final Spring spring;
  final Widget child;

  BouncyDebug({
    required this.spring,
    required this.child,
  });

  @override
  State<BouncyDebug> createState() => _BouncyDebugState();
}

class _BouncyDebugState extends State<BouncyDebug>
    with SingleTickerProviderStateMixin {
  final ScrollController controller = ScrollController();

  late Ticker ticker;
  late Offset lastPosition = Offset.zero;
  Duration tickerDuration = Duration.zero;

  @override
  void initState() {
    ticker = createTicker((elapsed) {
      setState(() {
        widget.spring.tick();
      });
    });
    ticker.start();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (event) {
        // ticker.stop();
        setState(() {
          widget.spring.addLength(-event.delta.dy);
        });
      },
      child: Stack(
        children: [
          widget.child,
          Transform.translate(
            offset: Offset(0, -widget.spring.state.length),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                ),
              ),
              child: Opacity(
                opacity: 0.5,
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
