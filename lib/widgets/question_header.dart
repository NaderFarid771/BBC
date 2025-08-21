import 'package:flutter/material.dart';

class QuestionHeader extends StatelessWidget {
  final int current;
  final int total;
  final int timeLeft;

  const QuestionHeader({
    super.key,
    required this.current,
    required this.total,
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LinearProgressIndicator(
                  value: current / total,
                  color: Colors.red,
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ),
            Text("$current/$total"),
          ],
        ),
        const SizedBox(height: 20),

        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.deepPurple,
          child: Text(
            "$timeLeft",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}