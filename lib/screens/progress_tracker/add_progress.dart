import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter_new/models/progress_model.dart';
import 'package:flutter_new/screens/progress_tracker/progress_home.dart';
import 'package:intl/intl.dart';

class AddGoal extends StatefulWidget {
  const AddGoal({super.key});

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final formKey = GlobalKey<FormState>();
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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
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
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(children: [
            const SizedBox(height: 20),
            getField(hintText: 'Goal', controller: goalcontroller),
            getCalendarField(
                hintText: 'Start Date', controller: startdatecontroller),
            getCalendarField(
                hintText: 'Target Date', controller: targetdatecontroller),
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
                        if (formKey.currentState!.validate()) {
                          Workoutmodel workout = Workoutmodel(
                              goal: goalcontroller.text,
                              targetdate: targetdatecontroller.text,
                              startdate: startdatecontroller.text,
                              milestonecount:
                                  int.parse(milestonecontroller.text));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Successfully Added Progress Goal!")));
                          addNavigateHome(workout, context);
                        }
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
        ),
      ),
    );
  }

  Widget getField(
      {required String hintText, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              hintText: 'Enter $hintText',
              labelText: hintText,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)))),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please fill all the fields!";
            } else {
              return null;
            }
          }),
    );
  }

  Widget getCalendarField(
      {required String hintText, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              hintText: 'Enter $hintText',
              labelText: hintText,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)))),
          onTap: () async {
            DateTime? pickeddate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101));

            if (pickeddate != null) {
              setState(() {
                controller.text = DateFormat('yyyy-MM-dd').format(pickeddate);
              });
            }
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "Please fill all the fields!";
            } else {
              return null;
            }
          }),
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
