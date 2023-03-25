import 'package:cloud_firestore/cloud_firestore.dart';

class Diet3 {
  String id;
  final String mealType;
  final String foodItem;
  final String quantity;

  Diet3({
    required this.id,
    required this.mealType,
    required this.foodItem,
    required this.quantity,
  });

  factory Diet3.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Diet3(
      id: snapshot.id,
      mealType: snapshot.data()?['mealType'],
      foodItem: snapshot.data()?['foodItem'],
      quantity: snapshot.data()?['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mealType': mealType,
      'foodItem': foodItem,
      'quantity': quantity,
    };
  }
}
