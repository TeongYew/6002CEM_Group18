import 'package:flutter/material.dart';

final String tableSteps = 'steps';

class Steps {
  int? id;
  double steps;
  String date;

  Steps({this.id, required this.steps, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'steps': steps,
      'date': date,
    };
  }

  factory Steps.fromMap(Map<String, dynamic> map) {
    return Steps(
      id: map['id'],
      steps: map['steps'],
      date: map['date'],
    );
  }
}
