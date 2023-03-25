import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_new/models/diet_model2.dart';

class DietService2 {
  final CollectionReference _dietsCollection =
      FirebaseFirestore.instance.collection('diets_tuesday');

  Future<List<Diet2>> getDietHistory() async {
    QuerySnapshot snapshot = await _dietsCollection.get();
    List<Diet2> dietHistory = snapshot.docs
        .map((doc) => Diet2.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
    return dietHistory;
  }

  Future<String> addDiet(Diet2 diet2) async {
    DocumentReference docRef = await _dietsCollection.add(diet2.toMap());
    return docRef.id;
  }

  void deleteDiet(String id) {
    _dietsCollection.doc(id).delete();
  }

  void updateDiet(Diet2 diet2) {
    _dietsCollection.doc(diet2.id).update(diet2.toMap());
  }
}
