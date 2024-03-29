import 'package:flutter/material.dart';
import 'package:flutter_new/models/exercise_model.dart';
import 'package:intl/intl.dart';

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final Function onDelete;
  final Function onEdit;

  const ExerciseListItem(
      {super.key,
      required this.exercise,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      height: 100,
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
      child: Row(
        children: <Widget>[
          const Image(
            image: AssetImage("assets/images/running.png"),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  selectionColor: Colors.grey,
                ),
                Text(
                  '${exercise.time} minutes',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${exercise.repetitions} repetitions',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(
                      DateTime.parse(exercise.timestamp.toDate().toString())),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  color: Colors.green,
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit as void Function()?,
                ),
                IconButton(
                  color: Colors.red,
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete as void Function()?,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
