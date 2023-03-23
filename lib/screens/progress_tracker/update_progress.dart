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
  final TextEditingController startdatecontroller = TextEditingController();
  final TextEditingController milestonecontroller = TextEditingController();

  UpdateGoal({super.key, required this.workoutmodel});

  @override
  Widget build(BuildContext context) {
    goalcontroller.text = workoutmodel.goal;
    targetdatecontroller.text = workoutmodel.targetdate;
    startdatecontroller.text = workoutmodel.startdate;
    milestonecontroller.text = '${workoutmodel.milestonecount}';
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Update Progress',
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
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
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
                        Workoutmodel updatedworkout = Workoutmodel(
                            id: workoutmodel.id,
                            goal: goalcontroller.text,
                            targetdate: targetdatecontroller.text,
                            startdate: startdatecontroller.text,
                            milestonecount:
                                int.parse(milestonecontroller.text));
                        final collectionRefernece = FirebaseFirestore.instance
                            .collection('workout progress');
                        collectionRefernece
                            .doc(updatedworkout.id)
                            .update(updatedworkout.toJson())
                            .whenComplete(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Successfully Updated Progress!")));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProgressHomePage()));
                        });
                      },
                      child: const Text(
                        "Update",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ),
                SizedBox(
                  width: 200.0,
                  height: 50.0,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
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
