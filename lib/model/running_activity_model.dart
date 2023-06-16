final String tableActivities = 'activities';

class RunningActivity {
  int? id;
  double distance;
  int duration;

  RunningActivity({this.id, required this.distance, required this.duration});

  Map<String, dynamic> toMap() {
    return {
      'distance': distance,
      'duration': duration,
    };
  }

  factory RunningActivity.fromMap(Map<String, dynamic> map) {
    return RunningActivity(
      id: map['id'],
      distance: map['distance'],
      duration: map['duration'],
    );
  }
}
