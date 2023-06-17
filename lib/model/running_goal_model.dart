const String tableGoals = 'goals';

class RunningGoal {
  final int? id;
  final double distance;

  RunningGoal({this.id, required this.distance});

  Map<String, dynamic> toMap() {
    return {
      'distance': distance,
    };
  }

  factory RunningGoal.fromMap(Map<String, dynamic> map) {
    return RunningGoal(
      id: map['id'],
      distance: map['distance'],
    );
  }
}
