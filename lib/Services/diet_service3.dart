import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_new/models/diet_model3.dart';

class DietService3 {
  final CollectionReference _dietsCollection =
      FirebaseFirestore.instance.collection('diets_wednesday');

  Future<List<Diet3>> getDietHistory() async {
    QuerySnapshot snapshot = await _dietsCollection.get();
    List<Diet3> dietHistory = snapshot.docs
        .map((doc) => Diet3.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
    return dietHistory;
  }

  Future<String> addDiet(Diet3 diet3) async {
    DocumentReference docRef = await _dietsCollection.add(diet3.toMap());
    return docRef.id;
  }

  void deleteDiet(String id) {
    _dietsCollection.doc(id).delete();
  }

  void updateDiet(Diet3 diet3) {
    _dietsCollection.doc(diet3.id).update(diet3.toMap());
  }
}
