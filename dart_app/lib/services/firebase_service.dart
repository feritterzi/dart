import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addThrow(String playerId, int score) async {
    await _db.collection('players')
      .doc(playerId)
      .collection('throws')
      .add({'score': score, 'timestamp': DateTime.now()});
  }

  Stream<QuerySnapshot> getThrows(String playerId) {
    return _db.collection('players')
      .doc(playerId)
      .collection('throws')
      .orderBy('timestamp', descending: true)
      .snapshots();
  }
}