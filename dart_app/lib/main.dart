import 'package:flutter/material.dart';

void main() {
  runApp(const DartApp());
}

class DartApp extends StatelessWidget {
  const DartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kutup Dart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.red,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  double get average =>
      scores.isEmpty ? 0 : total / scores.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kutup Dart"),
        backgroundColor: Colors.red,
      ),
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
              onPressed: addScore,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text("Ekle"),
            ),
            const SizedBox(height: 20),
            Text(
              "Toplam: $total",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Ortalama: ${average.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.white),
            ),
            const Divider(color: Colors.white),
            Expanded(
              child: ListView.builder(
                itemCount: scores.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "${index + 1}. atış: ${scores[index]}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}