class Workoutmodel {
  Workoutmodel({
    this.id,
    required this.goal,
    required this.targetdate,
    required this.startdate,
    required this.milestonecount,
  });

  String? id;
  final String goal;
  final String targetdate;
  final String startdate;
  final int milestonecount;

  factory Workoutmodel.fromJson(Map<String, dynamic> json) => Workoutmodel(
        id: json["id"],
        goal: json["goal"],
        targetdate: json["targetdate"],
        startdate: json["startdate"],
        milestonecount: json["milestonecount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "goal": goal,
        "targetdate": targetdate,
        "startdate": startdate,
        "milestonecount": milestonecount,
      };
}
