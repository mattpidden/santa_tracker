import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final VoidCallback callback;

  const CountdownTimer({super.key, required this.callback});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late DateTime _christmasDay;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeCountdown();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _initializeCountdown() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the time until Christmas Day midnight
    _christmasDay = DateTime(now.year, 12, 25, 23, 59, 59);
    if (now.isAfter(_christmasDay)) {
      _christmasDay = DateTime(now.year + 1, 12, 25, 23, 59, 59);
    }
  }

  void _startTimer() {
    // Update the countdown every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Duration timeUntilChristmas = _christmasDay.difference(DateTime.now());

    int days = timeUntilChristmas.inDays;
    int hours = timeUntilChristmas.inHours - (days * 24);
    int minutes =
        timeUntilChristmas.inMinutes - (days * 24 * 60) - (hours * 60);
    int seconds = timeUntilChristmas.inSeconds -
        (days * 24 * 60 * 60) -
        (hours * 60 * 60) -
        (minutes * 60);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeUnit(days, 'Days'),
              _buildTimeUnit(hours, 'Hours'),
              _buildTimeUnit(minutes, 'Minutes'),
              _buildTimeUnit(seconds, 'Seconds'),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          MaterialButton(
              onPressed: () {
                widget.callback();
              },
              child: Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                child: Text(
                  "VIEW MAP",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 172, 212, 220)),
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildTimeUnit(int value, String unit) {
    return Column(
      children: [
        Text('$value',
            style: const TextStyle(
                fontSize: 40, fontFamily: 'JollySweater', color: Colors.white)),
        Text(unit, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}
