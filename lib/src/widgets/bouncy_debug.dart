import 'package:flutter/material.dart';
import 'package:flutter_bouncy/flutter_bouncy.dart';

class BouncyDebug extends StatelessWidget {
  final SpringState springState;
  final SpringConfiguration springConfig;
  final Widget child;

  BouncyDebug({
    required this.springState,
    required this.springConfig,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Transform.translate(
          offset: Offset(0, -springState.length),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
              ),
            ),
            child: Opacity(
              opacity: 0.5,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
