import 'package:flutter/material.dart';
import 'package:flutter_bouncy/flutter_bouncy.dart';
import 'package:flutter_bouncy/src/spring.dart';
import 'package:flutter_bouncy/src/widgets/bouncy_sliver_list.dart';
import 'package:flutter_bouncy/src/widgets/widgets.dart';

final _defaultSpringConfiguration = SpringConfiguration(
  mass: 15,
  k: 0.9,
);

class BouncyList extends StatefulWidget {
  BouncyList({
    super.key,
    required List<Widget> children,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    SpringConfiguration? configuration,
  })  : delegate = SliverChildListDelegate(children),
        this.configuration = configuration ?? _defaultSpringConfiguration;

  BouncyList.builder({
    super.key,
    required IndexedWidgetBuilder itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    int? itemCount,
    SpringConfiguration? configuration,
  })  : delegate = SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
        ),
        this.configuration = configuration ?? _defaultSpringConfiguration;

  final Axis scrollDirection;
  final SliverChildDelegate delegate;
  final SpringConfiguration configuration;
  final bool reverse;

  @override
  State<StatefulWidget> createState() => BouncyListState();
}

class BouncyListState extends State<BouncyList> with TickerProviderStateMixin {
  late SpringSimulator simulator;
  double lastPixels = 0;

  @override
  void initState() {
    super.initState();
    simulator = SpringSimulator(
      vsync: this,
      initialLength: 0,
      configuration: widget.configuration,
    );
  }

  @override
  void didUpdateWidget(BouncyList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.configuration != widget.configuration) {
      simulator = SpringSimulator(
        vsync: this,
        initialLength: 0,
        configuration: widget.configuration,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BouncyScrollView(
      reverse: widget.reverse,
      scrollDirection: widget.scrollDirection,
      simulator: simulator,
      sliversBuilder: (pointerPosition, scrollDelta) => [
        BouncySliverList(
          pointerPosition: pointerPosition,
          scrollDelta: scrollDelta,
          delegate: widget.delegate,
          simulator: simulator,
        ),
      ],
    );
  }
}
