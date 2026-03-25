import 'package:flutter/material.dart';

class ThrowList extends StatelessWidget {
  final List<int> scores;
  const ThrowList({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: scores.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(
          "${index + 1}. atış: ${scores[index]}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}