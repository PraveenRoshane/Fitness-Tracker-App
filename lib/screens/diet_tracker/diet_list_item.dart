import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_new/models/diet_model.dart';

class DietListItem extends StatelessWidget {
  final Diet diet;
  final Function onDelete;
  final Function onEdit;

  const DietListItem(
      {super.key,
      required this.diet,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
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
            color: Color(0xFFE6E6E6),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          const Image(
            image: AssetImage("assets/images/strawberry.png"),
          ),
          // Positioned.fill(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          //     child: Container(
          //       color: const Color.fromARGB(255, 167, 150, 150).withOpacity(0.5),
          //     ),
          //   ),
          // ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  diet.mealType,
                  style: Theme.of(context).textTheme.titleMedium,
                  selectionColor: Colors.grey,
                ),
                Text(
                  diet.foodItem,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  diet.quantity,
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
                  color: const Color.fromARGB(255, 4, 65, 116),
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit as void Function()?,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text(
                              'Are you sure you want to delete?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const IconButton(
                    color: Color.fromARGB(255, 62, 5, 1),
                    icon: Icon(Icons.delete),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
