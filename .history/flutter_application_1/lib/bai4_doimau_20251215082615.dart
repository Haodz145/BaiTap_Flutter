import 'dart:math';
import 'package:flutter/material.dart';

class ChangeColorApp extends StatefulWidget {
  ChangeColorApp({super.key});

  @override
  State<ChangeColorApp> createState() => _ChangeColorAppState();
}

class _ChangeColorAppState extends State<ChangeColorApp> {
  Color bgColor = Colors.purple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Color App"),
        backgroundColor: Colors.yellow,
      ),
      body: myBody(),
    );
  }

  String bgColorString = "Tim";
  List<Color> listColor = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.pink,
    Colors.purple,
    Colors.orange,
  ];
  List<String> listColorString = [
    "Do",
    "Xanh la",
    "Xanh duong",
    "Hong",
    "Tim",
    "Cam",
  ];
  void _changeColor() {
    var rand = Random();
    var i = rand.nextInt(listColor.length);
    setState(() {
      bgColor = listColor[i];
      bgColorString = listColorString[i];
    });
  }

  Widget myBody() {
    return Container(
      decoration: BoxDecoration(color: bgColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(bgColorString),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _changeColor,
                child: Text("Change color"),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    bgColor = Colors.purple;
                    bgColorString = "Tim";
                  });
                },
                child: Text("Reset"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
