import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_new/models/diet_model.dart';

class DietService {
  final CollectionReference _dietsCollection =
      FirebaseFirestore.instance.collection('diets');

  Future<List<Diet>> getDietHistory() async {
    QuerySnapshot snapshot = await _dietsCollection.get();
    List<Diet> dietHistory = snapshot.docs
        .map((doc) => Diet.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
    return dietHistory;
  }

  Future<String> addDiet(Diet diet) async {
    DocumentReference docRef = await _dietsCollection.add(diet.toMap());
    return docRef.id;
  }

  void deleteDiet(String id) {
    _dietsCollection.doc(id).delete();
  }

  void updateDiet(Diet diet) {
    _dietsCollection.doc(diet.id).update(diet.toMap());
  }
}
