import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/model/steps_model.dart';
import 'package:fitness_tracker_app/step_counter.dart';
import 'package:flutter/material.dart';

class StepCounterLog extends StatefulWidget {
  static String routeName = "/StepCounterLogPage";
  const StepCounterLog({Key? key}) : super(key: key);

  @override
  State<StepCounterLog> createState() => _StepCounterLogState();
}

class _StepCounterLogState extends State<StepCounterLog> {
  List<Steps> _stepsLog = [];

  @override
  void initState() {
    super.initState();
    _loadSteps();
  }

  Future<void> _loadSteps() async {
    final db = UserDatabase.instance;
    final steps = await db.getDataFromStepsTable();

    setState(() {
      _stepsLog = steps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {Navigator.of(context).pushNamed(StepCounterPage.routeName);},
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Step Counter Log'),
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
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: _stepsLog.length,
              itemBuilder: (context, index) {
                final activity = _stepsLog[index];
                  child: Card(
                    child: ListTile(
                      isThreeLine: true,
                      title: Text('Steps: ${activity.steps}'),
                      subtitle: Column(
                        children: [
                          Text('Calories: ${activity.stepCalories} Kcal'),
                          Text('Distance: ${activity.stepDistance} metres'),
                          Text('Date: ${activity.date}')
                        ],
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
