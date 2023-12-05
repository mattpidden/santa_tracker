import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Snowfall extends StatefulWidget {
  const Snowfall({super.key});

  @override
  _SnowfallState createState() => _SnowfallState();
}

class _SnowfallState extends State<Snowfall> {
  final List<Snowflake> snowflakes = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 200; i++) {
      snowflakes.add(Snowflake.random());
    }
    startSnowfall();
  }

  void startSnowfall() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      for (var snowflake in snowflakes) {
        snowflake.fall();
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SnowfallPainter(snowflakes),
    );
  }
}

class Snowflake {
  double x;
  double y;
  double size;
  double speed;

  Snowflake()
      : x = 0,
        y = 0,
        size = 0,
        speed = 0;

  Snowflake.withValues(this.x, this.y, this.size, this.speed);

  Snowflake.random()
      : x = Random().nextDouble() *
            MediaQueryData.fromView(WidgetsBinding.instance.window).size.width,
        y = Random().nextDouble() * 600,
        size = Random().nextDouble() * 5 + 2,
        speed = Random().nextDouble() * 2 + 1;

  void fall() {
    y += speed;
    x += (Random().nextDouble() - 0.5) * 0.5;
    if (y > 800) {
      y = 0;
      x = Random().nextDouble() *
          MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;
    }
  }
}

class SnowfallPainter extends CustomPainter {
  final List<Snowflake> snowflakes;

  SnowfallPainter(this.snowflakes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var snowflake in snowflakes) {
      canvas.drawCircle(
          Offset(snowflake.x, snowflake.y), snowflake.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
