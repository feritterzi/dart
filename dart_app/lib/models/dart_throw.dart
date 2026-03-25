class DartThrow {
  int score;
  DateTime timestamp;

  DartThrow({required this.score, required this.timestamp});

  Map<String, dynamic> toMap() =>
      {'score': score, 'timestamp': timestamp.toIso8601String()};
}