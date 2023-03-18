import 'package:cloud_firestore/cloud_firestore.dart';

class Weight {
  String id;
  final String date;
  final int age;
  final num weight;


  Weight({
    required this.id,
    required this.date,
    required this.age,
    required this.weight,


  });

  factory Weight.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Weight(
      id: snapshot.id,

      date: snapshot.data()?['date'],
      age: snapshot.data()?['age'],
      weight: snapshot.data()?['weight'],


    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'age': age,
      'weight': weight,


    };
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "age": age,
    "date": date,
    "weight": weight,

  };
  factory Weight.fromJson(Map<String, dynamic> json) => Weight(
    id: json["id"],
    age: json["age"],
    date: json["date"],
    weight: json["weight"].toDouble(),



  );

}
