import 'package:flutter/material.dart';
import '../models/dart_throw.dart';

class GameScreen extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onSave;

  const GameScreen({super.key, required this.onSave});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _controller = TextEditingController();
  List<DartThrow> throws = [];
  String? _errorMessage;

  void addScore() {
    if (_controller.text.isEmpty) {
      setState(() => _errorMessage = "Lütfen bir puan girin");
      return;
    }

    final value = int.tryParse(_controller.text);
    if (value == null || value < 0 || value > 180) {
      setState(() => _errorMessage = "Puan 0-180 arasında olmalıdır");
      return;
    }

    setState(() {
      throws.add(DartThrow(score: value, timestamp: DateTime.now()));
      _controller.clear();
      _errorMessage = null;
    });
  }

  int get total => throws.fold(0, (sum, throw_) => sum + throw_.score);
  double get average => throws.isEmpty ? 0 : total / throws.length;
  int get maxScore => throws.isEmpty ? 0 : throws.map((t) => t.score).reduce((a, b) => a > b ? a : b);
  int get minScore => throws.isEmpty ? 0 : throws.map((t) => t.score).reduce((a, b) => a < b ? a : b);

  void clearSession() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Temizle"),
        content: const Text("Tüm atışları temizlemek istediğine emin misin?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("İptal")),
          TextButton(
            onPressed: () {
              setState(() => throws.clear());
              Navigator.pop(ctx);
            },
            child: const Text("Evet"),
          ),
        ],
      ),
    );
  }

  void _saveAndExit() {
    final throwsAsMap = throws
        .map((t) => {'score': t.score, 'timestamp': t.timestamp.toIso8601String()})
        .toList();
    widget.onSave(throwsAsMap);
    Navigator.pop(context, throwsAsMap);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (throws.isNotEmpty) {
          _saveAndExit();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Oyun"),
          backgroundColor: Colors.red,
          actions: [
            if (throws.isNotEmpty)
              IconButton(icon: const Icon(Icons.delete), onPressed: clearSession),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Input bölümü
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Atış gir (0-180)",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                  errorStyle: const TextStyle(color: Colors.orange),
                ),
                onSubmitted: (_) => addScore(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: addScore,
                      child: const Text("Ekle"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // İstatistikler bölümü
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statBox("Toplam", total.toString()),
                        _statBox("Ort.", average.toStringAsFixed(2)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statBox("Max", maxScore.toString()),
                        _statBox("Min", minScore.toString()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Atış Sayısı: ${throws.length}",
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white30),
              const SizedBox(height: 16),

              // Atış listesi
              Expanded(
                child: throws.isEmpty
                    ? const Center(
                        child: Text(
                          "Henüz atış yapılmadı",
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : ListView.builder(
                        reverse: true,
                        itemCount: throws.length,
                        itemBuilder: (context, index) {
                          final throwIndex = throws.length - index;
                          final throw_ = throws[index];
                          return Dismissible(
                            key: Key('${throw_.timestamp}'),
                            onDismissed: (_) {
                              setState(() => throws.removeAt(index));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "$throwIndex. atış: ${throw_.score}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${throw_.timestamp.hour}:${throw_.timestamp.minute.toString().padLeft(2, '0')}",
                                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBox(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.lime, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}