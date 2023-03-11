import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String id;
  final String name;
  final int time;
  final int repetitions;
  Timestamp timestamp;

  Exercise({
    required this.id,
    required this.name,
    required this.time,
    required this.repetitions,
    required this.timestamp,
  });

  factory Exercise.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Exercise(
      id: snapshot.id,
      name: snapshot.data()?['name'],
      time: snapshot.data()?['time'],
      repetitions: snapshot.data()?['repetitions'],
      timestamp: snapshot.data()?['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
      'repetitions': repetitions,
      'timestamp': timestamp,
    };
  }
}
