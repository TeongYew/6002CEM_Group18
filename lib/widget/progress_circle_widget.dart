import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularPercentIndicator(
          radius: 150,
          lineWidth: 20,
          percent: .4,
          progressColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.5),
          circularStrokeCap: CircularStrokeCap.round,
          center: Text("No. of steps here"),
        ),
      ),
    );
  }
}
