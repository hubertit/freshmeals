import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:freshmeals/views/homepage/widgets/cover_container.dart';

import '../../models/user_model.dart';
import '../../riverpod/providers/auth_providers.dart';
import '../../utls/styles.dart';
import '../auth/widgets/input_dec.dart';

class AdditionalInformationScreen extends ConsumerStatefulWidget {
  final UserModel user;
  const AdditionalInformationScreen({super.key, required this.user});

  @override
  ConsumerState<AdditionalInformationScreen> createState() =>
      _AdditionalInformationScreenState();
}

class _AdditionalInformationScreenState
    extends ConsumerState<AdditionalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  var targetWeightController = TextEditingController();
  var targetCaloriesController = TextEditingController();


  double? currentWeight;
  double? height;
  double? targetWeight;
  List<String> preExistingConditions = [];
  List<String> foodAllergies = [];
  String? dietaryGoal;

  @override
  Widget build(BuildContext context) {
    print(widget.user.toJson());
    var user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Additional Information')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextFormField(
              //   decoration:
              //       const InputDecoration(labelText: 'Current Weight (kg)'),
              //   keyboardType: TextInputType.number,
              //   onChanged: (value) => currentWeight = double.tryParse(value),
              // ),
              // TextFormField(
              //   decoration: const InputDecoration(labelText: 'Height (cm)'),
              //   keyboardType: TextInputType.number,
              //   onChanged: (value) => height = double.tryParse(value),
              // ),
              TextFormField(
                controller: targetWeightController,
                decoration: iDecoration(hint: 'Target Weight (Optional)'),
                keyboardType: TextInputType.number,
                // onChanged: (value) => targetWeight = double.tryParse(value),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: targetCaloriesController
                ,
                decoration:
                    iDecoration(hint: 'Calories Target/Limit (Optional)'),
                keyboardType: TextInputType.number,
                // onChanged: (value) => targetWeight = double.tryParse(value),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pre-existing Conditions',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CoverContainer(children: [
                ...[
                  "None",
                  "Diabetes",
                  "Hypertension",
                  "Thyroid disease",
                  "Autoimmune condition",
                  "Cancer",
                  "Other"
                ].map((condition) => CheckboxListTile(
                      title: Text(condition),
                      value: preExistingConditions.contains(condition),
                      onChanged: (isSelected) {
                        setState(() {
                          if (isSelected == true) {
                            preExistingConditions.add(condition);
                          } else {
                            preExistingConditions.remove(condition);
                          }
                        });
                      },
                    )),
              ]),
              const SizedBox(height: 16),
              const Text(
                'Food Allergies',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CoverContainer(children: [
                ...[
                  "None",
                  "Dairy",
                  "Eggs",
                  "Peanuts",
                  "Tree nuts",
                  "Shellfish",
                  "Fish",
                  "Gluten",
                  "Soy",
                  "Sesame",
                  "Other"
                ].map((allergy) => CheckboxListTile(
                      title: Text(allergy),
                      value: foodAllergies.contains(allergy),
                      onChanged: (isSelected) {
                        setState(() {
                          if (isSelected == true) {
                            foodAllergies.add(allergy);
                          } else {
                            foodAllergies.remove(allergy);
                          }
                        });
                      },
                    )),
              ]),
              const SizedBox(height: 16),
              // const Text(
              //   'Your Main Dietary Goal',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // CoverContainer(children: [
              //   ...[
              //     "Weight loss",
              //     "Weight gain",
              //     "Muscle building",
              //     "Improving overall health",
              //     "Managing a medical condition",
              //     "Improving athletic performance",
              //     "Other"
              //   ].map((goal) => RadioListTile<String>(
              //         title: Text(goal),
              //         value: goal,
              //         groupValue: dietaryGoal,
              //         onChanged: (value) {
              //           setState(() {
              //             dietaryGoal = value;
              //           });
              //         },
              //       )),
              // ]),
              const SizedBox(height: 16),
              // SizedBox(width: double.maxFinite,
              //   child: ElevatedButton(
              //     style: StyleUtls.buttonStyle,
              //     onPressed: () {
              //
              //     },
              //     child: const Text(
              //       "Confirm",
              //       style: TextStyle(
              //           color: Colors.white, fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // )
              SafeArea(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // IconButton(
                      //   icon: const Icon(
                      //     Icons.favorite,
                      //     color: Colors.red,
                      //     size: 30,
                      //   ),
                      //   onPressed: () {
                      //     print(meal.mealsData!.ingredients);
                      //   },
                      // ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            widget.user.preExistingConditions = preExistingConditions;
                            widget.user.foodAllergies = foodAllergies;
                            widget.user.targetWeight = double.parse(targetWeightController.text);
                            widget.user.calLimit = int.parse(targetCaloriesController.text);

                            // context.push('/preferences',extra: widget.user);

                            ref
                                .read(userProvider.notifier)
                                .register(context, ref, widget.user.toJson());
                            ref.read(firstTimeProvider.notifier).state = true;
                          },
                          child: user!.isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            "Confirm",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: ,
    );
  }
}
