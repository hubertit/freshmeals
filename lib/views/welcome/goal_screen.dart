import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/general/health_goals.dart';
import 'package:freshmeals/models/user_model.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:go_router/go_router.dart';

import '../auth/widgets/input_dec.dart';
import '../homepage/widgets/cover_container.dart';

class HealthGoalScreen extends ConsumerStatefulWidget {
  final UserModel user;
  const HealthGoalScreen({Key? key, required this.user}) : super(key: key);

  @override
  ConsumerState<HealthGoalScreen> createState() => _HealthGoalScreenState();
}

class _HealthGoalScreenState extends ConsumerState<HealthGoalScreen> {
  int? _selectedGoalIndex;
  final List<String> selectedGoals = [];
  bool isOtherGoalChecked = false;
  final TextEditingController otherGoalController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(healthGoalsProvider.notifier).goals(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var goals = dummyHealthGoals;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "What is your dietary Goal?",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body:
          // goals!.isLoading
          //     ? const Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     :
          Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // const Text(
            //   "What is your health goal?",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),
            // const SizedBox(height: 10),
            CoverContainer(
              margin: 0,
              children: [
                ...[
                  "Weight loss",
                  "Weight gain",
                  "Muscle building",
                  "Improving overall health",
                  "Managing a medical condition",
                  "Improving athletic performance",
                  "Other Goal"
                ].map((goal) => CheckboxListTile(
                      title: Text(goal),
                      value: selectedGoals.contains(goal),
                      onChanged: (isSelected) {
                        setState(() {
                          if (isSelected == true) {
                            selectedGoals.add(goal);
                            if (goal == 'Other Goal') {
                              isOtherGoalChecked = true;
                            }
                          } else {
                            selectedGoals.remove(goal);
                            if (goal == 'Other Goal') {
                              isOtherGoalChecked = false;
                              otherGoalController.clear();
                            }
                          }
                        });
                      },
                    )),
              ],
            ),
            if (isOtherGoalChecked)
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: TextFormField(
                  maxLines: 2,
                  controller: otherGoalController,
                  decoration: iDecoration(hint: 'Specify Your goal'),
                ),
              ),
            // const SizedBox(height: 30),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: goals.length,
            //     itemBuilder: (context, index) {
            //       final goal = goals[index];
            //       final isSelected = _selectedGoalIndex == index;
            //
            //       return GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             _selectedGoalIndex = index;
            //           });
            //         },
            //         child: Container(
            //           margin: const EdgeInsets.only(bottom: 20),
            //           padding: const EdgeInsets.all(16),
            //           decoration: BoxDecoration(
            //             color:
            //                 isSelected ? Colors.green.shade100 : Colors.white,
            //             borderRadius: BorderRadius.circular(12),
            //             border: Border.all(
            //               color:
            //                   isSelected ? Colors.green : Colors.grey.shade300,
            //               width: 2,
            //             ),
            //           ),
            //           child: Row(
            //             children: [
            //               Container(
            //                 width: 50,
            //                 height: 50,
            //                 decoration: BoxDecoration(
            //                   color: Colors.green.shade50,
            //                   shape: BoxShape.circle,
            //                 ),
            //                 child: const Icon(
            //                   Icons.local_fire_department,
            //                   color: Colors.green,
            //                   size: 30,
            //                 ),
            //               ),
            //               const SizedBox(width: 20),
            //               Expanded(
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       goal.name,
            //                       style: const TextStyle(
            //                         fontSize: 16,
            //                         fontWeight: FontWeight.bold,
            //                         color: Colors.black,
            //                       ),
            //                     ),
            //                     const SizedBox(height: 5),
            //                     Text(
            //                       goal.description,
            //                       style: const TextStyle(
            //                         fontSize: 14,
            //                         color: Colors.grey,
            //                       ),
            //                     ),
            //                     const SizedBox(height: 5),
            //
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // if (_selectedGoalIndex!=null && goals[_selectedGoalIndex!].goalId == '7')
            //   TextFormField(
            //     maxLines: 5,
            //     // controller: otherConditionController,
            //     decoration: iDecoration(
            //         hint: 'Specify other condition'),
            //   ),
            // const SizedBox(height: 20),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                widget.user.healthyGoals = selectedGoals;
                context.push('/age', extra: widget.user);
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
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
