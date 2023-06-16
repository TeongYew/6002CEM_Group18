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
  double totalDistance = 0.0;
  double? distanceToGoal;

  @override
  void initState() {
    super.initState();
    _loadActivities();
    _getCurrentGoal();
  }

  Future<void> _loadActivities() async {
    final db = UserDatabase.instance;
    final activities = await db.getActivities();

    double distanceSum = 0.0;
    for (var activity in activities) {
      distanceSum += activity.distance;
    }

    setState(() {
      _activities = activities;
      totalDistance = distanceSum;
      if (currentGoal != null) {
        distanceToGoal = currentGoal!.distance - totalDistance;
      }
    });
  }

  Future<void> _deleteActivity(RunningActivity activity) async {
    final db = UserDatabase.instance;
    await db.deleteActivity(activity.id!);
    setState(() {
      _activities.removeWhere((a) => a.id == activity.id);
      totalDistance -= activity.distance;
      if (currentGoal != null) {
        distanceToGoal = currentGoal!.distance - totalDistance;
      }
    });
  }

  Future<void> _getCurrentGoal() async {
    final db = UserDatabase.instance;
    final goal = await db.getCurrentGoal();

    setState(() {
      currentGoal = goal;
      if (currentGoal != null) {
        distanceToGoal = currentGoal!.distance - totalDistance;
      }
    });
  }

  Future<void> _setGoal(RunningGoal goal) async {
    final db = UserDatabase.instance;
    await db.updateGoal(goal);

    setState(() {
      currentGoal = goal;
      if (currentGoal != null) {
        distanceToGoal = currentGoal!.distance - totalDistance;
      }
    });

    // print(goal.distance);
    _loadActivities();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
          const SizedBox(height: 16.0),
          if (currentGoal != null)
            Text(
              'Goal: ${currentGoal!.distance} km',
              style: const TextStyle(fontSize: 16.0),
            ),
          const SizedBox(height: 16.0),
          Text(
            'Distance to Goal: ${distanceToGoal?.toStringAsFixed(2)} km',
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
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
                    padding: const EdgeInsets.only(right: 16.0),
                    child: const Icon(
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
