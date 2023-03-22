import 'package:cloud_firestore/cloud_firestore.dart';

class WeightEvent {
  final String title;
  final String? reason;
  final DateTime date;
  final String id;
  WeightEvent({
    required this.title,
    this.reason,
    required this.date,
    required this.id,
  });

  factory WeightEvent.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return WeightEvent(
      date: data['date'].toDate(),
      title: data['title'],
      reason: data['reason'],
      id: snapshot.id,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "date": Timestamp.fromDate(date),
      "title": title,
      "reason": reason
    };
  }
}
