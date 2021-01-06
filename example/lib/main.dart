import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  final tween = Tween<double>(begin: 0.0, end: 0.0);
  Animation<double> tweenAnimation;
  AnimationController controller;
  ScrollController scrollController;
  double scrollDelta = 0.0;
  double lastPixels;

  @override
  void initState() {
    scrollController = ScrollController();
    controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    tweenAnimation = controller.drive(tween);
    tweenAnimation.addListener(() {
      setState(() {
        scrollDelta = tweenAnimation.value;
        // print(tweenAnimation.value);
        // print(scrollDelta);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              if (scrollController.position != null) {
                // setState(() {
                //   scrollDelta = notification.scrollDelta;
                // });
                tween.begin = scrollDelta;
                tween.end = notification.scrollDelta;

                if (controller.isCompleted) {
                  controller.reset();
                }

                if (!controller.isAnimating) {
                  controller.forward();
                }
              }
            }

            if (notification is ScrollEndNotification) {
              // controller.reset();
              // setState(() {
              //   scrollDelta = 0;
              // });
            }
            return false;
          },
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverBouncyList(
                scrollDelta: scrollDelta,
                delegate: SliverChildListDelegate(
                  [
                    Text('Testing'),
                    Text('Another test'),
                    Text('Another test2'),
                    Text('Another test2'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: 100,
                        height: 30,
                        color: Colors.green,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 30,
                      color: Colors.red,
                    ),
                    Text('Another test2'),
                    Text('Another test2'),
                    Container(
                      width: 100,
                      height: 30,
                      color: Colors.green,
                    ),
                    Container(
                      width: 100,
                      height: 30,
                      color: Colors.red,
                    ),
                    Text('Another test2'),
                    Text('Another test2'),
                    Container(
                      width: 100,
                      height: 30,
                      color: Colors.green,
                    ),
                    Container(
                      width: 100,
                      height: 30,
                      color: Colors.red,
                    ),
                    Container(
                      width: 100,
                      height: 130,
                      color: Colors.green,
                    ),
                    Container(
                      width: 100,
                      height: 110,
                      color: Colors.red,
                    ),
                    Container(
                      width: 100,
                      height: 80,
                      color: Colors.green,
                    ),
                    Container(
                      width: 100,
                      height: 30,
                      color: Colors.red,
                    ),
                    Container(
                      width: 100,
                      height: 110,
                      color: Colors.red,
                    ),
                    Container(
                      width: 100,
                      height: 80,
                      color: Colors.green,
                    ),
                    Container(
                      width: 100,
                      height: 110,
                      color: Colors.red,
                    ),
                    Container(
                      width: 100,
                      height: 80,
                      color: Colors.green,
                    ),
                    Container(
                      width: 100,
                      height: 110,
                      color: Colors.red,
                    ),
                    Container(
                      width: 100,
                      height: 80,
                      color: Colors.green,
                    ),
                    Container(
                      width: 100,
                      height: 110,
                      color: Colors.red,
                    ),
                    Container(
                      width: 100,
                      height: 80,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverBouncyList extends SliverMultiBoxAdaptorWidget {
  final double scrollDelta;

  const SliverBouncyList({
    Key key,
    @required SliverChildDelegate delegate,
    @required this.scrollDelta,
  }) : super(key: key, delegate: delegate);

  @override
  SliverMultiBoxAdaptorElement createElement() =>
      SliverMultiBoxAdaptorElement(this, replaceMovedChildren: true);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderSliverBouncyList renderObject,
  ) {
    renderObject..scrollDelta = scrollDelta;
  }

  @override
  RenderSliverList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return RenderSliverBouncyList(
      childManager: element,
      scrollDelta: scrollDelta,
    );
  }
}

class RenderSliverBouncyList extends RenderSliverList {
  double scrollDelta;

  RenderSliverBouncyList({
    @required RenderSliverBoxChildManager childManager,
    @required this.scrollDelta,
  }) : super(childManager: childManager);

  PointerEvent lastPointerEvent;

  @override
  void handleEvent(PointerEvent event, covariant HitTestEntry entry) {
    if (event is! PointerUpEvent && event is! PointerCancelEvent) {
      lastPointerEvent = event;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (firstChild == null) return;
    // offset is to the top-left corner, regardless of our axis direction.
    // originOffset gives us the delta from the real origin to the origin in the axis direction.
    Offset mainAxisUnit, crossAxisUnit, originOffset;
    bool addExtent;
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
        mainAxisUnit = const Offset(0.0, -1.0);
        crossAxisUnit = const Offset(1.0, 0.0);
        originOffset = offset + Offset(0.0, geometry.paintExtent);
        addExtent = true;
        break;
      case AxisDirection.right:
        mainAxisUnit = const Offset(1.0, 0.0);
        crossAxisUnit = const Offset(0.0, 1.0);
        originOffset = offset;
        addExtent = false;
        break;
      case AxisDirection.down:
        mainAxisUnit = const Offset(0.0, 1.0);
        crossAxisUnit = const Offset(1.0, 0.0);
        originOffset = offset;
        addExtent = false;
        break;
      case AxisDirection.left:
        mainAxisUnit = const Offset(-1.0, 0.0);
        crossAxisUnit = const Offset(0.0, 1.0);
        originOffset = offset + Offset(geometry.paintExtent, 0.0);
        addExtent = true;
        break;
    }
    assert(mainAxisUnit != null);
    assert(addExtent != null);
    RenderBox child = firstChild;
    while (child != null) {
      final double mainAxisDelta = childMainAxisPosition(child);
      final double crossAxisDelta = childCrossAxisPosition(child);
      Offset childOffset = Offset(
        originOffset.dx +
            mainAxisUnit.dx * mainAxisDelta +
            crossAxisUnit.dx * crossAxisDelta,
        originOffset.dy +
            mainAxisUnit.dy * mainAxisDelta +
            crossAxisUnit.dy * crossAxisDelta,
      );
      if (addExtent) childOffset += mainAxisUnit * paintExtentOf(child);

      var resistance = 0.0;

      if (lastPointerEvent != null) {
        resistance = (lastPointerEvent.localPosition.dy - childOffset.dy) / 100;
      }

      final paint = Paint();
      context.canvas.drawCircle(
        childOffset,
        10,
        paint,
      );

      final yOffset = scrollDelta > 0
          ? max(scrollDelta, scrollDelta * resistance)
          : min(scrollDelta, scrollDelta * resistance);

      childOffset += Offset(0, yOffset);

      // If the child's visible interval (mainAxisDelta, mainAxisDelta + paintExtentOf(child))
      // does not intersect the paint extent interval (0, constraints.remainingPaintExtent), it's hidden.
      if (mainAxisDelta < constraints.remainingPaintExtent &&
          mainAxisDelta + paintExtentOf(child) > 0)
        context.paintChild(child, childOffset);

      paint.color = Colors.red;
      context.canvas.drawCircle(
        lastPointerEvent?.localPosition ?? Offset(0, 0),
        10,
        paint,
      );
      child = childAfter(child);
    }
  }
}
