import 'package:fitness_tracker_app/bar%20graph/individual_bar.dart';


class BarData{
  final double monAmount;
  final double tuesAmount;
  final double wedAmount;
  final double thursAmount;
  final double friAmount;
  final double satAmount;
  final double sunAmount;

  BarData({
    required this.monAmount,
    required this.tuesAmount,
    required this.wedAmount,
    required this.thursAmount,
    required this.friAmount,
    required this.satAmount,
    required this.sunAmount,
  });

  List<IndividualBar> barData = [];

  void intializeBarData() {
    barData = [
      IndividualBar(x: 0, y: monAmount),
      IndividualBar(x: 1, y: tuesAmount),
      IndividualBar(x: 2, y: wedAmount),
      IndividualBar(x: 3, y: thursAmount),
      IndividualBar(x: 4, y: friAmount),
      IndividualBar(x: 5, y: satAmount),
      IndividualBar(x: 6, y: sunAmount),
    ];
  }
}