import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/constants/_api_utls.dart';
import '../../../models/general/my_appointments.dart';

class AppointmentNotifier extends StateNotifier<AppointmentState?> {
  AppointmentNotifier() : super(AppointmentState.initial());

  final Dio _dio = Dio();

  Future<void> fetchAppointments(BuildContext context, String token) async {
    try {
      state = state!.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}appointments/my_appointments',
        data: {
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        state = AppointmentState(
          appointments: data.map((json) => Appointment.fromJson(json)).toList(),
          isLoading: false,
        );
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }
}

class AppointmentState {
  final List<Appointment> appointments;
  final bool isLoading;

  AppointmentState({
    required this.appointments,
    required this.isLoading,
  });

  factory AppointmentState.initial() {
    return AppointmentState(
      appointments: [],
      isLoading: false,
    );
  }

  AppointmentState copyWith({
    List<Appointment>? appointments,
    bool? isLoading,
  }) {
    return AppointmentState(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
