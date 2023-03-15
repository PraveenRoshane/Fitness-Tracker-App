import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_new/screens/progress_tracker/progress_home.dart';

import '../../models/progress_model.dart';

class UpdateGoal extends StatelessWidget {
  final Workoutmodel workoutmodel;
  final TextEditingController goalcontroller = TextEditingController();
  final TextEditingController targetdatecontroller = TextEditingController();
  final TextEditingController milestonecontroller = TextEditingController();

  UpdateGoal({super.key, required this.workoutmodel});

  @override
  Widget build(BuildContext context) {
    goalcontroller.text = workoutmodel.goal;
    targetdatecontroller.text = workoutmodel.targetdate;
    milestonecontroller.text = workoutmodel.milestones;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Goal'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            getField(hintText: 'Goal', controller: goalcontroller),
            getField(hintText: 'Target Date', controller: targetdatecontroller),
            getField(hintText: 'Milestone', controller: milestonecontroller),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Workoutmodel updatedworkout = Workoutmodel(
                          id: workoutmodel.id,
                          goal: goalcontroller.text,
                          targetdate: targetdatecontroller.text,
                          milestones: milestonecontroller.text);
                      final collectionRefernece = FirebaseFirestore.instance
                          .collection('workout progress');
                      collectionRefernece
                          .doc(updatedworkout.id)
                          .update(updatedworkout.toJson())
                          .whenComplete(() {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProgressHomePage()));
                      });
                    },
                    child: const Text("Update")),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () {
                      goalcontroller.text = '';
                      targetdatecontroller.text = '';
                      milestonecontroller.text = '';
                    },
                    child: const Text("Reset")),
              ],
            )
          ]),
        ));
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
}
