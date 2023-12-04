import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountdownTimer extends StatefulWidget {
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
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Countdown to Christmas:', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeUnit(days, 'Days'),
              _buildTimeUnit(hours, 'Hours'),
              _buildTimeUnit(minutes, 'Minutes'),
              _buildTimeUnit(seconds, 'Seconds'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(int value, String unit) {
    return Column(
      children: [
        Text('$value',
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        Text(unit, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
