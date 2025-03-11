import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';

import '../../models/user_model.dart';
import '../../riverpod/providers/auth_providers.dart';
import '../../utls/callbacks.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  final UserModel? user;

  const SubscriptionScreen({super.key, this.user});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  final int _selectedGoalIndex = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.watch(userProvider);
      if (user!.user != null) {
        await ref.read(subscriptionsProvider.notifier).subscriptions(context);
        await ref
            .read(subscriptionsProvider.notifier)
            .fetchActiveSubscription(context, user.user!.token);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Huuummmmm");
    print("Huuummmmm");
    print("Huuummmmm");
    print("Huuummmmm");
    print("Huuummmmm");
    var subscriptions = ref.watch(subscriptionsProvider);
    var user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: const Color(0xfff5f8fe),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(subscriptions!.isLoading
            ? ""
            : subscriptions.activeSubscription == null
                ? "Extend Your Subscription"
                : "Subscription Plan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: subscriptions!.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : subscriptions.activeSubscription == null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Select a subscription plan that fits your  health goal",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: ListView.builder(
                          itemCount: subscriptions.subscriptions.length,
                          itemBuilder: (context, index) {
                            final subscription =
                                subscriptions.subscriptions[index];
                            final isSelected = _selectedGoalIndex == index;

                            return GestureDetector(
                              onTap: () {
                                // ref
                                //     .read(subscriptionsProvider.notifier)
                                //     .subscribe(context, user!.user!.token,
                                //         subscription.planId);
                                // // print(subscription.planId);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  // border: Border.all(
                                  //   color:
                                  //       isSelected ? Colors.green : Colors.grey.shade300,
                                  //   width: 2,
                                  // ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                subscription.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "${formatMoney(subscription.price)} Rwf Per ${subscription.duration} Days",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: primarySwatch,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            subscription.description,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 0,
                            spreadRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Subscription Name & Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                subscriptions.activeSubscription!.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Cancel subscription',
                                          // style: TextStyle(color: Colors.red),
                                        ),
                                        content: const Text(
                                            'Are you sure you want to cancel your subscription?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () async {
                                              ref
                                                  .read(subscriptionsProvider
                                                      .notifier)
                                                  .cancelSubscription(context,
                                                      user!.user!.token, ref);
                                            },
                                            child: const Text(
                                              'Yes',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'No',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Price & Duration
                          Text(
                            "${formatMoney(subscriptions.activeSubscription!.price)} RWF per ${subscriptions.activeSubscription!.duration} Days",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primarySwatch,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 5),

                          // Subscription Description
                          Text(
                            subscriptions.activeSubscription!.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Subscription Start & End Dates
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Start: ${subscriptions.activeSubscription!.startDate}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "End: ${subscriptions.activeSubscription!.endDate}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Cancel Subscription Button
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.red,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(12),
                          //       ),
                          //       padding: const EdgeInsets.symmetric(vertical: 12),
                          //     ),
                          //     onPressed: () {
                          //       ref
                          //           .read(subscriptionsProvider.notifier)
                          //           .cancelSubscription(context, user!.user!.token);
                          //     },
                          //     child: const Text(
                          //       "Cancel Subscription",
                          //       style: TextStyle(
                          //         fontSize: 16,
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
