import 'package:cloud_firestore/cloud_firestore.dart';

class Diet {
  String id;
  final String mealType;
  final String foodItem;
  final String quantity;

  Diet({
    required this.id,
    required this.mealType,
    required this.foodItem,
    required this.quantity,
  });

  factory Diet.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Diet(
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
