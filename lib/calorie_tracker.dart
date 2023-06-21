import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/model/food_log.dart';
import 'package:fitness_tracker_app/model/user.dart';
import 'package:flutter/material.dart';

class CalorieTracker extends StatefulWidget {
  static String routeName = '/calorieTracker';

  @override
  _CalorieTrackerState createState() => _CalorieTrackerState();
}

class _CalorieTrackerState extends State<CalorieTracker> {
  int targetCalories = 0;
  int consumedCalories = 0;

  TextEditingController foodController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();

  List<Food> foodLogs = [];
  late User user;

  @override
  void initState() {
    super.initState();

    //get the food logs today and the user information
    fetchFoodLogsToday();
    fetchUser();
  }

  void fetchFoodLogsToday() async {
    //get the current date time and change it into a string
    DateTime dateTime = DateTime.now();
    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();
    String dateStr = "$day/$month/$year";

    //get the list of food logs from the db
    final List<Food> logs = await UserDatabase.instance.readFoodUsingDate(dateStr);

    //refresh the page
    setState(() {
      foodLogs = logs;
    });

    print('foodLogs: ${foodLogs.length}');
  }

  void fetchUser() async {
    //get the user information
    final User tempUser = await UserDatabase.instance.getUser();

    //refresh the page
    setState(() {
      //use the user data that was fetched from the db and set the target and consumed calories
      user = tempUser;
      targetCalories = user.targetCalories;
      consumedCalories = user.currentCalories;
    });
  }

  void addFoodLog() async {
    //get the food name and calories
    final String foodName = foodController.text;
    final int calories = int.parse(caloriesController.text);

    //get the current date time and change the date and time to string
    DateTime dateTime = DateTime.now();
    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute.toString();
    String dateStr = "$day/$month/$year";
    String timeStr = "$hour:$minute";

    //create a new food
    Food newFood = Food(
      foodName: foodName,
      calories: calories,
      date: dateStr,
      time: timeStr,
    );

    //add a new food
    await UserDatabase.instance.createFood(newFood);

    //calculate the total consumed calories of the user
    int currentCalories = user.currentCalories;
    int totalCalories = currentCalories + calories;

    //update the user's current consumed calories
    await UserDatabase.instance.updateUserCurrentCalories(user, totalCalories);

    //refresh the page
    setState(() {
      //clear food and calorie text field
      //add the newly added calories into the local consumed calories variable
      consumedCalories += calories;
      foodController.clear();
      caloriesController.clear();
    });

    //get the user information and the food logs today
    fetchUser();
    fetchFoodLogsToday();
  }

  void resetConsumedCaloriesAndFoodToday() async {
    //get the current date time and change it into a string
    DateTime dateTime = DateTime.now();
    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();
    String dateStr = "$day/$month/$year";

    //delete all the food logs today and update the user's current consumed calories to 0
    await UserDatabase.instance.deleteAllFoodToday(dateStr);
    await UserDatabase.instance.updateUserCurrentCalories(user, 0);

    //refresh the page
    setState(() {
      //clear the food and calories text field
      //clear the local food logs variable and set the local current consumed calories variable to 0
      consumedCalories = 0;
      foodController.clear();
      caloriesController.clear();
      foodLogs.clear();
    });

    //get the user information and the food log for today
    fetchUser();
    fetchFoodLogsToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Calorie Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Target Calories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$targetCalories',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Consumed Calories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$consumedCalories',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: foodController,
              decoration: const InputDecoration(
                labelText: 'Food',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Calories',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calculate),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addFoodLog,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
              ),
              child: const Text('Add'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Food Log',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: foodLogs.length,
                itemBuilder: (context, index) {
                  final log = foodLogs[index];
                  return ListTile(
                    title: Text(
                      log.foodName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${log.calories} calories • ${log.date}, ${log.time}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //create an Alertdialog to confirm the reset
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Reset Food Logs'),
              content: const Text('Are you sure you want to reset the food logs for today?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    resetConsumedCaloriesAndFoodToday();
                    Navigator.pop(context, 'Yes');
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.redo),
      ),
    );
  }

}
