import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';

import '../../models/user_model.dart';

class SubscribeScreen extends ConsumerStatefulWidget {
  final UserModel? user;

  const SubscribeScreen({super.key, this.user});

  @override
  ConsumerState<SubscribeScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscribeScreen> {
  int _selectedGoalIndex = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(subscriptionsProvider.notifier).subscriptions(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var subscriptions = ref.watch(subscriptionsProvider);
    var user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: const Color(0xfff5f8fe),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Extend Your Subscription"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
      subscriptions!.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          :
      Padding(
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
                        final subscription = subscriptions.subscriptions[index];
                        final isSelected = _selectedGoalIndex == index;

                        return GestureDetector(
                          onTap: () {
                            ref.read(subscriptionsProvider.notifier).subscribe(
                                context,
                                user!.user!.token,
                                subscription.planId);
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
                                        "${subscription.price} Per ${subscription.duration} Days",
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
            ),
    );
  }
}
