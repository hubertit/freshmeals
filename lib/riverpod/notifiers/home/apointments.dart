import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/_api_utls.dart';
import '../../../models/general/slots.dart';

class SlotsNotifier extends StateNotifier<SlotsState> {
  SlotsNotifier() : super(SlotsState.initial());

  final Dio _dio = Dio();

  Future<void> fetchSlots(BuildContext context, String date) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}appointments/check_availability', // Update with your endpoint
        data: {
          "date": date,
        },
      );
      print(response);

      if (response.statusCode == 200 && response.data['data'] != []) {
        List<dynamic> data = response.data['data'];
        // final slots =
        state = SlotsState(
            isLoading: false,
            slotsData: data.map((json) => Slot.fromJson(json)).toList());
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Book appointment method
  Future<void> bookAppointment(BuildContext context, String token, String date,
      String timeSlot, String duration) async {
    try {
      // state = state.copyWith(isLoading: true);
      // Request body
      final requestBody = {
        "token": token,
        "date": date,
        "time_slot": timeSlot,
        "duration": duration
      };
      final response = await _dio.post(
        '${baseUrl}appointments/book_appointment',
        data: requestBody,
      );

      // Check response code and show Snackbar with message
      if (response.data['code'] == 200) {
        state = SlotsState(isLoading: false, slotsData: []);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.data['message']}')),
        );
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('An error occurred: $e')),
      // );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

class SlotsState {
  final List<Slot> slotsData;
  final bool isLoading;

  // Constructor
  SlotsState({required this.slotsData, required this.isLoading});

  // Initial state factory
  factory SlotsState.initial() => SlotsState(slotsData: [], isLoading: false);

  // CopyWith method
  SlotsState copyWith({List<Slot>? slotsData, bool? isLoading}) {
    return SlotsState(
      slotsData: slotsData ?? this.slotsData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
