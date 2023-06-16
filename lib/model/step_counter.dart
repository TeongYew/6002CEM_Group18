import 'dart:math';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../bar graph/bar_graph.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/model/user.dart';


String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class StepCounterPage extends StatefulWidget {
  static String routeName = "/StepCounterPage";
  @override
  State<StepCounterPage> createState() => _StepCounterPageState();
}

class _StepCounterPageState extends State<StepCounterPage> {
  late Stream<StepCount> _stepCountStream;
  String  _steps = '0';
  double height = 174; //replace
  double weight = 114; //replace
  double strideConst = 0.414;
  double speed = 1.4; //average walking speed
  double calPerMin = 4; //average calories burnt per min of walking
  late User user;



  @override
  void initState() {
    super.initState();
    initStepCounter();
    //_fetchUser();
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
    if (await Permission.activityRecognition.request().isGranted){
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    }else{
    }
    if(!mounted)return;
  }

  void _fetchUser() async {
    final User tempUser = await UserDatabase.instance.getUser();
    setState(() {
      user = tempUser;
      height = user.height;
      weight = user.weight;
    });
  }

  List<double> weeklySteps = [
    1000,
    2000,
    3000,
    4000,
    5000,
    6000,
    7000,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        extendBodyBehindAppBar: false,
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
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
              CircularPercentIndicator(
                radius: 130,
                lineWidth: 15,
                percent: double.parse(_steps)/10000,
                progressColor: Colors.white,
                backgroundColor: Colors.grey.shade800,
                circularStrokeCap: CircularStrokeCap.round,
                center: SizedBox(
                  height: 70,
                  child: Column(
                    children: [
                      Text(
                        _steps,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Roboto'),
                      ),
                      Text(
                        "Step Goal: 10000",
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      )
                    ],
                  ),
                ),
                footer: new Text(
                  "Step Count",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade800,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(-4, -4),
                    ),
                    BoxShadow(
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
                              (((((double.parse(_steps)*height*strideConst)/100))/1.4/60)*4).toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Kcal',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                        VerticalDivider(
                          width: 30,
                          thickness: 2.0,
                          color: Colors.white,
                        ),
                        Column(
                          children: [
                            Text(
                              (((double.parse(_steps)*height*strideConst)/100).toStringAsFixed(0)).toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
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
              SizedBox(
                height: 30,
              ),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade800,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(-4, -4),
                    ),
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(4, 4),
                    )
                  ],
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        child: TextButton(
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Text(
                        "start of week",
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_right_alt_outlined,
                        color: Colors.white,
                        size: 14,
                      ),
                      Text(
                        "end of week",
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        child: TextButton(
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ]),
              ),
              Container(
                  height: 200,
                  width: 350,
                  child: StepsBarGraph(
                    weeklySteps: weeklySteps,
                  )),
              Text(
                'Weekly step summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ));
  }
}

// class StepCounterPage extends StatefulWidget {
//   static String routeName = "/StepCounterPage";
//
//   @override
//   State<StepCounterPage> createState() => _StepCounterPageState();
// }
//
// class _StepCounterPageState extends State<StepCounterPage> {
//   late Stream<StepCount> _stepCountStream;
//   late Stream<PedestrianStatus> _pedestrianStatusStream;
//   String _status = '?', _steps = '?';
//
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }
//
//   void onStepCount(StepCount event) {
//     print(event);
//     setState(() {
//       _steps = event.steps.toString();
//     });
//   }
//
//   void onPedestrianStatusChanged(PedestrianStatus event) {
//     print(event);
//     setState(() {
//       _status = event.status;
//     });
//   }
//
//   void onPedestrianStatusError(error) {
//     print('onPedestrianStatusError: $error');
//     setState(() {
//       _status = 'Pedestrian Status not available';
//     });
//     print(_status);
//   }
//
//   void onStepCountError(error) {
//     print('onStepCountError: $error');
//     setState(() {
//       _steps = 'Step Count not available';
//     });
//   }
//
//   void initPlatformState() async {
//     if (await Permission.activityRecognition.request().isGranted){
//     _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
//     _pedestrianStatusStream
//         .listen(onPedestrianStatusChanged)
//         .onError(onPedestrianStatusError);
//
//     _stepCountStream = Pedometer.stepCountStream;
//     _stepCountStream.listen(onStepCount).onError(onStepCountError);
//     }else{
//       log('shit dont work');
//     }
//     if(!mounted)return;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Pedometer example app'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 'Steps taken:',
//                 style: TextStyle(fontSize: 30),
//               ),
//               Text(
//                 _steps,
//                 style: TextStyle(fontSize: 60),
//               ),
//               Divider(
//                 height: 100,
//                 thickness: 0,
//                 color: Colors.white,
//               ),
//               Text(
//                 'Pedestrian status:',
//                 style: TextStyle(fontSize: 30),
//               ),
//               Icon(
//                 _status == 'walking'
//                     ? Icons.directions_walk
//                     : _status == 'stopped'
//                     ? Icons.accessibility_new
//                     : Icons.error,
//                 size: 100,
//               ),
//               Center(
//                 child: Text(
//                   _status,
//                   style: _status == 'walking' || _status == 'stopped'
//                       ? TextStyle(fontSize: 30)
//                       : TextStyle(fontSize: 20, color: Colors.red),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }