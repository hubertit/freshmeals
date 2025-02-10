import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/_api_utls.dart';
import '../../../models/general/health_goals.dart';
import '../../../models/general/subscription.dart';

class SubscriptionNotifier extends StateNotifier<SubscriptionState?> {
  SubscriptionNotifier() : super(SubscriptionState.initial());

  final Dio _dio = Dio();

  /// Fetch subscription plans from the server.
  Future<void> subscriptions(BuildContext context) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.get(
        '${baseUrl}general/subscription_plans',
      );
      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = SubscriptionState(
          subscriptions:
              myList.map((json) => SubscriptionPlan.fromJson(json)).toList(),
          isLoading: false,
        );
      } else {
        throw Exception(
            'Failed to fetch subscription plans: ${response.statusMessage}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  /// Subscribe to a plan with the given token and plan ID.
  Future<void> subscribe(
      BuildContext context, String token, String planId) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.post(
        '${baseUrl}subscriptions/subscribe',
        data: {
          'token': token,
          'plan_id': planId,
        },
      );
      print(response);

      if (response.statusCode == 200) {
        Uri uri = Uri.parse(response.data['data']['payment_url']);

        // String? invoiceNumber = uri.queryParameters['invoiceNumber'];

        // print(invoiceNumber);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("${response.data['message']}")),
        // );
        launchUrl(uri);

        context.go("/");
// ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Subscription successful!')),
        // );
      } else {
        throw Exception('Failed to subscribe: ${response.statusMessage}');
      }
    } catch (e) {


    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }
}

class SubscriptionState {
  final List<SubscriptionPlan> subscriptions;
  final bool isLoading;

  SubscriptionState({required this.subscriptions, required this.isLoading});

  factory SubscriptionState.initial() =>
      SubscriptionState(subscriptions: [], isLoading: false);

  SubscriptionState copyWith(
      {List<SubscriptionPlan>? subscriptions, bool? isLoading}) {
    return SubscriptionState(
      subscriptions: subscriptions ?? this.subscriptions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
