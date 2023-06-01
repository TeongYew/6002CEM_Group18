final String tableUser = 'user';

class UserFields {
  static final List<String> values = [
    //add all fields
    id, name, age, weight, height, goal, targetCalories, currentCalories
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String age = 'age';
  static final String weight = 'weight';
  static final String height = 'height';
  static final String goal = 'goal';
  static final String targetCalories = 'targetCalories';
  static final String currentCalories = 'currentCalories';
}

class User {

  final int? id;
  final String name;
  final int age;
  final double weight;
  final double height;
  final String goal;
  final double targetCalories;
  final double currentCalories;

  const User({
    this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.goal,
    required this.targetCalories,
    required this.currentCalories,
  });

  Map<String, Object?> toJson() => {
    UserFields.id: id,
    UserFields.name: name,
    UserFields.age: age,
    UserFields.weight: weight,
    UserFields.height: height,
    UserFields.goal: goal,
    UserFields.targetCalories: targetCalories,
    UserFields.currentCalories: currentCalories,
  };

  User copy({
    int? id,
    String? name,
    int? age,
    double? weight,
    double? height,
    String? goal,
    double? targetCalories,
    double? currentCalories,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        weight: weight ?? this.weight,
        height: height ?? this.height,
        goal: goal ?? this.goal,
        targetCalories: targetCalories ?? this.targetCalories,
        currentCalories: currentCalories ?? this.currentCalories,
      );

  static User fromJson(Map<String, Object?> json) => User(
      id: json[UserFields.id] as int?,
      name: json[UserFields.name] as String,
      age: json[UserFields.age] as int,
      weight: json[UserFields.weight] as double,
      height: json[UserFields.height] as double,
      goal: json[UserFields.goal] as String,
      targetCalories: json[UserFields.targetCalories] as double,
      currentCalories: json[UserFields.currentCalories] as double,
  );

}