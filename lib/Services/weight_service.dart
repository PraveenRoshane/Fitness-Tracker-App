
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

  // Future<String> addWeight(Weight weight) async {
  //   DocumentReference docRef = await _weightCollection.add(weight.toMap());
  //   return docRef.id;
  // }


  void deleteWeight(String id) {
    _weightCollection.doc(id).delete();
  }


  void updateWeight(Weight weight) {
    _weightCollection.doc(weight.id).update(weight.toMap());
  }

  // addWeightAndNavigateToHome(Weight weight, BuildContext context) {
  //   //
  //   // Reference to firebase
  //   final weightRef = FirebaseFirestore.instance.collection('weights').doc();
  //   weight.id = weightRef.id;
  //   final data = weight.toJson();
  //   weightRef.set(data).whenComplete(() {
  //     //
  //     log('User inserted.');
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => HomePage(),
  //       ),
  //           (route) => false,
  //     );
  //     //
  //   });
  //
  //   //
  // }
}
