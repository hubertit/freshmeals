import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:freshmeals/views/homepage/widgets/cover_container.dart';
import '../../models/home/calories.dart';
import '../../riverpod/providers/auth_providers.dart';
import '../appointment/widgets/empty_widget.dart';

class CalorieTrackerPage extends ConsumerStatefulWidget {
  const CalorieTrackerPage({super.key});

  @override
  ConsumerState<CalorieTrackerPage> createState() => _CalorieTrackerPageState();
}

class _CalorieTrackerPageState extends ConsumerState<CalorieTrackerPage> {
  String selectedTimeframe = 'week';
  List<FlSpot> _calorieSpots = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.watch(userProvider);
      if (user!.user != null) {
        await ref.read(calorieProvider.notifier).fetchCalorieData(
            context, user.user!.token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var calorisState = ref.watch(calorieProvider);
    _calorieSpots =
        calorisState.calorieData!.dailyEntries!.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), double.parse(entry.value.calories));
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Tracker'),
        centerTitle: true,
      ),
      body: calorisState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(color: Colors.white,
                    height: 300,
                    padding: const EdgeInsets.only(top: 10,right: 10),
                    child: calorisState.calorieData?.dailyEntries == null ||
                            calorisState.calorieData!.dailyEntries!.isEmpty
                        ? const Center(child: Text("No data available"))
                        : LineChart(
                            LineChartData(
                              titlesData: const FlTitlesData(
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false, // Hide Dates (x-axis)
                                  ),
                                ),
                              ),
                              gridData: const FlGridData(
                                  show: true, drawVerticalLine: true),
                              borderData: FlBorderData(
                                show: true,
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              minX: 0,
                              maxX: _calorieSpots.length.toDouble() - 1,
                              minY: 0,
                              maxY: _calorieSpots.isNotEmpty
                                  ? _calorieSpots
                                      .map((spot) => spot.y)
                                      .reduce((a, b) => a > b ? a : b)
                                  : 5000,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _calorieSpots,
                                  isCurved: true,
                                  color: primarySwatch,
                                  barWidth: 5,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: primarySwatch.withOpacity(0.3),
                                  ),
                                  dotData: const FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                  ),
                  // Container(
                  //   width: double.maxFinite, // Adjust width
                  //   height: 50, // Adjust height
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 10), // Add padding if needed
                  //   decoration: BoxDecoration(
                  //     color: Colors.white, // Set background color
                  //     borderRadius: BorderRadius.circular(8), // Rounded corners
                  //     border:
                  //         Border.all(color: Colors.white), // Optional border
                  //   ),
                  //   child: Align(
                  //     alignment:
                  //         Alignment.centerLeft, // Align text inside dropdown
                  //     child: DropdownButtonHideUnderline(
                  //       // Removes default underline
                  //       child: DropdownButton<String>(
                  //         value: selectedTimeframe,
                  //         isExpanded:
                  //             true, // Ensures it fills the container width
                  //         dropdownColor:
                  //             Colors.white, // Background color of dropdown menu
                  //         onChanged: (String? newValue) {
                  //           // setState(() {
                  //           //   selectedTimeframe = newValue!;
                  //           //   fetchCalories();
                  //           // });
                  //         },
                  //         items: <String>['week', 'month']
                  //             .map<DropdownMenuItem<String>>((String value) {
                  //           return DropdownMenuItem<String>(
                  //             value: value,
                  //             child: Text(
                  //               value == 'week' ? 'This Week' : 'This Month',
                  //               style: const TextStyle(
                  //                   color: Colors.black54), // Change text color
                  //             ),
                  //           );
                  //         }).toList(),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  // const Text(
                  //   'Average Progress',
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(height: 10),
                  // Stack(
                  //   children: [
                  //     CoverContainer(
                  //       margin: 0,
                  //       children: [
                  //         Stack(
                  //           alignment: Alignment
                  //               .center, // Centers the text inside the progress bar
                  //           children: [
                  //             Center(
                  //               child: SizedBox(
                  //                 width:
                  //                     150, // Adjust this to your desired width
                  //                 height:
                  //                     150, // Ensure height is the same to keep it circular
                  //                 child: CircularProgressIndicator(
                  //                   strokeWidth: 10,
                  //                   value: calorisState
                  //                           .calorieData!.averageProgress! /
                  //                       100,
                  //                   backgroundColor: Colors.grey[300],
                  //                   color: calorisState
                  //                               .calorieData!.averageProgress! >
                  //                           100
                  //                       ? Colors.red
                  //                       : Colors.green,
                  //                 ),
                  //               ),
                  //             ),
                  //             Text(
                  //               '${calorisState.calorieData!.averageProgress}%', // Display percentage with 1 decimal place
                  //               style: const TextStyle(
                  //                 fontSize: 18,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //     Positioned(
                  //         top: 5,
                  //         right: 10,
                  //         child: Row(
                  //           children: [
                  //             // Text(
                  //             //   '${calorisState.calorieData!.target}',
                  //             //   style: TextStyle(fontWeight: FontWeight.w600),
                  //             // ),
                  //             IconButton(
                  //               onPressed: () {
                  //                 showModalBottomSheet(
                  //                   context: context,
                  //                   isScrollControlled:
                  //                       true, // Allows bottom sheet to go full height if needed
                  //                   builder: (context) {
                  //                     final TextEditingController
                  //                         targetController =
                  //                         TextEditingController(
                  //                             text: calorisState
                  //                                     .calorieData!.target
                  //                                     ?.toString() ??
                  //                                 '');
                  //
                  //                     return Padding(
                  //                       padding: EdgeInsets.only(
                  //                         left: 16,
                  //                         right: 16,
                  //                         bottom: MediaQuery.of(context)
                  //                                 .viewInsets
                  //                                 .bottom +
                  //                             16,
                  //                         top: 16,
                  //                       ),
                  //                       child: Column(
                  //                         mainAxisSize: MainAxisSize.min,
                  //                         children: [
                  //                           Row(
                  //                             mainAxisAlignment:
                  //                                 MainAxisAlignment
                  //                                     .spaceBetween,
                  //                             children: [
                  //                               InkWell(
                  //                                   onTap: () => context.pop(),
                  //                                   child: const Text(
                  //                                     "Cancel",
                  //                                     style: TextStyle(
                  //                                         color: Colors.red,
                  //                                         fontWeight:
                  //                                             FontWeight.bold),
                  //                                   )),
                  //                               const Text(
                  //                                 'Set Calorie Target/day',
                  //                                 style: TextStyle(
                  //                                     fontSize: 18,
                  //                                     fontWeight:
                  //                                         FontWeight.bold),
                  //                               ),
                  //                               InkWell(
                  //                                   onTap: () {
                  //                                     var user = ref
                  //                                         .watch(userProvider)!
                  //                                         .user;
                  //                                     ref
                  //                                         .read(calorieProvider
                  //                                             .notifier)
                  //                                         .setCalorieTarget(
                  //                                             context,
                  //                                             user!.token,
                  //                                             double.parse(
                  //                                                 targetController
                  //                                                     .text));
                  //                                   },
                  //                                   child: const Text(
                  //                                     "Set",
                  //                                     style: TextStyle(
                  //                                         color: primarySwatch,
                  //                                         fontWeight:
                  //                                             FontWeight.bold),
                  //                                   )),
                  //                             ],
                  //                           ),
                  //                           const SizedBox(height: 25),
                  //                           TextFormField(
                  //                             controller: targetController,
                  //                             decoration: iDecoration(),
                  //                             keyboardType:
                  //                                 TextInputType.number,
                  //                           ),
                  //                           const SizedBox(height: 50),
                  //                         ],
                  //                       ),
                  //                     );
                  //                   },
                  //                 );
                  //               },
                  //               icon: const Icon(Icons.settings),
                  //             ),
                  //           ],
                  //         ))
                  //   ],
                  // ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Target: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primarySwatch),
                        ),
                        TextSpan(
                          text: '${calorisState.calorieData!.target}',
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 10),
                  // Text.rich(
                  //   TextSpan(
                  //     children: [
                  //       const TextSpan(
                  //         text: 'Average Consumed: ',
                  //         style: TextStyle(fontWeight: FontWeight.bold),
                  //       ),
                  //       TextSpan(
                  //         text: '${calorisState.calorieData!.averageConsumed}',
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  const Text(
                    'Daily Entries',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  calorisState.calorieData!.dailyEntries!.isEmpty
                      ? const CoverContainer(
                          margin: 0,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 200,
                                ),
                                CustomEmptyWidget(
                                    message:
                                        "You haven’t consumed anything yet.")
                              ],
                            ),
                          ],
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount:
                                calorisState.calorieData!.dailyEntries!.length,
                            itemBuilder: (context, index) {
                              final entry = calorisState
                                  .calorieData!.dailyEntries![index];
                              // final entryPercentage =
                              //     (entry['calories'] / targetCalories) * 100;
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  leading: Text(
                                    '${entry.date}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  title: Text('${entry.calories} cal'),
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
// class CalorieTrackerPage extends ConsumerStatefulWidget {
//   const CalorieTrackerPage({super.key});
//
//   @override
//   _CalorieTrackerPageState createState() => _CalorieTrackerPageState();
// }
//
// class _CalorieTrackerPageState extends ConsumerState<CalorieTrackerPage> {
//     @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       var user = ref.watch(userProvider);
//       if (user!.user != null) {
//         await ref
//             .read(calorieProvider.notifier)
//             .fetchCalorieData(context, user.user!.token);
//       }
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final calorieState = ref.watch(calorieProvider);
// print(calorieState.calorieData!.dailyEntries);
//     return Scaffold(
//       appBar: AppBar(title: const Text('Calorie Consumption')),
//       body: calorieState.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : calorieState.calorieData?.dailyEntries == null ||
//           calorieState.calorieData!.dailyEntries!.isEmpty
//           ? const Center(child: Text("No data available"))
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 400,
//                 child: LineChart(
//                   _buildChartData(calorieState.calorieData!.dailyEntries!),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   LineChartData _buildChartData(List<DailyEntry> dailyEntries) {
//     final spots = dailyEntries.asMap().entries.map((entry) {
//       return FlSpot(entry.key.toDouble(), double.tryParse(entry.value.calories) ?? 0);
//     }).toList();
//
//     return LineChartData(
//       titlesData: const FlTitlesData(
//         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//       ),
//       gridData: const FlGridData(show: true, drawVerticalLine: false),
//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: Colors.grey, width: 1),
//       ),
//       minX: 0,
//       maxX: spots.length.toDouble() - 1,
//       minY: 0,
//       maxY: spots.isNotEmpty
//           ? spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b)
//           : 5000,
//       lineBarsData: [
//         LineChartBarData(
//           spots: spots,
//           isCurved: true,
//           color: Colors.green,
//           barWidth: 4,
//           belowBarData: BarAreaData(
//             show: true,
//             color: Colors.green.withOpacity(0.3),
//           ),
//           dotData: const FlDotData(show: true),
//         ),
//       ],
//     );
//   }
// }
