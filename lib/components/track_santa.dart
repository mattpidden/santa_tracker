import 'dart:async';

import 'package:christmas/components/alert.dart';
import 'package:christmas/components/countdown.dart';
import 'package:christmas/components/map.dart';
import 'package:christmas/components/santas_location.dart';
import 'package:christmas/components/snowfall.dart';
import 'package:flutter/material.dart';

class TrackSantaMap extends StatefulWidget {
  const TrackSantaMap({super.key});

  @override
  State<TrackSantaMap> createState() => _TrackSantaMapState();
}

class _TrackSantaMapState extends State<TrackSantaMap> {
  var santaLeft = SantaTracker().hasSantaLeft();
  var showMap = SantaTracker().hasSantaLeft();
  Future<void> _showMyDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomAlert(title: title, message: message);
      },
    );
  }

  void handleCallback() {
    setState(() {
      showMap = true;
    });
  }

  void checkSantaLeft() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        santaLeft = SantaTracker().hasSantaLeft();
        if (santaLeft) {
          showMap = true;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    // Call the repeatFunction when the page opens
    checkSantaLeft();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.red,
        body: Container(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Show a back button if santa has not left but user is viewing map
                    SizedBox(
                      width: 50,
                    ),
                    Spacer(),

                    Text(
                      "Live Santa Tracker",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    Spacer(),

                    SizedBox(
                      width: 50,
                      height: 25,
                      child: MaterialButton(
                        onPressed: () {
                          _showMyDialog("Santa Tracker", """
Ho Ho Ho! 🎅
🌟 Welcome to the Santa Tracker App! 🌍🎁
Get ready for a magical journey around the globe as Santa embarks on his mission to bring joy and gifts to every country and every child's home! 🎅

⏰ Friendly Reminder:
For the full Santa magic, it's important for everyone to be snug in their beds fast asleep. 🌙✨ Santa only delivers presents when children are in a deep, peaceful slumber. So, resist the temptation to stay up watching the tracker – a good night's sleep ensures the most delightful surprises on Christmas morning! 🎁💤

Wishing you and your family a festive season filled with joy and wonder! 🎅🌟

Merry Christmas! 🎄🎉
""");
                        },
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: AnimatedMapControllerPage(),
                )
              ],
            )),
      ),
      !showMap
          ? Container(
              color:
                  Color.fromARGB(122, 172, 212, 220), // Set your desired color
              width: double.infinity, // Set width to fill the available space
              height: double.infinity, // Set height to fill the available space
            )
          : SizedBox.shrink(),
      !showMap ? CountdownTimer(callback: handleCallback) : SizedBox.shrink(),
      const Snowfall()
    ]);
  }
}
