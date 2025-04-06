import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:freshmeals/utls/callbacks.dart';
import 'package:freshmeals/views/homepage/widgets/cover_container.dart';
import 'package:go_router/go_router.dart';
import '../../models/general/monthly_entry.dart';
import '../../models/home/calories.dart';
import '../../riverpod/providers/auth_providers.dart';
import '../appointment/widgets/empty_widget.dart';
import '../auth/widgets/input_dec.dart';
import 'widgets/reusable_barchat.dart';

class CalorieTrackerPage extends ConsumerStatefulWidget {
  const CalorieTrackerPage({super.key});

  @override
  ConsumerState<CalorieTrackerPage> createState() => _CalorieTrackerPageState();
}

class _CalorieTrackerPageState extends ConsumerState<CalorieTrackerPage> {
  String selectedTimeframe = 'week';
  List<FlSpot> _calorieSpots = [];
  List<BarChartGroupData> barGroups = [];
  int getDayIndex(String dateString) {
    DateTime date = DateFormat('yyyy-MM-dd').parse(dateString);
    return date.weekday % 7; // Converts Monday-Sunday (1-7) to index 0-6
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.watch(userProvider);
      if (user!.user != null) {
        // 371b265c473fbb685f90d8d00ec60a62ed02b0bdea61b029b341
        await ref
            .read(calorieProvider.notifier)
            .fetchCalorieData(context, user.user!.token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var calorisState = ref.watch(calorieProvider);
    List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    if (calorisState.calorieData != null) {
      setState(() {
        // _calorieSpots = calorisState.calorieData!.dailyEntries!
        //     .asMap()
        //     .entries
        //     .map((entry) {
        //   return FlSpot(
        //       entry.key.toDouble(), double.parse(entry.value.calories));
        // }).toList();
        barGroups = List.generate(7, (index) {
          var entry = calorisState.calorieData!.dailyEntries?.firstWhere(
            (e) => getDayIndex(e.date) == index,
            orElse: () => DailyEntry.empty(),
          );

          double calories = entry != null ? double.parse(entry.calories) : 0;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: calories > 4000 ? 4000 : calories,
                color: primarySwatch,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        });
      });
    }

    double currentWeight = 70;
    double currentCircumference = 80;

    List<MonthlyEntry> weightEntries = [
      MonthlyEntry(month: "Jan", value: 70),
      MonthlyEntry(month: "Feb", value: 63),
      MonthlyEntry(month: "Mar", value: 70),
      MonthlyEntry(month: "Apr", value: currentWeight),
    ];

    List<MonthlyEntry> circumferenceEntries = [
      MonthlyEntry(month: "Jan", value: 80),
      MonthlyEntry(month: "Feb", value: 79),
      MonthlyEntry(month: "Mar", value: 81),
      MonthlyEntry(month: "Apr", value: currentCircumference),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracker'),
        centerTitle: true,
      ),
      body: calorisState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Calorie Tracker',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        calorisState.calorieData != null
                            ? IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled:
                                        true, // Allows bottom sheet to go full height if needed
                                    builder: (context) {
                                      final TextEditingController
                                          targetController =
                                          TextEditingController(
                                              text: calorisState
                                                      .calorieData!.target
                                                      ?.toString() ??
                                                  '');

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom +
                                              16,
                                          top: 16,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                    onTap: () => context.pop(),
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                const Text(
                                                  'Set Calorie Target/day',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      var user = ref
                                                          .watch(userProvider)!
                                                          .user;
                                                      ref
                                                          .read(calorieProvider
                                                              .notifier)
                                                          .setCalorieTarget(
                                                              context,
                                                              user!.token,
                                                              double.parse(
                                                                  targetController
                                                                      .text));
                                                    },
                                                    child: const Text(
                                                      "Set",
                                                      style: TextStyle(
                                                          color: primarySwatch,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            ),
                                            const SizedBox(height: 25),
                                            TextFormField(
                                              controller: targetController,
                                              decoration: iDecoration(),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            const SizedBox(height: 50),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.settings),
                              )
                            : Container(),
                      ],
                    ),

                    Container(
                      color: Colors.white,
                      height: 300,
                      padding:
                          const EdgeInsets.only(top: 10, right: 10, bottom: 6),
                      child: calorisState.calorieData?.dailyEntries == null ||
                              calorisState.calorieData!.dailyEntries!.isEmpty
                          ? const Center(child: Text("No data available"))
                          : Container(
                              color: Colors.white,
                              height: 300,
                              padding:
                                  const EdgeInsets.only(top: 10, right: 10),
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  titlesData: FlTitlesData(
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    leftTitles: AxisTitles(
                                      axisNameSize: 30,
                                      axisNameWidget: const Text(
                                        'Calories',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize:
                                            40, // Ensures enough space for labels
                                        getTitlesWidget: (value, meta) {
                                          if (value == 1000 ||
                                              value == 2000 ||
                                              value == 3000 ||
                                              value == 4000) {
                                            return Text(
                                              value.toInt().toString(),
                                              style: const TextStyle(
                                                  fontSize:
                                                      10), // Adjust size if needed
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            weekDays[value.toInt()],
                                            style:
                                                const TextStyle(fontSize: 10),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(
                                    drawVerticalLine: false,
                                    horizontalInterval:
                                        1000, // Ensures step increments of 1000
                                  ),
                                  barGroups: barGroups,
                                  minY: 0,
                                  maxY:
                                      4000, // Set max Y-axis to accommodate wider calorie values
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Daily Calorie Target: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primarySwatch),
                          ),
                          TextSpan(
                            text:
                                '${formatMoney(calorisState.calorieData!.target)} Cal',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Daily Calorie Entries',
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
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                                  title: Text(
                                      '${formatMoney(entry.calories)} Cal'),
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
                    // Inside the Column children:
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Text('Weight Tracker',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                final TextEditingController targetController =
                                TextEditingController(text: '');
                                int _selectedWeight = 60;

                                return StatefulBuilder(
                                  builder: (context, setModalState) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                                        top: 16,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [

                                              const Text(
                                                'Enter your current Weight?',
                                                style:
                                                TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    // handle save
                                                  },
                                                  child: const Text(
                                                    "Save",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                        color: primarySwatch,
                                                        fontWeight: FontWeight.bold),
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 25),
                                          GestureDetector(
                                            onHorizontalDragUpdate: (details) {
                                              setModalState(() {
                                                if (details.delta.dx > 0 && _selectedWeight < 120) {
                                                  _selectedWeight++;
                                                } else if (details.delta.dx < 0 && _selectedWeight > 1) {
                                                  _selectedWeight--;
                                                }
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove_circle_outline, size: 30),
                                                  onPressed: () {
                                                    setModalState(() {
                                                      if (_selectedWeight > 1) _selectedWeight--;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(width: 20),
                                                Text(
                                                  _selectedWeight.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                IconButton(
                                                  icon: const Icon(Icons.add_circle_outline, size: 30),
                                                  onPressed: () {
                                                    setModalState(() {
                                                      if (_selectedWeight < 120) _selectedWeight++;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 50),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.settings),
                        )
                      ],
                    ),

                    SizedBox(
                      height: 250,
                      child: buildMonthlyBarChart(
                          entries: weightEntries,
                          yAxisLabel: 'Weight (kg)',
                          context: context),
                    ),
                    // buildInputSection(
                    //   label: 'Enter your weight for this month:',
                    //   value: currentWeight,
                    //   onIncrement: () => setState(() => currentWeight += 1),
                    //   onDecrement: () => setState(() => currentWeight -= 1),
                    // ),

                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Text('Abdominal Circumference Tracker',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                final TextEditingController targetController =
                                TextEditingController(text: '');
                                int _selectedWeight = 60;

                                return StatefulBuilder(
                                  builder: (context, setModalState) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                                        top: 16,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [

                                              const Text(
                                                'Current Abdominal circumference?',
                                                style:
                                                TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    // handle save
                                                  },
                                                  child: const Text(
                                                    "Save",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: primarySwatch,
                                                        fontWeight: FontWeight.bold),
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 25),
                                          GestureDetector(
                                            onHorizontalDragUpdate: (details) {
                                              setModalState(() {
                                                if (details.delta.dx > 0 && _selectedWeight < 120) {
                                                  _selectedWeight++;
                                                } else if (details.delta.dx < 0 && _selectedWeight > 1) {
                                                  _selectedWeight--;
                                                }
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove_circle_outline, size: 30),
                                                  onPressed: () {
                                                    setModalState(() {
                                                      if (_selectedWeight > 1) _selectedWeight--;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(width: 20),
                                                Text(
                                                  _selectedWeight.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                IconButton(
                                                  icon: const Icon(Icons.add_circle_outline, size: 30),
                                                  onPressed: () {
                                                    setModalState(() {
                                                      if (_selectedWeight < 120) _selectedWeight++;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 50),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.settings),
                        )
                      ],
                    ),

                    SizedBox(
                      height: 250,
                      child: buildMonthlyBarChart(
                          entries: circumferenceEntries,
                          yAxisLabel: 'Circumference (cm)',
                          context: context),
                    ),
                    // buildInputSection(
                    //   label: 'Enter abdominal circumference for this month:',
                    //   value: currentCircumference,
                    //   onIncrement: () => setState(() => currentCircumference += 1),
                    //   onDecrement: () => setState(() => currentCircumference -= 1),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}

// BarChart(
//   BarChartData(
//     alignment: BarChartAlignment.spaceAround,
//     titlesData: FlTitlesData(
//       rightTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       topTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       leftTitles: AxisTitles(
//         axisNameSize: 30,
//         axisNameWidget: const Text(
//           'Calories',
//           style: TextStyle(fontSize: 10),
//         ),
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 40, // Ensures enough space for labels
//           getTitlesWidget: (value, meta) {
//             // if (value == 1000 || value == 2000 || value == 3000 || value == 4000 || value == 5000) {
//             return Text(
//               formatMoney(value.toInt().toString()),
//               style: const TextStyle(fontSize: 10), // Adjust size if needed
//             );
//             // }
//             // return const SizedBox.shrink();
//           },
//         ),
//       ),
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           getTitlesWidget: (value, meta) {
//             return Text(
//               weekDays[value.toInt()],
//               style: const TextStyle(fontSize: 8),
//             );
//           },
//         ),
//       ),
//     ),
//     borderData: FlBorderData(show: false),
//     gridData: FlGridData(
//       drawVerticalLine: false,
//       horizontalInterval: 1000, // Ensures step increments of 1000
//     ),
//     barGroups: barGroups,
//     minY: 0,
//     maxY: 30000, // Set max Y-axis to accommodate wider calorie values
//   ),
// )
