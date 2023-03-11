import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_new/models/exercise_model.dart';

class ExerciseService {
  final CollectionReference _exercisesCollection =
      FirebaseFirestore.instance.collection('exercises');

  Future<List<Exercise>> getExerciseHistory() async {
    QuerySnapshot snapshot = await _exercisesCollection.get();
    List<Exercise> exerciseHistory = snapshot.docs
        .map((doc) => Exercise.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
    return exerciseHistory;
  }

  Future<String> addExercise(Exercise exercise) async {
    DocumentReference docRef = await _exercisesCollection.add(exercise.toMap());
    return docRef.id;
  }

  void deleteExercise(String id) {
    _exercisesCollection.doc(id).delete();
  }

  void updateExercise(Exercise exercise) {
    _exercisesCollection.doc(exercise.id).update(exercise.toMap());
  }
}
