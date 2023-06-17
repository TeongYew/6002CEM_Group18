import 'package:fitness_tracker_app/model/running_activity_model.dart';
import 'package:fitness_tracker_app/set_goal_widget.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker_app/db/user_database.dart';

import 'model/running_goal_model.dart';

class RunningTrackerLog extends StatefulWidget {
  static String routeName = '/runningTrackerLog';

  const RunningTrackerLog({super.key});

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
    // calls the db and get the activities list
    final db = UserDatabase.instance;
    final activities = await db.getActivities();

    // calculate the total distance from all activities
    double distanceSum = 0.0;
    for (var activity in activities) {
      distanceSum += activity.distance;
    }


    setState(() {
      _activities = activities; // store the activities into the _activities list
      totalDistance = distanceSum; // store the calculated total distance

      // recalculate the distance to goal value
      if (currentGoal != null) {
        distanceToGoal = currentGoal!.distance - totalDistance;
      }
    });
  }

  Future<void> _deleteActivity(RunningActivity activity) async {
    // calls the db and delete the activity
    final db = UserDatabase.instance;
    await db.deleteActivity(activity.id!);

    // remove the deleted activity from the activities list and recalculate the total distance
    // refresh distance to goal
    setState(() {
      _activities.removeWhere((a) => a.id == activity.id);
      totalDistance -= activity.distance;
      if (currentGoal != null) {
        distanceToGoal = currentGoal!.distance - totalDistance;
      }
    });
  }

  Future<void> _getCurrentGoal() async {
    // calls the db and get current goal from db
    final db = UserDatabase.instance;
    final goal = await db.getCurrentGoal();

    // refresh the current goal and distance to goal
    setState(() {
      currentGoal = goal;
      if (currentGoal != null) {
        distanceToGoal = currentGoal!.distance - totalDistance;
      }
    });
  }

  Future<void> _setGoal(RunningGoal goal) async {
    // calls the database and run the updateGoal function with goal from the widget
    final db = UserDatabase.instance;
    await db.updateGoal(goal);

    // refresh the current goal and distance to goal displayed
    setState(() {
      currentGoal = goal;
      if (currentGoal != null) {
        distanceToGoal = currentGoal!.distance - totalDistance;
      }
    });

    // refresh the activities list
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
          const SizedBox(height: 8.0),
          FractionallySizedBox(
            widthFactor: 1.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF154c79),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (currentGoal != null)
                      Text(
                        'Goal: ${currentGoal!.distance} km',
                        style: const TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    if (currentGoal == null)
                      const Text(
                        'Please set your running goal.',
                        style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 16.0),
                    if (currentGoal != null)
                      Text(
                        'Distance to Goal: ${distanceToGoal?.toStringAsFixed(2)} km',
                        style: const TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    if (currentGoal == null)
                      const Text(
                        'Running goal not set.',
                        style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
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
