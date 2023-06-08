import 'package:fitness_tracker_app/bar%20graph/bar_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StepsBarGraph extends StatelessWidget {
  final List weeklySteps;
  const StepsBarGraph({Key? key, required this.weeklySteps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      monAmount: weeklySteps[0],
      tuesAmount: weeklySteps[1],
      wedAmount: weeklySteps[2],
      thursAmount: weeklySteps[3],
      friAmount: weeklySteps[4],
      satAmount: weeklySteps[5],
      sunAmount: weeklySteps[6],
    );

    myBarData.intializeBarData();
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getBottomTitles,
          )),
        ),
        maxY: 10000,
        minY: 0,
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: Colors.white,
                    width: 15,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                        show: false, toY: 10000, color: Colors.white),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}


Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  late String text;
  switch (value.toInt()) {
    case 0:
      text = 'M';
      break;
    case 1:
      text = 'T';
      break;
    case 2:
      text = 'W';
      break;
    case 3:
      text = 'T';
      break;
    case 4:
      text = 'F';
      break;
    case 5:
      text = 'S';
      break;
    case 6:
      text = 'S';
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: Text(text, style: style),
  );
}
