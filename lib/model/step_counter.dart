import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../bar graph/bar_graph.dart';


class StepCounterPage extends StatefulWidget {
  static String routeName = "/StepCounterPage";
  const StepCounterPage({Key? key}) : super(key: key);

  @override
  State<StepCounterPage> createState() => _StepCounterPageState();
}

class _StepCounterPageState extends State<StepCounterPage> {
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
                percent: .4,
                progressColor: Colors.white,
                backgroundColor: Colors.grey.shade800,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                center: SizedBox(
                  height: 70,
                  child: Column(
                    children: [
                      Text(
                        "4000",
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
                              '1000',
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
                              '3.2',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              'Distance(km)',
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
                          child: Icon(Icons.arrow_back_rounded,color: Colors.white,),
                          onPressed: (){},
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
                          child: Icon(Icons.arrow_forward_rounded, color: Colors.white,),
                          onPressed: (){},
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
