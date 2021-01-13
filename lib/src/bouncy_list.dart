import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bouncy/src/sliver_bouncy_list.dart';

class BouncyList extends StatelessWidget {
  final SliverChildDelegate delegate;
  final bool reverse;
  final ScrollController controller;
  final SpringDescription springDescription;

  BouncyList({
    @required this.delegate,
    this.reverse = false,
    this.controller,
    this.springDescription = const SpringDescription(
      mass: 20.0,
      stiffness: 0.6,
      damping: 0.4,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      reverse: reverse,
      controller: controller,
      slivers: [
        SliverBouncyList(
          delegate: delegate,
          springDescription: springDescription,
        ),
      ],
    );
  }
}
