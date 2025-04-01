import 'package:freshmeals/constants/_api_utls.dart';

import '../../../models/home/availability.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvailabilityNotifier extends StateNotifier<AvailabilityState> {
  AvailabilityNotifier() : super(AvailabilityState.initial());

  final Dio _dio = Dio();

  Future<void> fetchAvailability(String token, String nutritionistId) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}appointments/check_availability',
        data: {
          "token": token,
          "nutritionist_id": nutritionistId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];

        // Group slots by date
        Map<String, List<Map<String, String>>> groupedSlots = {};
        for (var slot in data) {
          String date = slot["date"];
          if (!groupedSlots.containsKey(date)) {
            groupedSlots[date] = [];
          }
          groupedSlots[date]!.add({
            "start_time": slot["start_time"],
            "end_time": slot["end_time"],
          });
        }

        state = AvailabilityState(slots: groupedSlots, isLoading: false);
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

class AvailabilityState {
  final Map<String, List<Map<String, String>>> slots;
  final bool isLoading;

  AvailabilityState({required this.slots, required this.isLoading});

  factory AvailabilityState.initial() {
    return AvailabilityState(slots: {}, isLoading: false);
  }

  AvailabilityState copyWith({
    Map<String, List<Map<String, String>>>? slots,
    bool? isLoading,
  }) {
    return AvailabilityState(
      slots: slots ?? this.slots,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
