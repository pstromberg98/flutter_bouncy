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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BouncyList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildChatMessage(
              index % 3 == 0,
              height: index % 3 == 0 ? 25 : 50,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessage(
    bool isSender, {
    double? height = 25,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
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

// class MyHomePage extends StatefulWidget {
//   MyHomePage({
//     super.key,
//     required this.title,
//   });

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage>
//     with SingleTickerProviderStateMixin {
//   int _counter = 0;
//   final tween = Tween<double>(begin: 0.0, end: 0.0);
//   ScrollController scrollController;
//   Offset globalPosition;
//   double lastPixels;

//   @override
//   void initState() {
//     scrollController = ScrollController();
//     super.initState();
//   }

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final children = [
//       // _buildBar(5),
//       // _buildBar(3),
//       // _buildBar(3),
//       // _buildBar(3),
//       // _buildBar(4),
//       // _buildBar(5),
//       // _buildBar(1),
//       // _buildBar(4),
//       // _buildBar(6),
//       // _buildBar(3),
//       // _buildBar(2.1),
//       // _buildBar(6),
//       // _buildBar(3),
//       // _buildBar(3),
//       // _buildBar(4),
//       // _buildBar(3),
//       // _buildBar(3),
//       // _buildBar(1.5),
//       // _buildBar(3),
//       // _buildBar(5),
//       // _buildBar(6),
//       // _buildBar(3),
//       // _buildBar(4),
//       // _buildBar(6),
//       // _buildBar(2),
//       // _buildBar(3),
//       // _buildBar(1.5),
//       // _buildBar(3),
//       // _buildBar(5),
//       // _buildBar(4),
//       // _buildBar(3),
//       // _buildBar(4),
//       // _buildBar(6),
//       // _buildBar(2),
//       // _buildBar(3),
//       // _buildBar(3),
//       // _buildBar(3),
//       // _buildBar(4),
//       // _buildBar(5),
//       // _buildBar(1),
//       // _buildBar(4),
//       // _buildBar(6),
//       // _buildBar(3),
//       // _buildBar(3),
//       // _buildBar(3),
//       // _buildBar(4),
//       // _buildBar(5),
//       // _buildBar(1),
//       // _buildBar(4),
//       // _buildBar(6),
//       _buildChatMessage(true),
//       _buildChatMessage(false),
//       _buildChatMessage(true),
//       _buildChatMessage(true),
//       _buildChatMessage(true),
//       _buildChatMessage(false),
//       _buildChatMessage(false),
//       _buildChatMessage(true),
//       _buildChatMessage(false),
//       _buildChatMessage(true),
//       _buildChatMessage(true),
//       _buildChatMessage(false),
//       _buildChatMessage(false),
//       _buildChatMessage(true),
//       _buildChatMessage(true),
//       _buildChatMessage(true),
//       _buildChatMessage(false),
//       _buildChatMessage(true),
//       _buildChatMessage(true),
//       _buildChatMessage(true),
//       _buildChatMessage(false),
//       _buildChatMessage(false),
//       _buildChatMessage(true),
//       _buildChatMessage(false),
//       _buildChatMessage(true),
//       _buildChatMessage(true),
//       _buildChatMessage(false),
//       _buildChatMessage(true),
//       _buildChatMessage(true),
//       _buildChatMessage(false),
//       _buildChatMessage(true),
//       _buildChatMessage(true),
//     ];
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(10),
//           child: AnimatedBouncyList(
//             reverse: true,
//             itemBuilder: (ctx, i, anim) {
//               return children[i];
//             },
//             initialItemCount: children.length,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildChatMessage(bool isSender) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Align(
//         alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
//         child: FractionallySizedBox(
//           widthFactor: 0.8,
//           child: Container(
//             height: 25,
//             decoration: BoxDecoration(
//               color: isSender
//                   ? Colors.purple.withOpacity(0.8)
//                   : Colors.grey.withOpacity(0.4),
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBar(double height) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 5),
//       child: Align(
//         alignment: Alignment.bottomCenter,
//         child: FractionallySizedBox(
//           heightFactor: height / 9,
//           child: Container(
//             width: 18,
//             decoration: BoxDecoration(
//               color: Colors.green.withOpacity(max(Random().nextDouble(), 0.4)),
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
