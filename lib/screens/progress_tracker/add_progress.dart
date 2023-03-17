import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter_new/models/progress_model.dart';
import 'package:flutter_new/screens/progress_tracker/progress_home.dart';

class AddGoal extends StatefulWidget {
  const AddGoal({super.key});

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController goalcontroller = TextEditingController();
  final TextEditingController targetdatecontroller = TextEditingController();
  final TextEditingController startdatecontroller = TextEditingController();
  final TextEditingController milestonecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Goal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ])),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              top: 16,
              right: 16,
            ),
            child: Stack(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 20),
          getField(hintText: 'Goal', controller: goalcontroller),
          getField(hintText: 'Start Date', controller: startdatecontroller),
          getField(hintText: 'Target Date', controller: targetdatecontroller),
          getField(
              hintText: 'Number of Milestones',
              controller: milestonecontroller),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 200.0,
                height: 50.0,
                child: ElevatedButton(
                    onPressed: () {
                      Workoutmodel workout = Workoutmodel(
                          goal: goalcontroller.text,
                          targetdate: targetdatecontroller.text,
                          startdate: startdatecontroller.text,
                          milestonecount: int.parse(milestonecontroller.text));
                      addNavigateHome(workout, context);
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(
                width: 200.0,
                height: 50.0,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () {
                      goalcontroller.text = '';
                      targetdatecontroller.text = '';
                      startdatecontroller.text = '';
                      milestonecontroller.text = '';
                    },
                    child: const Text(
                      "Reset",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          )
        ]),
      ),
    );
  }

  Widget getField(
      {required String hintText, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: 'Enter $hintText',
            labelText: hintText,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))),
      ),
    );
  }

  void addNavigateHome(Workoutmodel workout, BuildContext context) {
    final workoutRef =
        FirebaseFirestore.instance.collection('workout progress').doc();
    workout.id = workoutRef.id;
    final data = workout.toJson();
    workoutRef.set(data).whenComplete(() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProgressHomePage()),
        (route) => false,
      );
    });
  }
}
