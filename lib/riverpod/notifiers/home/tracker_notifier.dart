import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/_api_utls.dart';
import '../../../models/general/monthly_entry.dart';
import '../../../models/home/calories.dart';
class ProgressData {
  final int userId;
  final String month;
  final String weight;
  final String abdomen;

  ProgressData({
    required this.userId,
    required this.month,
    required this.weight,
    required this.abdomen,
  });

  factory ProgressData.fromJson(Map<String, dynamic> json) {
    return ProgressData(
      userId: json['id'],
      month: json['month'] ?? '',
      weight: (json['weight']),
      abdomen: (json['abdomen']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'month': month,
      'weight': weight,
      'abdomen': abdomen,
    };
  }
}

class ProgressTrackerNotifier extends StateNotifier<ProgressTrackerState> {
  ProgressTrackerNotifier() : super(ProgressTrackerState.initial());

  final Dio _dio = Dio();

  Future<void> fetchProgressData(BuildContext context, String token) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _dio.get(
        '${baseUrl}tracker/get_progress',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: {
          "token": token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];

        final progressList =
        data.map((json) => ProgressData.fromJson(json)).toList();

        // Convert to weight entries
        final List<MonthlyEntry> weightEntries =progressList.isNotEmpty
            ? progressList.map((data) {
          return MonthlyEntry(
            month: data.month,
            value: double.tryParse(data.weight) ?? 0.0,
          );
        }).toList():[];

        // Convert to circumference entries
        final List<MonthlyEntry> circumferenceEntries =progressList.isNotEmpty
            ? progressList.map((data) {
          return MonthlyEntry(
            month: data.month,
            value: double.tryParse(data.abdomen) ?? 0.0,
          );
        }).toList():[];

        state = state.copyWith(
          progressData: progressList,
          weightEntries: weightEntries,
          circumferenceEntries: circumferenceEntries,
          isLoading: false,
        );
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> saveProgress(
      BuildContext context,
      String token, {
        String? month,
        int? weight,
        int? abdomen,
      }) async {
    try {
      state = state.copyWith(isLoading: true);

      final body = {
        "token": token,
        if (month != null) "month": month,
        if (weight != null) "weight": weight,
        if (abdomen != null) "abdomen": abdomen,
      };

      final response = await _dio.post(
        '${baseUrl}tracker/save_progress',
        data: body,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progress saved successfully.')),
        );

        // Refresh progress data
        await fetchProgressData(context, token);
      } else {
        throw Exception('Failed to save progress: ${response.statusMessage}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      state = state.copyWith(isLoading: false);
      context.pop();
    }
  }

  Future<void> updateProgress(
      BuildContext context,
      String token,
      int id, {
        double? weight,
        double? abdomen,
      }) async {
    try {
      state = state.copyWith(isLoading: true);

      final body = {
        "token": token,
        "id": id,
        if (weight != null) "weight": weight,
        if (abdomen != null) "abdomen": abdomen,
      };

      final response = await _dio.post(
        '${baseUrl}tracker/update_progress',
        data: body,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progress updated successfully.')),
        );

        // Refresh data
        await fetchProgressData(context, token);
      } else {
        throw Exception('Failed to update progress: ${response.statusMessage}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      state = state.copyWith(isLoading: false);
      context.pop();
    }
  }
}

class ProgressTrackerState {
  final List<ProgressData>? progressData;
  final List<MonthlyEntry>? weightEntries;
  final List<MonthlyEntry>? circumferenceEntries;
  final bool isLoading;

  ProgressTrackerState({
    this.progressData,
    this.weightEntries,
    this.circumferenceEntries,
    required this.isLoading,
  });

  factory ProgressTrackerState.initial() => ProgressTrackerState(
    progressData: [],
    weightEntries: [],
    circumferenceEntries: [],
    isLoading: false,
  );

  ProgressTrackerState copyWith({
    List<ProgressData>? progressData,
    List<MonthlyEntry>? weightEntries,
    List<MonthlyEntry>? circumferenceEntries,
    bool? isLoading,
  }) {
    return ProgressTrackerState(
      progressData: progressData ?? this.progressData,
      weightEntries: weightEntries ?? this.weightEntries,
      circumferenceEntries: circumferenceEntries ?? this.circumferenceEntries,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
