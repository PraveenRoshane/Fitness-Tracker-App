import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_new/models/weight_modal.dart';


class WeightService {
  final CollectionReference _weightCollection =
  FirebaseFirestore.instance.collection('weights');

  Future<List<Weight>> getWeightHistory() async {
    QuerySnapshot snapshot = await _weightCollection.get();
    List<Weight> weightHistory = snapshot.docs
        .map((doc) => Weight.fromSnapshot(
        doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
    return weightHistory;
  }
  void deleteWeight(String id) {
    _weightCollection.doc(id).delete();
  }


  void updateWeight(Weight weight) {
    _weightCollection.doc(weight.id).update(weight.toMap());
  }
}
