import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("İstatistikler"), backgroundColor: Colors.red),
      body: const Center(
        child: Text(
          "Grafikler ve geçmiş maçlar burada olacak",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}