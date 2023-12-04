import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class JokeView extends StatefulWidget {
  const JokeView({super.key});

  @override
  State<JokeView> createState() => _JokeViewState();
}

class _JokeViewState extends State<JokeView> {
  var showPunchline = false;

  List<Joke> jokes = [];
  Joke selectedJoke = Joke(part1: "", part2: "");

  @override
  void initState() {
    super.initState();
    _loadJokes();
  }

  void _loadJokes() async {
    // Load jokes from the 'jokes.json' file
    try {
      String jsonString =
          await DefaultAssetBundle.of(context).loadString('assets/jokes.json');
      List<Map<String, dynamic>> decodedList =
          List<Map<String, dynamic>>.from(json.decode(jsonString));

      jokes = decodedList.map((json) => Joke.fromJson(json)).toList();
      _pickRandomJoke();
    } catch (error) {
      print(error);
    }
  }

  void _pickRandomJoke() {
    final Random random = Random();
    setState(() {
      selectedJoke = jokes[random.nextInt(jokes.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                selectedJoke.part1,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              (selectedJoke.part2.isNotEmpty && !showPunchline)
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          showPunchline = true;
                        });
                      },
                      child: const Text(
                        "Reveal Punchline",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : const SizedBox.shrink(),
              showPunchline
                  ? Text(selectedJoke.part2)
                  : const SizedBox.shrink(),
              TextButton(
                onPressed: () {
                  _pickRandomJoke();
                  showPunchline = false;
                },
                child:
                    const Text("New Joke", style: TextStyle(color: Colors.red)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Joke {
  String part1;
  String part2;

  Joke({required this.part1, required this.part2});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      part1: json['part1'] ?? '',
      part2: json['part2'] ?? '',
    );
  }
}
