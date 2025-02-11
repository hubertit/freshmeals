import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/_api_utls.dart';
import '../../../models/general/active_subscription.dart';
import '../../../models/general/subscription.dart';
import '../../providers/general.dart';

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
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  /// Subscribe to a plan with the given token and plan ID.
  Future<void> subscribe(
      BuildContext context, String token, String planId) async {
    if (planId == "4") {
      context.go('/');
    } else {
      try {
        // state = state!.copyWith(isLoading: true);
        final response = await _dio.post(
          '${baseUrl}subscriptions/subscribe',
          data: {
            'token': token,
            'plan_id': planId,
          },
        );

        if (response.statusCode == 200 && response.data['data'] != null) {
          Uri uri = Uri.parse(response.data['data']['payment_url']);
          print(uri);
          String? invoiceNumber = uri.queryParameters['invoiceNumber'];

          print(invoiceNumber);

          launchUrl(uri);

          context.go("/processing/${invoiceNumber}/true");
// ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Subscription successful!')),
          // );
        } else {
          print(response);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${response.data['message']}')),
          );
        }
      } catch (e) {
      } finally {
        state = state!.copyWith(isLoading: false);
      }
    }
  }

  /// Fetch the active subscription
  Future<void> fetchActiveSubscription(
      BuildContext context, String token) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.post(
        '${baseUrl}subscriptions/active',
        data: {"token": token},
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final activeSubscription =
            ActiveSubscription.fromJson(response.data['data']);
        state = state!.copyWith(activeSubscription: activeSubscription);
        print(state);
      } else {
        throw Exception(
            'Failed to fetch active subscription: ${response.statusMessage}');
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  /// Cancel the active subscription
  Future<void> cancelSubscription(
      BuildContext context, String token, WidgetRef ref) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.post(
        '${baseUrl}subscriptions/cancel',
        data: {"token": token},
      );

      if (response.statusCode == 200 && response.data['status'] == "Success") {
        // Clear active subscription after cancellation
        await ref.read(subscriptionsProvider.notifier).subscriptions(context);
        await ref
            .read(subscriptionsProvider.notifier)
            .fetchActiveSubscription(context, token);
        context.pop();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Subscription cancelled successfully.')),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscription cancelled successfully.')),
        );
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('$e')),
      // );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }
}

class SubscriptionState {
  final List<SubscriptionPlan> subscriptions;
  final ActiveSubscription? activeSubscription;
  final bool isLoading;

  SubscriptionState({
    required this.subscriptions,
    this.activeSubscription,
    required this.isLoading,
  });

  factory SubscriptionState.initial() => SubscriptionState(
      subscriptions: [], activeSubscription: null, isLoading: false);

  SubscriptionState copyWith({
    List<SubscriptionPlan>? subscriptions,
    ActiveSubscription? activeSubscription,
    bool? isLoading,
  }) {
    return SubscriptionState(
      subscriptions: subscriptions ?? this.subscriptions,
      activeSubscription: activeSubscription ?? this.activeSubscription,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
