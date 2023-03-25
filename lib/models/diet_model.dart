import 'package:cloud_firestore/cloud_firestore.dart';

class Diet {
  String id;
  final String mealType;
  final String foodItem;
  final String quantity;
  final int calorie;
  Diet({
    required this.id,
    required this.mealType,
    required this.foodItem,
    required this.quantity,
    required this.calorie,
  });

  factory Diet.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Diet(
      id: snapshot.id,
      mealType: snapshot.data()?['mealType'],
      foodItem: snapshot.data()?['foodItem'],
      quantity: snapshot.data()?['quantity'],
      calorie: snapshot.data()?['calorie'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mealType': mealType,
      'foodItem': foodItem,
      'quantity': quantity,
      'calorie': calorie,
    };
  }
}
