import 'package:fitness_tracker_app/model/running_activity_model.dart';
import 'package:fitness_tracker_app/set_goal_widget.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker_app/db/user_database.dart';

import 'model/running_goal_model.dart';

class RunningTrackerLog extends StatefulWidget {
  static String routeName = '/runningTrackerLog';

  @override
  _RunningTrackerLogState createState() => _RunningTrackerLogState();
}

class _RunningTrackerLogState extends State<RunningTrackerLog> {
  List<RunningActivity> _activities = [];
  RunningGoal? currentGoal;

  @override
  void initState() {
    super.initState();
    _loadActivities();
    _getCurrentGoal();
  }

  Future<void> _loadActivities() async {
    final dbHelper = UserDatabase.instance;
    final activities = await dbHelper.getActivities();

    setState(() {
      _activities = activities;
    });
  }

  Future<void> _deleteActivity(RunningActivity activity) async {
    final dbHelper = UserDatabase.instance;
    await dbHelper.deleteActivity(activity.id!);
    setState(() {
      _activities.remove(activity);
    });
  }

  Future<void> _getCurrentGoal() async {
    final dbHelper = UserDatabase.instance;
    final goal = await dbHelper.getCurrentGoal();

    setState(() {
      currentGoal = goal;
    });
  }

  void _setGoal(RunningGoal goal) {
    setState(() {
      currentGoal = goal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Log'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SetGoalWidget(onGoalSet: _setGoal);
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          if (currentGoal != null)
            Text(
              'Goal: ${currentGoal!.distance!} km',
              style: TextStyle(fontSize: 16.0),
            ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return Dismissible(
                  key: ValueKey(activity.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteActivity(activity);
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('Distance: ${activity.distance.toStringAsFixed(2)} km'),
                      subtitle: Text('Duration: ${activity.duration} seconds'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
