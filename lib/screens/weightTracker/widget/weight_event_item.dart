import 'package:flutter/material.dart';

import '../../../models/weight_calendar_model.dart';

class WeightEventItem extends StatelessWidget {
  final WeightEvent event;
  final Function() onDelete;
  final Function()? onTap;
  const WeightEventItem({
    Key? key,
    required this.event,
    required this.onDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        event.title,
      ),
      subtitle: Text(
        event.date.toString(),
      ),
      onTap: onTap,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        color: Colors.red,
        onPressed: onDelete,
      ),
    );
  }
}
