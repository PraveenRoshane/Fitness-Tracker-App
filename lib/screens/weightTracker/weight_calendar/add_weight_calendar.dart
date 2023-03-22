import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddWeightCalendar extends StatefulWidget {
  final DateTime startDate;
  final DateTime targetDate;
  final DateTime? selectedDate;
  const AddWeightCalendar(
      {Key? key,
      required this.startDate,
      required this.targetDate,
      this.selectedDate})
      : super(key: key);

  @override
  State<AddWeightCalendar> createState() => _AddWeightCalendarState();
}

class _AddWeightCalendarState extends State<AddWeightCalendar> {
  late DateTime _selectedDate;
  final _titleController = TextEditingController();
  final _recController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Reason",
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          InputDatePickerFormField(
            firstDate: widget.startDate,
            lastDate: widget.targetDate,
            initialDate: _selectedDate,
            onDateSubmitted: (date) {
              print(date);
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          TextField(
            controller: _titleController,
            maxLines: 1,
            decoration: const InputDecoration(labelText: 'title'),
          ),
          TextField(
            controller: _recController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'reason'),
          ),
          ElevatedButton(
            onPressed: () {
              _addEvent();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
            ),
            child: const Text(
              "Save",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _addEvent() async {
    final title = _titleController.text;
    final reason = _recController.text;
    if (title.isEmpty) {
      print('title cannot be empty');
      return;
    }
    await FirebaseFirestore.instance.collection('weightCalendar').add({
      "title": title,
      "reason": reason,
      "date": Timestamp.fromDate(_selectedDate),
    });
    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
