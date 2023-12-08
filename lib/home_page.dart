import 'package:christmas/components/countdown.dart';
import 'package:christmas/components/jokes.dart';
import 'package:christmas/components/snowfall.dart';
import 'package:christmas/components/track_santa.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageStateView();
}

class _HomePageStateView extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    const double mobileBreakpoint = 600;
    final screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.red,
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: (screenWidth < mobileBreakpoint)
                      ? [
                          const Text(
                            "Santa Season",
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 250, 250, 250),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Expanded(
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Lottie.asset(
                                          'assets/santasleigh.json',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                        TextButton(
                                          child: const Text(
                                            "Track Santa",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TrackSantaMap()),
                                            );
                                          },
                                        ),
                                        Spacer()
                                      ],
                                    ),
                                  ))),
                          const SizedBox(height: 10),
                          Expanded(child: JokeView()),
                          const SizedBox(height: 10),
                        ]
                      : [
                          const Text(
                            "Santa Season",
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 250, 250, 250),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        padding: const EdgeInsets.all(16.0),
                                        child: Expanded(
                                          child: Column(
                                            children: [
                                              Spacer(),
                                              Lottie.asset(
                                                'assets/santasleigh.json',
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                              TextButton(
                                                child: const Text(
                                                  "Track Santa",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const TrackSantaMap()),
                                                  );
                                                },
                                              ),
                                              Spacer()
                                            ],
                                          ),
                                        ))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(child: JokeView()),
                                const SizedBox(width: 10),
                              ],
                            ),
                          )
                        ]),
            ),
            Snowfall()
          ],
        ),
      ),
    );
  }
}
