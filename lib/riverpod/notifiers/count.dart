import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/constants/_api_utls.dart';

class Count {
  final int totalItems;
  final String totalAmount;

  Count({
    required this.totalItems,
    required this.totalAmount,
  });

  factory Count.fromJson(Map<String, dynamic> json) {
    return Count(
      totalItems: json['total_items'],
      totalAmount: json['total_amount'],
    );
  }
}

class CountNotifier extends StateNotifier<CountState?> {
  CountNotifier() : super(CountState.initial());

  final Dio _dio = Dio();

  Future<void> fetchCount(BuildContext context, String token) async {
    try {
      state = state!.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}/cart/count',
        data: {
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        state = CountState(
          count: Count.fromJson(data),
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

class CountState {
  final Count count;
  final bool isLoading;

  CountState({
    required this.count,
    required this.isLoading,
  });

  factory CountState.initial() {
    return CountState(
      count: Count(
        totalItems: 0,
        totalAmount: '0.00',
      ),
      isLoading: false,
    );
  }

  CountState copyWith({
    Count? count,
    bool? isLoading,
  }) {
    return CountState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
