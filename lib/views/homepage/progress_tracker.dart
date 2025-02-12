import 'package:flutter/material.dart';
import 'package:freshmeals/utls/styles.dart';

class CalorieTrackerPage extends StatefulWidget {
  const CalorieTrackerPage({super.key});

  @override
  _CalorieTrackerPageState createState() => _CalorieTrackerPageState();
}

class _CalorieTrackerPageState extends State<CalorieTrackerPage> {
  final int targetCalories = 2000;
  int averageCalories = 1600;
  List<Map<String, dynamic>> data = [];
  String selectedTimeframe = 'week';

  @override
  void initState() {
    super.initState();
    fetchCalories();
  }

  void fetchCalories() {
    if (selectedTimeframe == 'week') {
      data = [
        {'date': '2025-02-05', 'calories': 1600},
        {'date': '2025-02-06', 'calories': 1600},
        {'date': '2025-02-07', 'calories': 1600},
        {'date': '2025-02-08', 'calories': 1600},
        {'date': '2025-02-09', 'calories': 1600},
        {'date': '2025-02-10', 'calories': 1600},
        {'date': '2025-02-11', 'calories': 1600},
      ];
    } else {
      data = List.generate(
          30,
          (index) => {
                'date': '2025-02-${(index + 1).toString().padLeft(2, '0')}',
                'calories': 1600,
              });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double percentage = (averageCalories / targetCalories) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite, // Adjust width
              height: 50, // Adjust height
              padding:
                  EdgeInsets.symmetric(horizontal: 10), // Add padding if needed
              decoration: BoxDecoration(
                color: Colors.white, // Set background color
                borderRadius: BorderRadius.circular(8), // Rounded corners
                border: Border.all(color: Colors.white), // Optional border
              ),
              child: Align(
                alignment: Alignment.centerLeft, // Align text inside dropdown
                child: DropdownButtonHideUnderline(
                  // Removes default underline
                  child: DropdownButton<String>(
                    value: selectedTimeframe,
                    isExpanded: true, // Ensures it fills the container width
                    dropdownColor:
                        Colors.white, // Background color of dropdown menu
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTimeframe = newValue!;
                        fetchCalories();
                      });
                    },
                    items: <String>['week', 'month']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value == 'week' ? 'This Week' : 'This Month',
                          style: TextStyle(
                              color: Colors.black54), // Change text color
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Average Progress',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Stack(
              alignment:
                  Alignment.center, // Centers the text inside the progress bar
              children: [
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey[300],
                  color: percentage > 100 ? Colors.red : Colors.green,
                  minHeight: 15,
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%', // Display percentage with 1 decimal place
                  style: const TextStyle(fontSize: 12,
                    color: Colors.white, // Change to match your theme
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Target: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '$targetCalories kcal',
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Average Consumed: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '$averageCalories kcal',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Daily Entries',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final entry = data[index];
                  final entryPercentage =
                      (entry['calories'] / targetCalories) * 100;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title:
                          Text('${entry['date']}: ${entry['calories']} kcal'),
                      trailing: Text(
                        '(${entryPercentage.toStringAsFixed(1)}%)',
                        style: TextStyle(
                          color:
                              entryPercentage > 100 ? Colors.red : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
