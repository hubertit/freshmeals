import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/general/subscription.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:freshmeals/utls/callbacks.dart';
import 'package:go_router/go_router.dart';

import '../../models/user_model.dart';

class SubscribeScreen extends ConsumerStatefulWidget {
  final UserModel? user;
  const SubscribeScreen({super.key, this.user});

  @override
  ConsumerState<SubscribeScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscribeScreen> {
  int? _selectedGoalIndex;
  bool _isLoading = false;

  void _showLoadingOverlay() {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

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
    var subscriptions = ref.watch(subscriptionsProvider);
    var user = ref.watch(userProvider);
    var isFirsttim = ref.watch(firstTimeProvider);
    return Scaffold(
      backgroundColor: const Color(0xfff5f8fe),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(subscriptions!.activeSubscription != null
            ? "Your Plan"
            : "Subscription Plans"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: (subscriptions!.isLoading || _isLoading)
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
                          itemCount: isFirsttim
                              ? subscriptions.subscriptions.length + 1 // Add Free Plan if first time
                              : subscriptions.subscriptions.length, // Otherwise, only real plans
                          itemBuilder: (context, index) {
                            final isStaticPlan = isFirsttim && index == 0; // Show Free Plan only if first time

                            final subscription = isStaticPlan
                                ? SubscriptionPlan(
                              mealCount: '',
                              planId: "free_plan", // Dummy ID for the free plan
                              name: "Free Plan",
                              price: '0',
                              duration: "0", // Example duration
                              description: "Basic access with limited features.",
                              imageUrl: '',
                            )
                                : subscriptions.subscriptions[isFirsttim ? index - 1 : index]; // Adjust index

                            final isSelected = _selectedGoalIndex == index;

                            return Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (isStaticPlan) {
                                      // Navigate to the Home screen automatically
                                      context.push('/');
                                    } else {
                                      ref.read(subscriptionsProvider.notifier).subscribe(
                                        context,
                                        user!.user!.token,
                                        subscription.planId,
                                      );
                                    }
                                    setState(() {
                                      _selectedGoalIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected ? primarySwatch : Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                subscription.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                "${formatMoney(subscription.price)} Rwf Per ${subscription.duration} Days",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: primarySwatch,
                                                  fontSize: 16,
                                                ),
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
                                ),
                                if (_isLoading)
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.black.withOpacity(0.5),
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),

                      // Expanded(
                      //   child: ListView.builder(
                      //     itemCount: subscriptions.subscriptions.length,
                      //     itemBuilder: (context, index) {
                      //       final subscription =
                      //           subscriptions.subscriptions[index];
                      //       final isSelected = _selectedGoalIndex == index;
                      //
                      //       return Stack(
                      //         children: [
                      //           GestureDetector(
                      //             onTap: () {
                      //               // _showLoadingOverlay();
                      //               // print(subscription.planId);
                      //               ref
                      //                   .read(subscriptionsProvider.notifier)
                      //                   .subscribe(context, user!.user!.token,
                      //                       subscription.planId);
                      //               setState(() {
                      //                 _selectedGoalIndex = index;
                      //               });
                      //               // if (isSelected) {
                      //               // }
                      //               // print(subscription.planId);
                      //             },
                      //             child: Container(
                      //               margin: const EdgeInsets.only(bottom: 20),
                      //               padding: const EdgeInsets.all(16),
                      //               decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 borderRadius: BorderRadius.circular(12),
                      //                 border: Border.all(
                      //                   color: isSelected
                      //                       ? primarySwatch
                      //                       : Colors.white,
                      //                   width: 2,
                      //                 ),
                      //               ),
                      //               child: Row(
                      //                 children: [
                      //                   Expanded(
                      //                     child: Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         Text(
                      //                           subscription.name,
                      //                           style: const TextStyle(
                      //                             fontSize: 18,
                      //                             fontWeight: FontWeight.bold,
                      //                             color: Colors.black,
                      //                           ),
                      //                         ),
                      //                         const SizedBox(height: 5),
                      //                         Text(
                      //                           "${formatMoney(subscription.price)} Rwf Per ${subscription.duration} Days",
                      //                           style: const TextStyle(
                      //                               fontWeight: FontWeight.bold,
                      //                               color: primarySwatch,
                      //                               fontSize: 16),
                      //                         ),
                      //                         const SizedBox(height: 5),
                      //                         Text(
                      //                           subscription.description,
                      //                           style: const TextStyle(
                      //                             fontSize: 14,
                      //                             color: Colors.grey,
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //           if (_isLoading) ...[
                      //             Positioned.fill(
                      //               child: Container(
                      //                 color: Colors.black.withOpacity(
                      //                     0.5), // Semi-transparent background
                      //                 child: const Center(
                      //                   child: CircularProgressIndicator(),
                      //                 ),
                      //               ),
                      //             ),
                      //           ]
                      //         ],
                      //       );
                      //     },
                      //   ),
                      // ),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.green,
                      //     minimumSize: const Size(double.infinity, 50),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //   ),
                      //   onPressed: () {
                      //     context.push('/preferences', extra: widget.user);
                      //   },
                      //   child: const Text(
                      //     "NEXT",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color(0xffbadbcc),
                              width: 1), // Border color & width

                          borderRadius: BorderRadius.circular(12)),
                      // borderOnForeground: true,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    subscriptions.activeSubscription!.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                TextButton(
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
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.red),
                                  child: const Text("Cancel"),
                                ),
                              ],
                            ),
                            // const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  "${formatMoney(subscriptions.activeSubscription!.price)} RWF per ${subscriptions.activeSubscription!.duration} Days",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),

                            Text(
                              subscriptions.activeSubscription!.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Balance:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: primarySwatch),
                                ),
                                Text(
                                  "${formatMoney(subscriptions.activeSubscription!.walletBalance)} RWF",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: primarySwatch),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "Start: ${subscriptions.activeSubscription!.startDate}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey)),
                                Text(
                                    "End: ${subscriptions.activeSubscription!.endDate}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
    );
  }
}
