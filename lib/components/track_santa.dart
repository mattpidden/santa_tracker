import 'package:christmas/components/map.dart';
import 'package:christmas/components/snowfall.dart';
import 'package:flutter/material.dart';

class TrackSantaMap extends StatefulWidget {
  const TrackSantaMap({super.key});

  @override
  State<TrackSantaMap> createState() => _TrackSantaMapState();
}

class _TrackSantaMapState extends State<TrackSantaMap> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.red,
        body: Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Live Santa Tracker",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
                const Expanded(child: AnimatedMapControllerPage())
              ],
            )),
      ),
      Snowfall()
    ]);
  }
}
