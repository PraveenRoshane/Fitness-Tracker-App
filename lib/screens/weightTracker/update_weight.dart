import 'dart:developer';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_new/models/weight_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new/models/weight_modal.dart';
import 'package:flutter_new/screens/home/home.dart';
import 'package:flutter_new/screens/weightTracker/home_page.dart';


class UpdateWeight extends StatelessWidget {
  final Weight weight;
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  // final TextEditingController _dateController = TextEditingController();
  // final TextEditingController _timeController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  UpdateWeight({super.key, required this.weight});

  @override
  Widget build(BuildContext context) {
    _rollController.text = '${weight.age}';
    _nameController.text = weight.date;
    _weightController.text = '${weight.weight}';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Weight'),
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

                hintText: 'Age',
                controller: _rollController),
            getMyField(hintText: 'Date', controller: _nameController),
            getMyField(
                hintText: 'Weight',
                controller: _weightController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      //
                      // ToDO: Update a weight
                      Weight updatedWeight = Weight(
                        id: weight.id,
                        age: int.parse(_rollController.text),
                        date: _nameController.text,
                        weight: double.parse(_weightController.text),
                        //date: DateTime.now(),
                        //time: int.parse(_timeController.text)
                      );
                      //
                      final collectionReference =
                      FirebaseFirestore.instance.collection('weights');
                      collectionReference
                          .doc(updatedWeight.id)
                          .update(updatedWeight.toJson())
                          .whenComplete(() {
                        log('Weight Updated');
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchBar(),
                            ));
                      });
                      //
                    },
                    child: const Text('Update')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      //
                      _rollController.text = '';
                      _nameController.text = '';
                      _weightController.text = '';
                     // _dateController.text = '';
                     // _timeController.text = '';
                      focusNode.requestFocus();
                      //
                    },
                    child: const Text('Reset')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getMyField(
      {required String hintText,

        required TextEditingController controller,
        FocusNode? focusNode}) {
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
