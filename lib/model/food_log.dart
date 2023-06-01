final String tableFood = 'food';

class FoodFields {
  static final List<String> values = [
    //add all fields
    id, foodName, calories, dateTime
  ];

  static final String id = '_id';
  static final String foodName = 'foodName';
  static final String calories = 'calories';
  static final String dateTime = 'dateTime';
}

class Food {

  final int? id;
  final String foodName;
  final double calories;
  final String dateTime;

  const Food({
    this.id,
    required this.foodName,
    required this.calories,
    required this.dateTime,
  });

  Map<String, Object?> toJson() => {
    FoodFields.id: id,
    FoodFields.foodName: foodName,
    FoodFields.calories: calories,
    FoodFields.dateTime: dateTime,
  };

  Food copy({
    int? id,
    String? foodName,
    double? calories,
    String? dateTime,
  }) =>
      Food(
        id: id ?? this.id,
        foodName: foodName ?? this.foodName,
        calories: calories ?? this.calories,
        dateTime: dateTime ?? this.dateTime,
      );

  static Food fromJson(Map<String, Object?> json) => Food(
    id: json[FoodFields.id] as int?,
    foodName: json[FoodFields.foodName] as String,
    calories: json[FoodFields.calories] as double,
    dateTime: json[FoodFields.dateTime] as String,
  );

}