import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:freshmeals/views/homepage/widgets/cover_container.dart';

import '../../models/user_model.dart';
import '../../riverpod/providers/auth_providers.dart';
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
  var otherConditionController = TextEditingController();
  var otherAllergyController = TextEditingController();

  double? currentWeight;
  double? height;
  double? targetWeight;
  List<String> preExistingConditions = [];
  List<String> foodAllergies = [];
  String? dietaryGoal;
  bool isOtherConditionChecked = false;
  bool isOtherAllergyChecked = false;

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 16),
              const Text(
                'Pre-existing Conditions',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CoverContainer(margin: 0, children: [
                ...[
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
                            if (condition == 'Other') {
                              isOtherConditionChecked = true;
                            }
                          } else {
                            preExistingConditions.remove(condition);
                            if (condition == 'Other') {
                              isOtherConditionChecked = false;
                              otherConditionController.clear();
                            }
                          }
                        });
                      },
                    )),
                if (isOtherConditionChecked)
                  TextFormField(
                    controller: otherConditionController,
                    decoration: iDecoration(hint: 'Specify other condition'),
                  ),
              ]),
              const SizedBox(height: 16),
              const Text(
                'Food Allergies',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CoverContainer(margin: 0, children: [
                ...[
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
                            if (allergy == 'Other') {
                              isOtherAllergyChecked = true;
                            }
                          } else {
                            foodAllergies.remove(allergy);
                            if (allergy == 'Other') {
                              isOtherAllergyChecked = false;
                              otherAllergyController.clear();
                            }
                          }
                        });
                      },
                    )),
                if (isOtherAllergyChecked)
                  TextFormField(
                    controller: otherAllergyController,
                    decoration: iDecoration(hint: 'Specify other allergy'),
                  ),
              ]),
              const SizedBox(height: 16),
              TextFormField(
                controller: targetWeightController,
                decoration: iDecoration(hint: 'Target Weight (Optional)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: targetCaloriesController,
                decoration:
                    iDecoration(hint: 'Calories Target/Limit (Optional)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              SafeArea(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
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
                            if (isOtherConditionChecked &&
                                otherConditionController.text.isNotEmpty) {
                              preExistingConditions
                                  .add(otherConditionController.text);
                            }

                            if (isOtherAllergyChecked &&
                                otherAllergyController.text.isNotEmpty) {
                              foodAllergies.add(otherAllergyController.text);
                            }

                            widget.user.preExistingConditions =
                                preExistingConditions;
                            widget.user.foodAllergies = foodAllergies;
                            widget.user.targetWeight =
                                double.tryParse(targetWeightController.text);
                            widget.user.calLimit =
                                int.tryParse(targetCaloriesController.text);

                            ref.read(userProvider.notifier).register(
                                context, ref, widget.user.toJson(), true);
                            ref.read(firstTimeProvider.notifier).state = true;
                          },
                          child: user!.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "Confirm",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
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
    );
  }
}
