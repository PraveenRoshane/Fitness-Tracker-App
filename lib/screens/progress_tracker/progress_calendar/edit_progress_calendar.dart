import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/progress_calendar_model.dart';

class EditProgressCalendar extends StatefulWidget {
  final DateTime startDate;
  final DateTime targetDate;
  final Event event;
  const EditProgressCalendar(
      {Key? key,
      required this.startDate,
      required this.targetDate,
      required this.event})
      : super(key: key);

  @override
  State<EditProgressCalendar> createState() => _EditProgressCalendarState();
}

class _EditProgressCalendarState extends State<EditProgressCalendar> {
  late DateTime _selectedDate;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.event.date;
    _titleController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Milestone",
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
            controller: _descController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'description'),
          ),
          ElevatedButton(
            onPressed: () {
              _editEvent();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Successfully Updated Milestone")));
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.teal.shade400,
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

  void _editEvent() async {
    final title = _titleController.text;
    final description = _descController.text;
    if (title.isEmpty) {
      print('title cannot be empty');
      return;
    }
    await FirebaseFirestore.instance
        .collection('progress calendar')
        .doc(widget.event.id)
        .update({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(_selectedDate),
    });
    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
