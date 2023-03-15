import 'package:cloud_firestore/cloud_firestore.dart';

class Weight {
  String id;
  final String name;
  final int age;
  final num weight;


  Weight({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,


  });

  factory Weight.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Weight(
      id: snapshot.id,
      name: snapshot.data()?['name'],
      age: snapshot.data()?['age'],
      weight: snapshot.data()?['weight'],


    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'weight': weight,


    };
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "age": age,
    "name": name,
    "weight": weight,

  };
  factory Weight.fromJson(Map<String, dynamic> json) => Weight(
    id: json["id"],
    age: json["age"],
    name: json["name"],
    weight: json["weight"].toDouble(),



  );

}
