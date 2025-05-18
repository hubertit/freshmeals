import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../models/settings/address.dart';
import '../../models/settings/working_hours.dart';


final settingsProvider =
StateNotifierProvider<SettingsNotifier, SettingsState>(
        (ref) => SettingsNotifier());

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState.initial()) {
    loadSettings();
  }

  final Dio _dio = Dio();

  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final addressRes = await _dio.get('https://freshmeals.rw/api/settings/address');
      final hoursRes = await _dio.get('https://freshmeals.rw/api/settings/working_hours');

      if (addressRes.data['code'] == 200 && hoursRes.data['code'] == 200) {
        final address = SettingsAddress.fromJson(addressRes.data['data']);
        final hours = WorkingHours.fromJson(hoursRes.data['data']);

        state = state.copyWith(
          address: address,
          hours: hours,
          isLoading: false,
        );
      } else {
        throw Exception("Failed to load settings");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

class SettingsState {
  final SettingsAddress? address;
  final WorkingHours? hours;
  final bool isLoading;
  final String? error;

  SettingsState({
    this.address,
    this.hours,
    this.isLoading = false,
    this.error,
  });

  factory SettingsState.initial() => SettingsState();

  SettingsState copyWith({
    SettingsAddress? address,
    WorkingHours? hours,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      address: address ?? this.address,
      hours: hours ?? this.hours,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
