import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new/Services/diet_service.dart';
import 'package:flutter_new/models/diet_model.dart';
import 'package:flutter_new/screens/authentication/login_page.dart';
import 'package:flutter_new/screens/diet_tracker/diet_list_item.dart';
import 'package:flutter_new/screens/diet_tracker/widgets/search_bar.dart';
import 'package:flutter_new/screens/home/home.dart';
import 'package:shimmer/shimmer.dart';

class DietTrackerPage extends StatefulWidget {
  const DietTrackerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DietTrackerPageState createState() => _DietTrackerPageState();
}

class _DietTrackerPageState extends State<DietTrackerPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEdit = GlobalKey<FormState>();
  final TextEditingController _mealTypeController = TextEditingController();
  final TextEditingController _foodItemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  final DietService _dietService = DietService();
  List<Diet> _dietHistory = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDietHistory();
  }

  Future<void> _loadDietHistory() async {
    setState(() {
      _isLoading = true;
    });

    List<Diet> diets = await _dietService.getDietHistory();

    setState(() {
      _dietHistory = diets;
      _isLoading = false;
    });
  }

  Future<void> _addDiet() async {
    if (_formKey.currentState!.validate()) {
      Diet diet = Diet(
        mealType: _mealTypeController.text,
        foodItem: _foodItemController.text,
        quantity: _quantityController.text,
        calorie: int.parse(_calorieController.text),
        
        id: '',
      );
      await _dietService.addDiet(diet);
      _loadDietHistory();
      _mealTypeController.clear();
      _foodItemController.clear();
      _quantityController.clear();
      _calorieController.clear();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  void _deleteDiet(Diet diet) {
    _dietService.deleteDiet(diet.id);
    _loadDietHistory();
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
                "Add Diet Plan",
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
                      
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _mealTypeController,
                            decoration:
                                const InputDecoration(labelText: 'Meal Type'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a meal type';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _foodItemController,
                            decoration:
                                const InputDecoration(labelText: 'Food Item'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the Food Item';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _quantityController,
                            decoration:
                                const InputDecoration(labelText: 'Quantity'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the quantity';
                              }
                              return null;
                            },
                          ),
                             TextFormField(
                            controller: _calorieController,
                            decoration:
                                const InputDecoration(labelText: 'Calories'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the calories';
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
                  onPressed: _addDiet,
                  child: const Text('ADD DIET'),
                ),
              )
            ],
          );
        });
  }

  showEditForm(Diet diet) {
    showDialog(
        context: context,
        builder: (context) {
          var size = MediaQuery.of(context).size;
          final TextEditingController editmealTypeController =
              TextEditingController(text: diet.mealType);
          final TextEditingController editfoodItemController =
              TextEditingController(text: diet.foodItem);
          final TextEditingController editquantityController =
              TextEditingController(text: diet.quantity);
          final TextEditingController editcalorieController =
              TextEditingController(text: diet.calorie.toString());
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            title: const Text(
              "Edit Diet Plan",
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
                    color: Color.fromARGB(255, 157, 101, 192),
                    image: DecorationImage(
                      image: AssetImage("assets/images/diet.png"),
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
                          controller: editmealTypeController,
                          decoration: const InputDecoration(labelText: 'Meal Type'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a meal type';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: editfoodItemController,
                          decoration:
                              const InputDecoration(labelText: 'Food Item'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a food Item';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: editquantityController,
                          decoration:
                              const InputDecoration(labelText: 'Quantity'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a quantity';
                            }
                            return null;
                          },
                        ),
                         const SizedBox(height: 15),
                        TextFormField(
                          controller: editcalorieController,
                          decoration:
                              const InputDecoration(labelText: 'Calories'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a calories';
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
                    backgroundColor: const Color.fromARGB(255, 234, 169, 241), // background
                    foregroundColor: Colors.white, // foreground
                  ),
                  child: const Text('SAVE'),
                  onPressed: () {
                    if (_formKeyEdit.currentState!.validate()) {
                      Diet editedDiet = Diet(
                        id: diet.id,
                        mealType: editmealTypeController.text,
                        foodItem: editfoodItemController.text,
                        quantity: editquantityController.text,
                        calorie: int.parse(editcalorieController.text),
                        
                      );
                      _dietService.updateDiet(editedDiet);
                      _loadDietHistory();
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
          "Diet Tracker",
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
              image: AssetImage("assets/images/nutritionist.png"),
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
                          initialItemCount: _dietHistory.length,
                          itemBuilder: (context, index, animation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(-1, 0),
                                end: const Offset(0, 0),
                              ).animate(animation),
                              child: DietListItem(
                                diet: _dietHistory[index],
                                onDelete: () =>
                                    _deleteDiet(_dietHistory[index]),
                                onEdit: () =>
                                    showEditForm(_dietHistory[index]),
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
