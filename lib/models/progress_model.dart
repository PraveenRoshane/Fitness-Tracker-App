class Workoutmodel {
  Workoutmodel({
    this.id,
    required this.goal,
    required this.targetdate,
    required this.milestones,
  });

  String? id;
  final String goal;
  final String targetdate;
  final String milestones;

  factory Workoutmodel.fromJson(Map<String, dynamic> json) => Workoutmodel(
        id: json["id"],
        goal: json["goal"],
        targetdate: json["targetdate"],
        milestones: json["milestones"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "goal": goal,
        "targetdate": targetdate,
        "milestones": milestones,
      };
}
