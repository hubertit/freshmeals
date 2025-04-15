import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Future<void> bookAppointment(
      BuildContext context,
      String token,
      String slotId,
      String meetingType,
      ) async {
    try {
      state = state.copyWith(isLoading: true);

      var requestBody = {
        "token": token,
        "slot_id": slotId,
        "appointment_type": meetingType
      };

      final response = await _dio.post(
        '${baseUrl}appointments/book_appointment',
        data: requestBody,
      );

      if (response.data['code'] == 200) {
        final data = response.data['data'];
        final paymentUrl = data['payment_url'];
        final invoiceNumber = data['invoice_number'];

        // Optional: Print for debugging
        print('Payment URL: $paymentUrl');
        print('Invoice Number: $invoiceNumber');

        // If meeting is online, open questionnaire first
        // if (meetingType == "Online") {
        //   await launchUrl(Uri.parse("https://freshmeals.rw/app/questionnaire"));
        // }

        // Then launch payment
        if (paymentUrl != null) {
          await launchUrl(Uri.parse(paymentUrl));
        }

        // Navigate to processing screen
        context.go('/processing/${invoiceNumber}/false');
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.data['message']}')),
        );
      }
    } catch (e) {
      // Optional: Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Slot not available or already booked'),backgroundColor: Colors.red,),
      );
      context.pop();
      print("Error booking appointment: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }


  // // Book appointment method
  // Future<void> bookAppointment(BuildContext context, String token,
  //     String slotId, String meetingType) async {
  //   try {
  //     state = state.copyWith(isLoading: true);
  //     // Request body
  //     var requestBody = {
  //       "token": token,
  //       "slot_id": slotId,
  //       "appointment_type": meetingType
  //     };
  //     print(requestBody);
  //
  //     final response = await _dio.post(
  //       '${baseUrl}appointments/book_appointment',
  //       data: requestBody,
  //     );
  //     print(response);
  //     // Check response code and show Snackbar with message
  //     if (response.data['code'] == 200) {
  //       // state = SlotsState(isLoading: false, slotsData: []);
  //       // ref.read(appointmentsProvider.notifier).fetchSlots(context, date);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(response.data['message'])),
  //       );
  //       if (meetingType == "Online") {
  //         // context.pop();
  //         launchUrl(Uri.parse("https://freshmeals.rw/app/questionnaire"));
  //       }
  //       context.pop();
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('${response.data['message']}')),
  //       );
  //     }
  //   } catch (e) {
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(content: Text('An error occurred: $e')),
  //     // );
  //   } finally {
  //     state = state.copyWith(isLoading: false);
  //   }
  // }
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
