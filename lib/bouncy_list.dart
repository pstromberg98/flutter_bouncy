import 'package:flutter/material.dart';
import 'package:flutter_bouncy/sliver_bouncy_list.dart';

class BouncyList extends StatefulWidget {
  final SliverChildDelegate delegate;
  final bool reverse;
  final ScrollController controller;

  BouncyList({
    @required this.delegate,
    this.reverse = false,
    this.controller,
  });

  @override
  State<StatefulWidget> createState() => BouncyListState();
}

class BouncyListState extends State<BouncyList> {
  Offset globalPosition;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (notification.dragDetails != null) {
          setState(() {
            globalPosition = notification.dragDetails.globalPosition;
          });
        }
      },
      child: CustomScrollView(
        reverse: widget.reverse,
        controller: widget.controller,
        slivers: [
          SliverBouncyList(
            globalPosition: globalPosition,
            delegate: widget.delegate,
          ),
        ],
      ),
    );
  }
}
