import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(MyApp());
final rng = Random();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> positions = new List();

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 10,
      ),
    );
    animationController
      ..addListener(() {
        setState(() {});
      });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => animationController.repeat());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      List.generate(1000, (index) {
        positions.add(Offset(
          rng.nextInt(MediaQuery.of(context).size.width.toInt() - 4).toDouble(),
          rng
              .nextInt(MediaQuery.of(context).size.height.toInt() - 4)
              .toDouble(),
        ));
      });
    }
    return Container(
        color: Color.fromARGB(
          rng.nextInt(255),
          rng.nextInt(255),
          rng.nextInt(255),
          rng.nextInt(255),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: positions.map((offset) {
            return _buildStars(offset, positions.indexOf(offset));
          }).toList(),
        ));
  }

  Widget _buildStars(Offset offset, int index) {
    offset = _newOffset(offset);
    positions[index] = offset;
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Container(
        width: rng.nextDouble() * 30,
        height: rng.nextDouble() * 30,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(
                    rng.nextInt(255),
                    rng.nextInt(255),
                    rng.nextInt(255),
                    rng.nextInt(255),
                  ),
                  blurRadius: 2)
            ],
            color: Color.fromARGB(
              rng.nextInt(255),
              rng.nextInt(255),
              rng.nextInt(255),
              rng.nextInt(255),
            ),
            shape: BoxShape.circle),
      ),
    );
  }

  Offset _newOffset(Offset oldOffset) {
    bool posOrNeg = rng.nextBool();
    double dx, dy;
    if (posOrNeg) {
      dx = oldOffset.dx <= MediaQuery.of(context).size.width - 4
          ? oldOffset.dx + rng.nextInt(10)
          : oldOffset.dx - rng.nextInt(10);
    } else {
      dx = oldOffset.dx <= MediaQuery.of(context).size.width - 4
          ? oldOffset.dx - rng.nextInt(10)
          : oldOffset.dx + rng.nextInt(10);
    }
    posOrNeg = rng.nextBool();
    if (posOrNeg) {
      dy = oldOffset.dy <= MediaQuery.of(context).size.height - 4
          ? oldOffset.dy + rng.nextInt(10)
          : oldOffset.dy - rng.nextInt(10);
    } else {
      dy = oldOffset.dy <= MediaQuery.of(context).size.height - 4
          ? oldOffset.dy - rng.nextInt(10)
          : oldOffset.dy + rng.nextInt(10);
    }
    return Offset(
      dx,
      dy,
    );
  }
}
