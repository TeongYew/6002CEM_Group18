import 'package:fitness_tracker_app/main_menu.dart';
import 'package:fitness_tracker_app/step_counter_log.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/model/user.dart';
import 'package:cron/cron.dart';

class StepCounterPage extends StatefulWidget {
  static String routeName = "/StepCounterPage";
  const StepCounterPage({super.key});
  @override
  State<StepCounterPage> createState() => _StepCounterPageState();
}

class _StepCounterPageState extends State<StepCounterPage> {
  late Stream<StepCount> _stepCountStream;
  String _steps = '0';
  String calories = '0';
  double height = 0;
  double weight = 0;
  double strideConst = 0.414;
  double speed = 1.4; //average walking speed
  double calPerMin = 4; //average calories burnt per min of walking
  final now = DateTime.now();
  final cron = Cron();
  late User user;

  @override
  void initState() {
    super.initState();
    fetchUser();
    calculateCalories();
    initStepCounter();
    cron.schedule(Schedule.parse('59 23 * * * '), () async {
      insertSteps();
    });
  }

  void insertSteps() async {
    final formattedDate = "${now.day}-${now.month}-${now.year}";
    await UserDatabase.instance.addStepsToDatabase(
    _steps,
    (((((double.parse(_steps) * height * strideConst) / 100)) / 1.4 / 60) * 4).toStringAsFixed(2),
    ((double.parse(_steps) * height * strideConst) / 100).toStringAsFixed(0),
    formattedDate);
    print("Data inserted successfully");
    resetStepCount();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initStepCounter() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    } else {}
    if (!mounted) return;
  }

  void resetStepCount() {
    setState(() {
      _steps = '0';
    });
  }

  void fetchUser() async {
    final User tempUser = await UserDatabase.instance.getUser();

    setState(() {
      user = tempUser;
      height = user.height;
      weight = user.weight;
    });
  }

  void calculateCalories() {
    calories =(((((double.parse(_steps) *height * strideConst) / 100)) / 1.4 / 60) * 4).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(MainMenu.routeName);
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          backgroundColor: const Color(0xFF0E2376),
          elevation: 0,
          title: const Text(
            "Step Counter",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CircularPercentIndicator(
                radius: 130,
                lineWidth: 15,
                percent: double.parse(_steps) / 10000,
                progressColor: const Color(0xFF0E2376),
                backgroundColor: Colors.grey.shade400,
                circularStrokeCap: CircularStrokeCap.round,
                center: SizedBox(
                  height: 70,
                  child: Column(
                    children: [
                      Text(
                        _steps,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: 'Roboto'),
                      ),
                      const Text(
                        "Step Goal: 10000",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                footer: const Text(
                  "Step Count",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFF0E2376),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade800,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-4, -4),
                    ),
                    const BoxShadow(
                      color: Colors.black,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(4, 4),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              (((((double.parse(_steps) *height * strideConst) / 100)) / 1.4 / 60) * 4).toStringAsFixed(2),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Kcal',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                        const VerticalDivider(
                          width: 30,
                          thickness: 2.0,
                          color: Colors.white,
                        ),
                        Column(
                          children: [
                            Text(
                              ((double.parse(_steps) * height * strideConst) /
                                      100)
                                  .toStringAsFixed(0),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const Text(
                              'Distance(m)',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: const Color(0xFF0E2376),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade800,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(-4, -4),
                    ),
                    const BoxShadow(
                      color: Colors.black,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(4, 4),
                    )
                  ],
                ),
                child: TextButton(
                  child: const Text(
                    'Step Counter Log',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(StepCounterLog.routeName);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
