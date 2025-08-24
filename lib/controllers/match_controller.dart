import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/models/match.dart';

class MatchController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getMatches() {
    return _db.collection('football').snapshots();
  }

  Future<void> addMatch(Match match) async {
    await _db.collection('football').doc(match.id).set(match.toMap());
  }
}
