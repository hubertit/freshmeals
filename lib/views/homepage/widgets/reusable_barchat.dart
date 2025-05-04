import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/general/monthly_entry.dart';
import '../../../theme/colors.dart';
import '../../auth/widgets/input_dec.dart';

Widget buildMonthlyBarChart(
    {required List<MonthlyEntry>? entries,
    required String yAxisLabel,
    required BuildContext context}) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10)
        .copyWith(top: 40),
    width: double.maxFinite,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
    ),
    child: entries == null ||
        entries.isEmpty
        ? const Center(child: Text("No data available"))
        : BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        minY: 20, // Fixed minimum Y
        maxY: 180, // Fixed maximum Y
        // maxY: entries!.map((e) => e.value).reduce((a, b) => a > b ? a : b) +
        //     10,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < entries.length) {
                  return Text(
                    entries[index].month,
                    style: TextStyle(fontSize: 10),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: Text(
              yAxisLabel,
              style: TextStyle(fontSize: 10),
            ),
            axisNameSize: 30,
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              getTitlesWidget: (value, meta) =>
                  Text(value.toInt().toString(),style: TextStyle(fontSize: 10)),
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barGroups: List.generate(entries.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: entries[index].value,
                width: 18,
                color: primarySwatch,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
      ),
    ),
  );
}
Widget buildWeightBarChart({
  required List<MonthlyEntry>? entries,
  required String yAxisLabel,
  required BuildContext context,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10).copyWith(top: 40),
    width: double.maxFinite,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
    ),
    child: entries == null || entries.isEmpty
        ? const Center(child: Text("No data available"))
        : BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        minY: 40,
        maxY: 160,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < entries.length) {
                  return Text(
                    entries[index].month,
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: Text(
              yAxisLabel,
              style: const TextStyle(fontSize: 10),
            ),
            axisNameSize: 30,
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barGroups: List.generate(entries.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: entries[index].value,
                width: 16,
                color: primarySwatch,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
      ),
    ),
  );
}


Widget buildInputSection({
  required String label,
  required double value,
  required VoidCallback onIncrement,
  required VoidCallback onDecrement,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label),
      Row(
        children: [
          IconButton(onPressed: onDecrement, icon: Icon(Icons.remove)),
          Text('${value.toStringAsFixed(1)}'),
          IconButton(onPressed: onIncrement, icon: Icon(Icons.add)),
        ],
      ),
    ],
  );
}
