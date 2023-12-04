import 'package:christmas/components/santas_location.dart';
import 'package:christmas/components/track_santa.dart';
import 'package:christmas/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Santa Season',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.red,
        body: SafeArea(
          child: TrackSantaMap(),
        ),
      ),
    );
  }
}
