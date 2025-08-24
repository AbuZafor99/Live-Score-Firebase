
import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  final String id;
  final String team1Name;
  final String team2Name;
  final int team1Score;
  final int team2Score;
  final String runningTime;
  final String totalTime;

  Match({
    required this.id,
    required this.team1Name,
    required this.team2Name,
    required this.team1Score,
    required this.team2Score,
    required this.runningTime,
    required this.totalTime,
  });

  factory Match.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Match(
      id: doc.id,
      team1Name: data['team1_name'] ?? '',
      team2Name: data['team2_name'] ?? '',
      team1Score: data['team1_score'] ?? 0,
      team2Score: data['team2_score'] ?? 0,
      runningTime: data['running_time'] ?? '00:00',
      totalTime: data['total_time'] ?? '90:00',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'team1_name': team1Name,
      'team2_name': team2Name,
      'team1_score': team1Score,
      'team2_score': team2Score,
      'running_time': runningTime,
      'total_time': totalTime,
    };
  }
}
