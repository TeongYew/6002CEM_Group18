import 'package:flutter/material.dart';
import 'package:fitness_tracker_app/model/running_goal_model.dart';

class SetGoalWidget extends StatefulWidget {
  final void Function(RunningGoal)? onGoalSet; // Updated parameter type

  SetGoalWidget({Key? key, this.onGoalSet}) : super(key: key);

  @override
  _SetGoalWidgetState createState() => _SetGoalWidgetState();
}

class _SetGoalWidgetState extends State<SetGoalWidget> {
  double _distance = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set Goal'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Distance (km)',
            ),
            onChanged: (value) {
              setState(() {
                _distance = double.tryParse(value) ?? 0.0;
              });
            },
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (widget.onGoalSet != null) {
              final goal = RunningGoal(
                distance: _distance,
              );
              widget.onGoalSet!(goal);
            }
            Navigator.of(context).pop();
          },
          child: Text('Set Goal'),
        ),
      ],
    );
  }
}