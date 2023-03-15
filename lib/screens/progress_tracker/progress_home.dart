import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_new/screens/home/home.dart';
//import 'package:flutter_application_1/workoutcalender.dart';
import 'package:flutter_new/screens/progress_tracker/add_progress.dart';
import 'package:flutter_new/screens/progress_tracker/update_progress.dart';
import '../../models/progress_model.dart';
import '../authentication/login_page.dart';

class ProgressHomePage extends StatelessWidget {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('workout progress');
  final double _drawerIconSize = 24;
  final double _drawerFontSize = 17;

  /*List<Workoutmodel> progress = [
    Workoutmodel(
        goal: 'goal1', targetdate: '02-03-2022', milestones: 'milestones'),
    Workoutmodel(
        goal: 'goal2', targetdate: '02-03-2022', milestones: 'milestones'),
    Workoutmodel(
        goal: 'goal3', targetdate: '02-03-2022', milestones: 'milestones')
  ];*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Progress Manager',
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
        centerTitle: true,
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
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [
                0.0,
                1.0
              ],
                  colors: [
                Theme.of(context).primaryColor.withOpacity(0.2),
                Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              ])),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 1.0],
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: const Text(
                    "Fitness Tracker",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.home_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _reference.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;
            List<Workoutmodel> workoutmodel = documents
                .map((e) => Workoutmodel(
                    id: e['id'],
                    goal: e['goal'],
                    targetdate: e['targetdate'],
                    milestones: e['milestones']))
                .toList();
            return _getBody(workoutmodel);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddGoal()));
        }),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _getBody(workoutmodel) {
    return workoutmodel.isEmpty
        ? const Center(
            child: Text('Click "+" button to add a new workout goal'),
          )
        : ListView.builder(
            itemCount: workoutmodel.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(workoutmodel[index].goal),
                subtitle: Text('Target Date:${workoutmodel[index].targetdate}'),
                leading: CircleAvatar(
                  radius: 25,
                  child: Text(''),
                ),
                trailing: SizedBox(
                    width: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateGoal(
                                          workoutmodel: workoutmodel[index])));
                            },
                          ),
                          InkWell(
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onTap: () {
                              _reference.doc(workoutmodel[index].id).delete();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProgressHomePage(),
                                  ));
                            },
                          ),
                          InkWell(
                            child: Icon(
                              Icons.calendar_month,
                              color: Colors.black,
                            ),
                            onTap: () {
                              /*Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutCalendar(),
                                  ));*/
                            },
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          );
  }
}
