import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/_api_utls.dart';
import '../../../models/general/health_goals.dart';
import '../../../models/general/subscription.dart';


class SubscriptionNotifier extends StateNotifier<SubscriptionState?> {
  SubscriptionNotifier() : super(SubscriptionState.initial());

  final Dio _dio = Dio();

  Future<void> subscriptions(BuildContext context) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.get(
        '${baseUrl}general/subscription_plans',
      );
      print(response.data['data']);
      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = SubscriptionState(
          subscriptions: myList.map((json) => SubscriptionPlan.fromJson(json)).toList(),
          isLoading: false,
        );

        // Do not throw an exception here, as it disrupts the normal flow
        // throw Exception('Failed to get: ${response.statusMessage}');
      } else {
        throw Exception('Failed to fetch districts: ${response.statusMessage}');
      }
    } catch (e) {
      // Handle error appropriately, e.g., show a snackbar or log the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  // Future<void> clearSchedules() async {
  //   state = SubscriptionState(
  //     goals: [],
  //     isLoading: false,
  //   );
  // }
}

class SubscriptionState {
  final List<SubscriptionPlan> subscriptions;
  final bool isLoading;

  SubscriptionState({required this.subscriptions, required this.isLoading});

  factory SubscriptionState.initial() =>
      SubscriptionState(subscriptions: [], isLoading: false);

  SubscriptionState copyWith({List<SubscriptionPlan>? orders, bool? isLoading}) {
    return SubscriptionState(
      subscriptions: orders ?? this.subscriptions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
