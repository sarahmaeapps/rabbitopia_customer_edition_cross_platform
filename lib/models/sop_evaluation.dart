import 'package:cloud_firestore/cloud_firestore.dart';

class SopEvaluation {
  final String id;
  final String rabbitId;
  final DateTime date;
  final double score;
  final double bodyScore;
  final double headEarScore;
  final double furScore;
  final double colorScore;
  final double conditionScore;
  final String recommendation;

  SopEvaluation({
    required this.id,
    required this.rabbitId,
    required this.date,
    required this.score,
    required this.bodyScore,
    required this.headEarScore,
    required this.furScore,
    required this.colorScore,
    required this.conditionScore,
    required this.recommendation,
  });

  factory SopEvaluation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Handle numeric date or Timestamp
    DateTime evalDate;
    var d = data['date'];
    if (d is Timestamp) {
      evalDate = d.toDate();
    } else if (d is int) {
      evalDate = DateTime.fromMillisecondsSinceEpoch(d);
    } else if (d is String) {
      evalDate = DateTime.parse(d);
    } else {
      evalDate = DateTime.now();
    }

    return SopEvaluation(
      id: doc.id,
      rabbitId: data['rabbitId'] ?? '',
      date: evalDate,
      score: (data['totalScore'] ?? 0).toDouble(),
      bodyScore: (data['bodyScore'] ?? 0).toDouble(),
      headEarScore: (data['headEarScore'] ?? 0).toDouble(),
      furScore: (data['furScore'] ?? 0).toDouble(),
      colorScore: (data['colorScore'] ?? 0).toDouble(),
      conditionScore: (data['conditionScore'] ?? 0).toDouble(),
      recommendation: data['recommendation'] ?? 'NONE',
    );
  }
}
