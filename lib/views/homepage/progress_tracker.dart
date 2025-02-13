import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/utls/styles.dart';

import '../../riverpod/providers/auth_providers.dart';

class CalorieTrackerPage extends ConsumerStatefulWidget {
  const CalorieTrackerPage({super.key});

  @override
  ConsumerState<CalorieTrackerPage> createState() => _CalorieTrackerPageState();
}

class _CalorieTrackerPageState extends ConsumerState<CalorieTrackerPage> {
  String selectedTimeframe = 'week';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.watch(userProvider);
      if (user!.user != null) {
        await ref
            .read(calorieProvider.notifier)
            .fetchCalorieData(context, user.user!.token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var calorisState = ref.watch(calorieProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Tracker'),
        centerTitle: true,
      ),
      body: calorisState.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.maxFinite, // Adjust width
                    height: 50, // Adjust height
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10), // Add padding if needed
                    decoration: BoxDecoration(
                      color: Colors.white, // Set background color
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                      border:
                          Border.all(color: Colors.white), // Optional border
                    ),
                    child: Align(
                      alignment:
                          Alignment.centerLeft, // Align text inside dropdown
                      child: DropdownButtonHideUnderline(
                        // Removes default underline
                        child: DropdownButton<String>(
                          value: selectedTimeframe,
                          isExpanded:
                              true, // Ensures it fills the container width
                          dropdownColor:
                              Colors.white, // Background color of dropdown menu
                          onChanged: (String? newValue) {
                            // setState(() {
                            //   selectedTimeframe = newValue!;
                            //   fetchCalories();
                            // });
                          },
                          items: <String>['week', 'month']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value == 'week' ? 'This Week' : 'This Month',
                                style: const TextStyle(
                                    color: Colors.black54), // Change text color
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Average Progress',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  Stack(
                    alignment: Alignment
                        .center, // Centers the text inside the progress bar
                    children: [
                      LinearProgressIndicator(
                        value: calorisState.calorieData!.averageProgress! / 100,
                        backgroundColor: Colors.grey[300],
                        color: calorisState.calorieData!.averageProgress! > 100
                            ? Colors.red
                            : Colors.green,
                        minHeight: 15,
                      ),
                      Text(
                        '${calorisState.calorieData!.averageProgress}%', // Display percentage with 1 decimal place
                        style: const TextStyle(
                          fontSize: 12,
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
                        const TextSpan(
                          text: 'Target: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '${calorisState.calorieData!.target}',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Average Consumed: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '${calorisState.calorieData!.averageConsumed}',
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
                      itemCount: calorisState.calorieData!.dailyEntries!.length,
                      itemBuilder: (context, index) {
                        final entry =
                            calorisState.calorieData!.dailyEntries![index];
                        // final entryPercentage =
                        //     (entry['calories'] / targetCalories) * 100;
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Text('${entry.date}',style: TextStyle(fontSize: 16),),
                            title: Text('${entry.calories} kcal'),
                            trailing: Text(
                              '(${entry.percentage}%)',
                              style: TextStyle(
                                color: entry.percentage! > 100
                                    ? Colors.red
                                    : Colors.black,
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
