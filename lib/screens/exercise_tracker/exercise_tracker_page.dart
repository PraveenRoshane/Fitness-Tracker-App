import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_new/Services/exercise_service.dart';
import 'package:flutter_new/models/exercise_model.dart';
import 'package:flutter_new/screens/authentication/login_page.dart';
import 'package:flutter_new/screens/home/home.dart';

class ExerciseTrackerPage extends StatefulWidget {
  const ExerciseTrackerPage({super.key});

  @override
  _ExerciseTrackerPageState createState() => _ExerciseTrackerPageState();
}

class _ExerciseTrackerPageState extends State<ExerciseTrackerPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();
  final ExerciseService _exerciseService = ExerciseService();
  List<Exercise> _exerciseHistory = [];
  final EventList<Event> _events = EventList<Event>(events: {});
  final double _drawerIconSize = 24;
  final double _drawerFontSize = 17;

  @override
  void initState() {
    super.initState();
    _loadExerciseHistory();
  }

  Future<void> _loadExerciseHistory() async {
    List<Exercise> exercises = await _exerciseService.getExerciseHistory();
    setState(() {
      _exerciseHistory = exercises;
      _updateEventList();
    });
  }

  void _updateEventList() {
    _events.clear();
    for (var exercise in _exerciseHistory) {
      DateTime exerciseDate = exercise.timestamp.toDate();
      _events.add(
        exerciseDate,
        Event(
          date: exerciseDate,
          title: exercise.name,
          icon: const Icon(Icons.fitness_center),
        ),
      );
    }
  }

  Future<void> _addExercise() async {
    if (_formKey.currentState!.validate()) {
      Exercise exercise = Exercise(
        name: _nameController.text,
        time: int.parse(_timeController.text),
        repetitions: int.parse(_repetitionsController.text),
        timestamp: Timestamp.now(),
        id: '',
      );
      await _exerciseService.addExercise(exercise);
      _loadExerciseHistory();
      _nameController.clear();
      _timeController.clear();
      _repetitionsController.clear();
    }
  }

  void _deleteExercise(Exercise exercise) {
    _exerciseService.deleteExercise(exercise.id);
    _loadExerciseHistory();
  }

  Future<void> _editExercise(Exercise exercise) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _editNameController =
            TextEditingController(text: exercise.name);
        final TextEditingController _editTimeController =
            TextEditingController(text: exercise.time.toString());
        final TextEditingController _editRepetitionsController =
            TextEditingController(text: exercise.repetitions.toString());
        return AlertDialog(
          title: const Text('Edit Exercise'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _editNameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _editTimeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a time';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _editRepetitionsController,
                  decoration: const InputDecoration(labelText: 'Repetitions'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a repetitions';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('SAVE'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Exercise editedExercise = Exercise(
                    id: exercise.id,
                    name: _editNameController.text,
                    time: int.parse(_editTimeController.text),
                    repetitions: int.parse(_editRepetitionsController.text),
                    timestamp: exercise.timestamp,
                  );
                  _exerciseService.updateExercise(editedExercise);
                  _loadExerciseHistory();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Exercise Tracker",
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
            child: Stack(
              children: <Widget>[
                const Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Add Exercise',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                        labelText: 'Time (Exercise duration in seconds)'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the time';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _repetitionsController,
                    decoration: const InputDecoration(labelText: 'Repetitions'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the repetitions';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _addExercise,
                    child: const Text('ADD EXERCISE'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Exercise History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _exerciseHistory.length,
                      itemBuilder: (BuildContext context, int index) {
                        Exercise exercise = _exerciseHistory[index];
                        return ListTile(
                          leading: const Icon(Icons.fitness_center),
                          title: Text(exercise.name),
                          subtitle: Text(
                              '${exercise.time} minutes, ${exercise.repetitions} repetitions'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editExercise(exercise),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteExercise(exercise),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 16),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: const [
          //       Text(
          //         'Exercise History by Date',
          //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //       ),
          //       SizedBox(height: 8),
          //       _selectedDate == null
          //           ? const Center(
          //               child: Text('No date selected'),
          //             )
          //           : FutureBuilder<List<Exercise>>(
          //               future:
          //                   _exerciseService.getExercisesByDate(_selectedDate),
          //               builder: (BuildContext context,
          //                   AsyncSnapshot<List<Exercise>> snapshot) {
          //                 if (snapshot.connectionState ==
          //                     ConnectionState.waiting) {
          //                   return const Center(
          //                     child: CircularProgressIndicator(),
          //                   );
          //                 } else if (snapshot.hasError) {
          //                   return Center(
          //                     child: Text('Error: ${snapshot.error}'),
          //                   );
          //                 } else if (snapshot.data!.isEmpty) {
          //                   return const Center(
          //                     child: Text('No exercises on this date'),
          //                   );
          //                 } else {
          //                   List<Exercise>? exercises = snapshot.data;
          //                   return CalendarCarousel(
          //                     weekdayTextStyle: const TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                     weekendTextStyle: const TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.red,
          //                     ),
          //                     markedDatesMap: _buildMarkedDatesMap(exercises),
          //                     onDayPressed:
          //                         (DateTime date, List<dynamic> events) {
          //                       setState(() {
          //                         _selectedDate = date;
          //                       });
          //                     },
          //                     selectedDateTime: _selectedDate,
          //                     daysHaveCircularBorder: false,
          //                     showOnlyCurrentMonthDate: true,
          //                     todayButtonColor: Theme.of(context).accentColor,
          //                     selectedDayButtonColor:
          //                         Theme.of(context).primaryColor,
          //                     selectedDayTextStyle: const TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.white,
          //                     ),
          //                     todayTextStyle: const TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.white,
          //                     ),
          //                   );
          //                 }
          //               },
          //             ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
