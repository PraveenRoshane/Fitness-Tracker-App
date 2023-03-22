import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_new/screens/home/home.dart';
import 'package:flutter_new/screens/progress_tracker/add_progress.dart';
import 'package:flutter_new/screens/progress_tracker/progress_calendar/progress_calendar_home.dart';
//import 'package:flutter_new/screens/progress_tracker/progress_calendar/progress_calendar_home.dart';
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
    var size = MediaQuery.of(context).size;

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
            child: Container(
              child: InkWell(
                child: Icon(
                  Icons.calendar_month,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarHomePage(),
                      ));
                },
              ),
            ),
          ),
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
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ]),
          image: const DecorationImage(
            image: AssetImage("assets/images/progressbackground.jpg"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: FutureBuilder<QuerySnapshot>(
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
                      startdate: e['startdate'],
                      milestonecount: e['milestonecount']))
                  .toList();
              return _getBody(workoutmodel);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddGoal()));
        }),
        backgroundColor: Colors.white,
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
            itemBuilder: (context, index) => Container(
              height: 120,
              margin: const EdgeInsets.symmetric(vertical: 7),
              padding: const EdgeInsets.all(8),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          workoutmodel[index].goal,
                        ),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Date:${workoutmodel[index].startdate}',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Target Date:${workoutmodel[index].targetdate}',
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        radius: 25,
                        child: Text('${workoutmodel[index].milestonecount}'),
                      ),
                      trailing: SizedBox(
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
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
                                                workoutmodel:
                                                    workoutmodel[index])));
                                  },
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onTap: () async {
                                    final delete = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title:
                                                  const Text("Delete Event?"),
                                              content: const Text(
                                                  "Are you sure you want to delete?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.black,
                                                  ),
                                                  child: const Text("No"),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                  ),
                                                  child: const Text("Yes"),
                                                ),
                                              ],
                                            ));
                                    if (delete ?? false) {
                                      _reference
                                          .doc(workoutmodel[index].id)
                                          .delete();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProgressHomePage(),
                                          ));
                                    }
                                  },
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
