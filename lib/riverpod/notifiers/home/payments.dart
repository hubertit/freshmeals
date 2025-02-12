import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/constants/_api_utls.dart';
import 'package:freshmeals/models/home/payments_model.dart';

class PaymentsNotifier extends StateNotifier<PaymentsState?> {
  PaymentsNotifier() : super(PaymentsState.initial());

  final Dio _dio = Dio();

  Future<void> fetchPayments(BuildContext context, String token) async {
    try {
      state = state!.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}payments/get',
        data: {'token': token},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']; // Explicitly cast to List

        final List<PaymentsModel> payments = data
            .map((item) => PaymentsModel.fromJson(item as Map<String, dynamic>))
            .toList();

        print(payments);

        state = PaymentsState(
          payments: payments,
          isLoading: false,
        );
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error fetching payments: $e');
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }
}

class PaymentsState {
  final List<PaymentsModel> payments;
  final bool isLoading;

  PaymentsState({
    required this.payments,
    required this.isLoading,
  });

  factory PaymentsState.initial() {
    return PaymentsState(
      payments: [],
      isLoading: false,
    );
  }

  PaymentsState copyWith({
    List<PaymentsModel>? payments,
    bool? isLoading,
  }) {
    return PaymentsState(
      payments: payments ?? this.payments,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
