import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bouncy/src/sliver_bouncy_list.dart';

class BouncyList extends StatelessWidget {
  final bool reverse;
  final ScrollController controller;
  final SpringDescription springDescription;
  final Axis scrollDirection;

  final List<Widget> children;

  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  BouncyList({
    this.reverse = false,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.springDescription = const SpringDescription(
      mass: 20.0,
      stiffness: 0.6,
      damping: 0.4,
    ),
    this.children = const [],
  })  : itemBuilder = null,
        itemCount = null;

  BouncyList.builder({
    @required this.itemBuilder,
    @required this.itemCount,
    this.reverse = false,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.springDescription = const SpringDescription(
      mass: 20.0,
      stiffness: 0.6,
      damping: 0.4,
    ),
  }) : children = null;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      reverse: reverse,
      controller: controller,
      scrollDirection: scrollDirection,
      slivers: [
        SliverBouncyList(
          delegate: _createDelegate(),
          springDescription: springDescription,
        ),
      ],
    );
  }

  SliverChildDelegate _createDelegate() {
    if (children != null) {
      return SliverChildListDelegate(children);
    } else {
      return SliverChildBuilderDelegate(
        itemBuilder,
        childCount: itemCount,
      );
    }
  }
}
