import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> throws = [];

  void _startNewGame() async {
    final result = await Navigator.push<List<Map<String, dynamic>>>(
      context,
      MaterialPageRoute(builder: (_) => GameScreen(onSave: _saveThrows)),
    );
    if (result != null) {
      setState(() => throws = result);
    }
  }

  void _saveThrows(List<Map<String, dynamic>> newThrows) {
    setState(() => throws = newThrows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kutup Dart"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo/Title
            const Icon(Icons.sports_bar, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Text(
              "Dart Oyunu İstatistikleri",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            // Yeni Oyun Butonu
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              icon: const Icon(Icons.play_arrow),
              label: const Text("Yeni Oyun", style: TextStyle(fontSize: 16)),
              onPressed: _startNewGame,
            ),
            const SizedBox(height: 20),

            // İstatistikler Butonu
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              icon: const Icon(Icons.bar_chart),
              label: const Text("İstatistikler", style: TextStyle(fontSize: 16)),
              onPressed: throws.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => StatsScreen(throws: throws)),
                      );
                    },
            ),
            const SizedBox(height: 40),

            // Hızlı Bilgi
            if (throws.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text("Son Oturum", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 8),
                    Text(
                      "Atış: ${throws.length} | Ort.: ${(throws.fold(0, (sum, t) => sum + (t['score'] as int)) / throws.length).toStringAsFixed(1)}",
                      style: const TextStyle(color: Colors.lime, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}