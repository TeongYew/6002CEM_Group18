final String tableFood = 'food';

class FoodFields {
  static final List<String> values = [
    //add all fields
    id, foodName, calories, date, time
  ];

  static final String id = '_id';
  static final String foodName = 'foodName';
  static final String calories = 'calories';
  static final String date = 'date';
  static final String time = 'time';
}

class Food {

  final int? id;
  final String foodName;
  final int calories;
  final String date;
  final String time;

  const Food({
    this.id,
    required this.foodName,
    required this.calories,
    required this.date,
    required this.time
  });

  Map<String, Object?> toJson() => {
    FoodFields.id: id,
    FoodFields.foodName: foodName,
    FoodFields.calories: calories,
    FoodFields.date: date,
    FoodFields.time: time,
  };

  Food copy({
    int? id,
    String? foodName,
    int? calories,
    String? date,
    String? time,
  }) =>
      Food(
        id: id ?? this.id,
        foodName: foodName ?? this.foodName,
        calories: calories ?? this.calories,
        date: date ?? this.date,
        time: time ?? this.time,
      );

  static Food fromJson(Map<String, Object?> json) => Food(
    id: json[FoodFields.id] as int?,
    foodName: json[FoodFields.foodName] as String,
    calories: json[FoodFields.calories] as int,
    date: json[FoodFields.date] as String,
    time: json[FoodFields.time] as String,
  );

}