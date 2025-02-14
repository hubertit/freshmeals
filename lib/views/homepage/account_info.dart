import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/utls/styles.dart';

class AccountInfoScreen extends ConsumerStatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends ConsumerState<AccountInfoScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<int> selectedPreferences = [];
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController ageController;
  late TextEditingController genderController;
  late TextEditingController healthStatusController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController activityLevelController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    ageController = TextEditingController();
    genderController = TextEditingController();
    healthStatusController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    activityLevelController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProvider);
      if (user != null) {
        // Fetch account info and dietary preferences
        ref.read(accountInfoProvider.notifier).fetchAccountInfo(user.user!.token, ref);
        ref.read(preferencesProvider.notifier).preferences(context);
        setState(() {
          selectedPreferences= ref.watch(accountInfoProvider)!.accountInfo!.dietaryPreferences!;
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
    genderController.dispose();
    healthStatusController.dispose();
    heightController.dispose();
    weightController.dispose();
    activityLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountInfoState = ref.watch(accountInfoProvider);
    final user = ref.watch(userProvider);
    final accountInfo = accountInfoState?.accountInfo;
    final preferencesState = ref.watch(preferencesProvider);

    // Initialize dietary preferences based on API data
    if (accountInfo != null) {
      nameController.text = accountInfo.name;
      emailController.text = accountInfo.email;
      phoneController.text = accountInfo.phoneNumber;
      ageController.text = accountInfo.age.toString();
      genderController.text = accountInfo.gender ?? '';
      healthStatusController.text = accountInfo.healthStatus ?? '';
      heightController.text = accountInfo.height.toString();
      weightController.text = accountInfo.weight.toString();
      activityLevelController.text = accountInfo.activityLevel ?? '';
      selectedPreferences = accountInfo.dietaryPreferences?.map((e) => int.parse(e.toString())).toList() ?? [];
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
                _buildAccountItem("Gender", genderController),
                const SizedBox(height: 10),
                _buildAccountItem("Health Status", healthStatusController),
                const SizedBox(height: 10),
                _buildAccountItem("Height", heightController),
                const SizedBox(height: 10),
                _buildAccountItem("Weight", weightController),
                const SizedBox(height: 10),
                _buildAccountItem("Activity Level", activityLevelController),
                const SizedBox(height: 20),

                const Text(
                  "Dietary Preferences",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Dietary Preferences Checklist
                if (preferencesState != null)
                  Column(
                    children: preferencesState.preferances.map((preference) {
                      final isSelected = selectedPreferences.contains(preference.preferenceId);
                      return CheckboxListTile(
                        title: Text(preference.name),
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            int preferenceId = preference.preferenceId;
                            if (value == true) {
                              selectedPreferences.add(preferenceId);
                            } else {
                              selectedPreferences.remove(preferenceId);
                            }
                            print(selectedPreferences);
                          });
                        },
                      );
                    }).toList(),
                  )
                else
                  const Text("No preferences available"),

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
                  gender: genderController.text,
                  healthStatus: healthStatusController.text,
                  height: double.tryParse(heightController.text) ?? 0.0,
                  weight: double.tryParse(weightController.text) ?? 0.0,
                  activityLevel: activityLevelController.text,
                  dietaryPreferences: selectedPreferences,
                  ref: ref,
                  context: context,
                );
              }
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
