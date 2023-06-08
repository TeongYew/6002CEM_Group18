import 'package:fitness_tracker_app/model/running_activity_model.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker_app/db/running_tracker_database.dart';

class RunningTrackerLog extends StatefulWidget {
  @override
  _RunningTrackerLogState createState() => _RunningTrackerLogState();
}

class _RunningTrackerLogState extends State<RunningTrackerLog> {
  List<RunningActivity> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final dbHelper = DatabaseHelper();
    final activities = await dbHelper.getActivities();

    setState(() {
      _activities = activities;
    });
  }

  Future<void> _deleteActivity(RunningActivity activity) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteActivity(activity.id!); // Call deleteActivity with the activity's ID
    setState(() {
      _activities.remove(activity);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Log'),
      ),
      body: ListView.builder(
        itemCount: _activities.length,
        itemBuilder: (context, index) {
          final activity = _activities[index];
          return Dismissible(
            key: UniqueKey(), // Use UniqueKey for each Dismissible widget
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
              _deleteActivity(activity); // Remove the activity from the list
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
    );
  }
}
