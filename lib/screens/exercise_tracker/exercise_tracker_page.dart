import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new/Services/exercise_service.dart';
import 'package:flutter_new/models/exercise_model.dart';
import 'package:flutter_new/screens/authentication/login_page.dart';
import 'package:flutter_new/screens/exercise_tracker/exercise_list_Item.dart';
import 'package:flutter_new/screens/exercise_tracker/widgets/search_bar.dart';
import 'package:flutter_new/screens/home/home.dart';
import 'package:shimmer/shimmer.dart';


class ExerciseTrackerPage extends StatefulWidget {
  const ExerciseTrackerPage({super.key});

  @override
  _ExerciseTrackerPageState createState() => _ExerciseTrackerPageState();
}

class _ExerciseTrackerPageState extends State<ExerciseTrackerPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEdit = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();
  final ExerciseService _exerciseService = ExerciseService();
  List<Exercise> _exerciseHistory = [];
  final double _drawerIconSize = 24;
  final double _drawerFontSize = 17;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExerciseHistory();
  }

  Future<void> _loadExerciseHistory() async {
    setState(() {
      _isLoading = true;
    });

    List<Exercise> exercises = await _exerciseService.getExerciseHistory();

    setState(() {
      _exerciseHistory = exercises;
      _isLoading = false;
    });
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
      Navigator.of(context).pop();
    }
  }

  void _deleteExercise(Exercise exercise) {
    _exerciseService.deleteExercise(exercise.id);
    _loadExerciseHistory();
  }

  showAddForm() {
    showDialog(
        context: context,
        builder: (context) {
          var size = MediaQuery.of(context).size;
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            title: const Center(
              child: Text(
                "Add Exercise",
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            content: SizedBox(
              height: 280,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: size.height * .34,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          20.0,
                        ),
                      ),
                      color: Color(0xFFC7B8F5),
                      image: DecorationImage(
                        image: AssetImage("assets/images/meditation_bg.png"),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _timeController,
                            decoration:
                                const InputDecoration(labelText: 'Time (min)'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the time';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _repetitionsController,
                            decoration:
                                const InputDecoration(labelText: 'Repetitions'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the repetitions';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC7B8F5),
                  ),
                  onPressed: _addExercise,
                  child: const Text('ADD EXERCISE'),
                ),
              )
            ],
          );
        });
  }

  showEditForm(Exercise exercise) {
    showDialog(
        context: context,
        builder: (context) {
          var size = MediaQuery.of(context).size;
          final TextEditingController editNameController =
              TextEditingController(text: exercise.name);
          final TextEditingController editTimeController =
              TextEditingController(text: exercise.time.toString());
          final TextEditingController editRepetitionsController =
              TextEditingController(text: exercise.repetitions.toString());
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            title: const Text(
              "Edit Exercise",
              style: TextStyle(fontSize: 24.0),
            ),
            content: Stack(
              children: [
                Container(
                  height: size.height * .34,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        20.0,
                      ),
                    ),
                    color: Colors.green,
                    image: DecorationImage(
                      image: AssetImage("assets/images/meditation_bg.png"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKeyEdit,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: editNameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: editTimeController,
                          decoration:
                              const InputDecoration(labelText: 'Time (min)'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a time';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: editRepetitionsController,
                          decoration:
                              const InputDecoration(labelText: 'Repetitions'),
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
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // background
                    foregroundColor: Colors.white, // foreground
                  ),
                  child: const Text('SAVE'),
                  onPressed: () {
                    if (_formKeyEdit.currentState!.validate()) {
                      Exercise editedExercise = Exercise(
                        id: exercise.id,
                        name: editNameController.text,
                        time: int.parse(editTimeController.text),
                        repetitions: int.parse(editRepetitionsController.text),
                        timestamp: exercise.timestamp,
                      );
                      _exerciseService.updateExercise(editedExercise);
                      _loadExerciseHistory();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // background
                    foregroundColor: Colors.white, // foreground
                  ),
                  child: const Text('CANCEL'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Exercise Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
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
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
        ],
      ),
      body: Stack(children: <Widget>[
        Container(
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: const [0.0, 1.0],
                tileMode: TileMode.clamp),
            image: const DecorationImage(
              image: AssetImage("assets/images/mult_exercise.png"),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: size.width * .6,
                  child: const SearchBar(),
                ),
              ),
              Expanded(
                  child: _isLoading
                      ? ListView.builder(
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(10),
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(13),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(0, 17),
                                    blurRadius: 23,
                                    spreadRadius: -13,
                                    color: Color(0xFFE6E6E6),
                                  ),
                                ],
                              ),
                              child: Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(255, 109, 109, 109),
                                highlightColor: Colors.grey,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(width: 50, height: 50),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            height: 10,
                                            color: Colors.white,
                                          ),
                                          Container(
                                            width: 80,
                                            height: 10,
                                            color: Colors.white,
                                          ),
                                          Container(
                                            width: 100,
                                            height: 10,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const SizedBox(width: 50, height: 50),
                                  ],
                                ),
                              ),
                            );
                          })
                      : AnimatedList(
                          key: _listKey,
                          initialItemCount: _exerciseHistory.length,
                          itemBuilder: (context, index, animation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(-1, 0),
                                end: const Offset(0, 0),
                              ).animate(animation),
                              child: ExerciseListItem(
                                exercise: _exerciseHistory[index],
                                onDelete: () =>
                                    _deleteExercise(_exerciseHistory[index]),
                                onEdit: () =>
                                    showEditForm(_exerciseHistory[index]),
                              ),
                            );
                          },
                        )),
            ],
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddForm();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
