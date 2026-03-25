class DartThrow {
  final int score;
  final DateTime timestamp;
  final String? playerId;
  final String? sessionId;

  DartThrow({
    required this.score,
    required this.timestamp,
    this.playerId,
    this.sessionId,
  });

  Map<String, dynamic> toMap() => {
    'score': score,
    'timestamp': timestamp.toIso8601String(),
    'playerId': playerId,
    'sessionId': sessionId,
  };

  factory DartThrow.fromMap(Map<String, dynamic> map) {
    return DartThrow(
      score: map['score'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
      playerId: map['playerId'] as String?,
      sessionId: map['sessionId'] as String?,
    );
  }
}