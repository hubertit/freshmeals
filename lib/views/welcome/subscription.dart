import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';

import '../../models/user_model.dart';

// class Plan {
//   final String name;
//   final String price;
//   final String description;
//
//   Plan({
//     required this.name,
//     required this.price,
//     required this.description,
//   });
//
//   // Factory method to create a Plan object from JSON
//   factory Plan.fromJson(Map<String, dynamic> json) {
//     return Plan(
//       name: json['name'] as String,
//       price: json['price'] as String,
//       description: json['description'] as String,
//     );
//   }
//
//   // Convert a Plan object to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'price': price,
//       'description': description,
//     };
//   }
// }
//
// final List<Plan> dummyPlans = [
//   Plan(
//     name: 'Basic Plan',
//     price: 'RWF 30,000 /month',
//     description:
//         'Perfect for individuals seeking a simple, cost-effective way to enjoy healthy meals.',
//   ),
//   Plan(
//     name: 'Standard Plan',
//     price: 'RWF 50,000 /month',
//     description:
//         'Ideal for small families looking for variety and convenience in their meals.',
//   ),
//   Plan(
//     name: 'Premium Plan',
//     price: 'RWF 80,000 /month',
//     description:
//         'Designed for larger families or individuals who want premium quality meals with extra features.',
//   ),
// ];

class SubscriptionScreen extends ConsumerStatefulWidget {
  final UserModel? user;

  const SubscriptionScreen({Key? key, this.user}) : super(key: key);

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
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
    return Scaffold(
      backgroundColor: const Color(0xfff5f8fe),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Manage Your Subscription"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:  subscriptions!.isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Select a plan that fits your  health goal",
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
                      setState(() {
                        _selectedGoalIndex = index;
                        // widget.user.activityLevel = subscription.name;
                      });
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    if (isSelected)
                                      Switch(
                                        value: true,
                                        onChanged: (value) {
                                          // _toggleTheme();
                                        },
                                        inactiveTrackColor: primarySwatch,
                                        activeTrackColor: primarySwatch,
                                        activeColor: Colors.white,
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                context.push('/preferences',extra: widget.user);
              },
              child: const Text(
                "NEXT",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
