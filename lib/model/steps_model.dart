const String tableSteps = 'stepsActivity';

class Steps {
  int? id;
  String steps;
  String stepCalories;
  String stepDistance;
  String date;

  Steps({this.id, required this.steps, required this.date, required this.stepCalories, required this.stepDistance});

  Map<String, dynamic> toMap() {
    return {

      'steps': steps,
      'date': date,
      'stepCalories': stepCalories,
      'stepDistance': stepDistance
    };
  }

  factory Steps.fromMap(Map<String, dynamic> map) {
    return Steps(
      id: map['id'],
      steps: map['steps'],
      date: map['date'],
      stepCalories: map['calories'],
      stepDistance: map['distance']
    );
  }
}
