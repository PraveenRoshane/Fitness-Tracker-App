import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_new/Services/weight_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_new/models/weight_modal.dart';
import 'package:flutter_new/screens/weightTracker/home_page.dart';


class AddWeight extends StatefulWidget {
  const AddWeight({super.key});

  @override
  State<AddWeight> createState() => _AddWeightState();
}


class _AddWeightState extends State<AddWeight> {

  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  List<Weight> _weightHistory = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEdit = GlobalKey<FormState>();
  final WeightService _weightService = WeightService();

  bool _isLoading = false;

  void initState() {
    super.initState();
    _loadWeightHistory();
  }
  Future<void> _loadWeightHistory() async {
    setState(() {
      _isLoading = true;
    });

    List<Weight> weights = await _weightService.getWeightHistory();

    setState(() {
      _weightHistory = weights;
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Weight'),
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
      body: SingleChildScrollView(


        child: Column(
          children: [
            const SizedBox(height: 20),
            getMyField(
                focusNode: focusNode,
                hintText: 'Age',
                textInputType: TextInputType.number,
                controller: _rollController),

            getMyField(hintText: 'Date', controller: _nameController),
            getMyField(

                hintText: 'Weight',
                textInputType: TextInputType.number,
                controller: _weightController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      //
                      Weight weight = Weight(
                        age: int.parse(_rollController.text),
                        date: _nameController.text,
                        weight: double.parse(_weightController.text), id: '',
                       // date: DateTime.now(),
                        //time: int.parse(_timeController.text), id: '',
                      );

                      // ToDO: Adding a Weight

                      addWeightAndNavigateToHome(weight,context);
                      //
                    },
                    child: const Text('Add')),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      _rollController.text = '';
                      _nameController.text = '';
                      _weightController.text = '';
                      focusNode.requestFocus();
                    },
                    child: const Text('Reset')),
              ],
            )
          ],
            )
      ),
    );
  }

  Widget getMyField(
      {required String hintText,
      TextInputType textInputType = TextInputType.datetime,
      required TextEditingController controller,
      FocusNode? focusNode}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
            hintText: 'Enter $hintText',
            labelText: hintText,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))),
      ),
    );
  }

void addWeightAndNavigateToHome(Weight weight, BuildContext context) {
    //
    // Reference to firebase
    final weightRef = FirebaseFirestore.instance.collection('weights').doc();
    weight.id = weightRef.id;
    final data = weight.toJson();
    weightRef.set(data).whenComplete(() {
      //
      log('User inserted.');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SearchBar(),
        ),
        (route) => false,
      );
    });

    //
  }
}
