import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class StatsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> throws;

  const StatsScreen({super.key, required this.throws});

  @override
  Widget build(BuildContext context) {
    if (throws.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("İstatistikler"), backgroundColor: Colors.red),
        body: const Center(
          child: Text("Veri yok. Önce oyun oynamanız gerekmektedir.", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final scores = throws.map((t) => t['score'] as int).toList();
    final total = scores.fold<int>(0, (sum, s) => sum + s);
    final average = total / scores.length;
    final maxScore = scores.reduce((a, b) => a > b ? a : b);
    final minScore = scores.reduce((a, b) => a < b ? a : b);
    final standardDeviation = _calculateStdDev(scores, average);

    return Scaffold(
      appBar: AppBar(title: const Text("İstatistikler"), backgroundColor: Colors.red),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Özet İstatistikler
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text("Oturum İstatistikleri", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _statRow("Toplam Puan", total.toString()),
                  _statRow("Ortalama", average.toStringAsFixed(2)),
                  _statRow("En Yüksek", maxScore.toString()),
                  _statRow("En Düşük", minScore.toString()),
                  _statRow("Standart Sapma", standardDeviation.toStringAsFixed(2)),
                  _statRow("Atış Sayısı", throws.length.toString()),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grafik
            const Text("Atış Geçmişi", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  barGroups: List.generate(
                    scores.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: scores[index].toDouble(),
                          color: _getScoreColor(scores[index], average),
                          width: 16,
                        ),
                      ],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt() + 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true, drawHorizontalLine: true),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Atış Listesi
            const Text("Detaylı Atış Listesi", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: throws.length,
              itemBuilder: (context, index) {
                final score = throws[index]['score'] as int;
                return Container(
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
                        "${index + 1}. atış: $score",
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getScoreColor(score, average),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getScoreLabel(score, average),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  double _calculateStdDev(List<int> scores, double average) {
    if (scores.isEmpty) return 0;
    final variance = scores.map((s) => (s - average) * (s - average)).reduce((a, b) => a + b) / scores.length;
    return variance > 0 ? sqrt(variance) : 0;
  }

  Color _getScoreColor(int score, double average) {
    if (score > average * 1.2) return Colors.green.withAlpha(128);
    if (score < average * 0.8) return Colors.red.withAlpha(128);
    return Colors.blue.withAlpha(128);
  }

  String _getScoreLabel(int score, double average) {
    if (score > average * 1.2) return "Üstün";
    if (score < average * 0.8) return "Zayıf";
    return "Orta";
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.lime, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}