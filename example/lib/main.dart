import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bouncy/flutter_bouncy.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: SpringTest(),
    );
  }
}

class SpringTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SpringTestState();
}

class SpringTestState extends State<SpringTest> {
  late List<Widget> children = [
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(false, key: GlobalKey()),
    _buildChatMessage(false, key: GlobalKey()),
    _buildChatMessage(false, key: GlobalKey()),
    _buildChatMessage(false, key: GlobalKey()),
    _buildChatMessage(false, key: GlobalKey()),
    _buildChatMessage(false, key: GlobalKey()),
    _buildChatMessage(false, key: GlobalKey()),
    _buildChatMessage(false, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(false, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(false, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(false, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
    _buildChatMessage(true, key: GlobalKey()),
  ];

  @override
  void initState() {
    Stream.periodic(Duration(seconds: 6)).listen((event) {
      // setState(() {
      //   children = children.reversed.toList();
      // });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BouncyList.builder(
          itemCount: 100,
          reverse: true,
          itemBuilder: (context, index) {
            if (index % 2 == 0) {
              return _buildImage(
                isSender: index % 6 == 0,
                image:
                    'https://cataas.com/cat?size=600x600?${DateTime.now().millisecondsSinceEpoch.toString()}',
              );
            } else {
              return _buildChatMessage(index % 3 == 0);
            }
          },
        ),
      ),
    );
  }

  Widget _buildImage({
    required bool isSender,
    required String image,
  }) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Image.network(
        image,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              width: 175,
              height: 175,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: Colors.purple,
                ),
              ),
              child: child,
            ),
          );
        },
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildChatMessage(
    bool isSender, {
    double? height = 55,
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: isSender
                  ? Colors.purple.withOpacity(0.8)
                  : Colors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBar(double height) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: height / 9,
          child: Container(
            width: 18,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(max(Random().nextDouble(), 0.4)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
