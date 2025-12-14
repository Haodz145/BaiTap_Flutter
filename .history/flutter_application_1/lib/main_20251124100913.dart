import 'package:flutter/material.dart';
import 'package:flutter_application_1/hoc.dart';
import 'package:flutter_application_1/my_product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyProduct(), debugShowCheckedModeBanner: false);
  }
}
