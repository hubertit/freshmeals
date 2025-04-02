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
        Map<String, List<Slot>> groupedSlots = {};
        for (var slotJson in data) {
          Slot slot = Slot.fromJson(slotJson);
          if (!groupedSlots.containsKey(slot.date)) {
            groupedSlots[slot.date] = [];
          }
          groupedSlots[slot.date]!.add(slot);
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
  final Map<String, List<Slot>> slots;
  final bool isLoading;

  AvailabilityState({required this.slots, required this.isLoading});

  factory AvailabilityState.initial() {
    return AvailabilityState(slots: {}, isLoading: false);
  }

  AvailabilityState copyWith({
    Map<String, List<Slot>>? slots,
    bool? isLoading,
  }) {
    return AvailabilityState(
      slots: slots ?? this.slots,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class Slot {
  final String slotId;
  final String date;
  final String startTime;
  final String endTime;

  Slot({
    required this.slotId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  // Factory method to create a Slot from JSON
  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      slotId: json['slot_id'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }

  // Convert Slot to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'slot_id': slotId,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}
