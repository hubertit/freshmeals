import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/utls/styles.dart';

import '../auth/widgets/input_dec.dart';
import 'widgets/cover_container.dart';

class AccountInfoScreen extends ConsumerStatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends ConsumerState<AccountInfoScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late List<String> selectedPreferences;
  late List<dynamic> preExistingConditions;
  late List<String> foodAllergies;
  late List<String> selectedGoals;

  bool isOtherConditionChecked = false;
  bool isOtherAllergyChecked = false;

  String _selectedGender = "Male";
  var otherConditionController = TextEditingController();
  var otherAllergyController = TextEditingController();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController ageController;
  // late TextEditingController genderController;
  late TextEditingController healthStatusController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController activityLevelController;
  late TextEditingController calLimitController;
  late TextEditingController targetWeightController;
  bool isOtherGoalChecked = false;
  final TextEditingController otherGoalController = TextEditingController();
  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    ageController = TextEditingController();
    // genderController = TextEditingController();
    healthStatusController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    activityLevelController = TextEditingController();
    activityLevelController = TextEditingController();
    activityLevelController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProvider);
      if (user != null) {
        // Fetch account info and dietary preferences
        ref
            .read(accountInfoProvider.notifier)
            .fetchAccountInfo(user.user!.token, ref);
        ref.read(preferencesProvider.notifier).preferences(context);
        setState(() {
          selectedPreferences =
              ref.watch(accountInfoProvider)!.accountInfo!.dietaryPreferences!;
        });
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    ageController.dispose();
    // genderController.dispose();
    healthStatusController.dispose();
    heightController.dispose();
    weightController.dispose();
    activityLevelController.dispose();
    calLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountInfoState = ref.watch(accountInfoProvider);
    final user = ref.watch(userProvider);
    final accountInfo = accountInfoState?.accountInfo;
    final prefeee = ref.watch(preferencesProvider);
    var preferencesState = prefeee!.preferances;
    // Initialize dietary preferences based on API data
    if (accountInfo != null) {
     setState(() {
       nameController.text = accountInfo.name;
       emailController.text = accountInfo.email;
       phoneController.text = accountInfo.phoneNumber;
       ageController.text = accountInfo.age.toString();
       _selectedGender = accountInfo.gender ?? 'Male';
       healthStatusController.text = accountInfo.healthStatus ?? '';
       heightController.text = accountInfo.height.toString();
       weightController.text = accountInfo.weight.toString();
       activityLevelController.text = accountInfo.activityLevel ?? '';

       selectedPreferences = accountInfo.dietaryPreferences ?? [];
       selectedGoals = accountInfo.healthGoal??[];
       preExistingConditions = accountInfo.preExistingConditions??[];
       foodAllergies = accountInfo.foodAllergies??[];
       selectedGoals = accountInfo.healthGoal??[];
     });
      // });
      // print(accountInfo.toJson());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Account Info'),
      ),
      body: accountInfoState?.isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAccountItem("Name", nameController),
                      const SizedBox(height: 10),
                      _buildAccountItem("Email", emailController),
                      const SizedBox(height: 10),
                      _buildAccountItem("Phone", phoneController),

                      const SizedBox(height: 10),
                      _buildAccountItem("Age", ageController),
                      const SizedBox(height: 10),
                      // _buildAccountItem("Gender", genderController),
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Gender",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        ),
                        items: ["Male", "Female"].map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue!;
                          });
                        },
                      ),
                      // const SizedBox(height: 10),
                      // _buildAccountItem(
                      //     "Health Status", healthStatusController),
                      const SizedBox(height: 10),
                      _buildAccountItem("Height", heightController),
                      const SizedBox(height: 10),
                      _buildAccountItem("Weight", weightController),
                      const SizedBox(height: 10),
                      // _buildAccountItem("Activity Level", activityLevelController),
                      // const SizedBox(height: 10),
                      const Text(
                        "Health Goal",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      // const SizedBox(height: 10),
                      CoverContainer(
                        margin: 0,
                        children: [
                          ...[
                            "Weight Loss",
                            "Weight gain",
                            "Muscle Gain",
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
                          margin: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            // maxLines: 2,
                            controller: otherGoalController,
                            decoration: iDecoration(hint: 'Specify Your goal'),
                          ),
                        ),
                      const SizedBox(height: 20),

                      const Text(
                        "Dietary Preferences",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      // Dietary Preferences Checklist
                      if (preferencesState != null)
                        CoverContainer(
                          margin: 0,
                          children: preferencesState.map((preference) {
                            final isSelected =
                                selectedPreferences.contains(preference.name);
                            return CheckboxListTile(
                              title: Text(preference.name),
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true && !selectedPreferences.contains(preference.name)) {
                                    selectedPreferences = [...selectedPreferences, preference.name];
                                  } else {
                                    selectedPreferences = selectedPreferences.where((p) => p != preference.name).toList();
                                  }
                                });
                                print("Updated Selected Preferences: $selectedPreferences");
                              },
                            );
                          }).toList(),
                        )
                      else
                        const Text("No preferences available"),
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
                          "Seafood",
                          "Gluten",
                          "Soy",
                          "Sesame",
                          "Other",
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
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ref.read(accountInfoProvider.notifier).updateProfile(
                      token: user!.user!.token,
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      age: int.tryParse(ageController.text) ?? 0,
                      gender: _selectedGender,
                      healthStatus: healthStatusController.text,
                      height: double.tryParse(heightController.text) ?? 0.0,
                      weight: double.tryParse(weightController.text) ?? 0.0,
                      activityLevel: activityLevelController.text,
                      dietaryPreferences: selectedPreferences,
                      ref: ref,
                      context: context,
                    );
              }

              // ref.read(accountInfoProvider.notifier).updateProfile(token: user!.user!.token, name: nameController.text, email: emailController.text, phone: phoneController.text,  age: int.tryParse(ageController.text) ?? 0, gender: _selectedGender, healthGoal: healthGoal, height: double.tryParse(heightController.text) ?? 0.0, weight: double.tryParse(weightController.text) ?? 0.0, targetWeight: t, calLimit: calLimit, dietaryPreferences: selectedPreferences, preExistingConditions: preExistingConditions, healthConditions: accountInfo!.healthConditions, foodAllergies: foodAllergies, ref: ref, context: context);

            },
            child: const Text(
              "Update",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountItem(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        border: StyleUtls.dashInputBorder,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label cannot be empty";
        }
        return null;
      },
    );
  }
}
