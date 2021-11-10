import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bouncy/src/sliver_bouncy_list.dart';

class BouncyList extends StatelessWidget {
  final bool reverse;
  final ScrollController controller;
  final SpringDescription springDescription;
  final Axis scrollDirection;

  final List<Widget>? children;

  final IndexedWidgetBuilder? itemBuilder;
  final int? itemCount;

  BouncyList({
    this.reverse = false,
    required this.controller,
    this.scrollDirection = Axis.vertical,
    this.springDescription = const SpringDescription(
      mass: 20.0,
      stiffness: 0.6,
      damping: 0.4,
    ),
    this.children = const [],
  })  : this.itemBuilder = null,
        this.itemCount = null;

  BouncyList.builder({
    required this.itemBuilder,
    required this.itemCount,
    this.reverse = false,
    this.children,
    required this.controller,
    this.scrollDirection = Axis.vertical,
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
    return children != null
        ? SliverChildListDelegate(children!)
        : SliverChildBuilderDelegate(
            itemBuilder!,
            childCount: itemCount,
          );
  }
}
