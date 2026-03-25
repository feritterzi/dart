import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _controller = TextEditingController();
  List<int> scores = [];

  void addScore() {
    if (_controller.text.isEmpty) return;
    final value = int.tryParse(_controller.text);
    if (value == null) return;
    setState(() {
      scores.add(value);
      _controller.clear();
    });
  }

  int get total => scores.fold(0, (a, b) => a + b);
  double get average => scores.isEmpty ? 0 : total / scores.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Oyun"), backgroundColor: Colors.red),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Atış gir (0-180)",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: addScore,
              child: const Text("Ekle"),
            ),
            const SizedBox(height: 20),
            Text("Toplam: $total", style: const TextStyle(color: Colors.white)),
            Text("Ortalama: ${average.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white)),
            const Divider(color: Colors.white),
            Expanded(
              child: ListView.builder(
                itemCount: scores.length,
                itemBuilder: (context, index) => Text(
                  "${index + 1}. atış: ${scores[index]}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}