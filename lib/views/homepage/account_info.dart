import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/utls/styles.dart';

import '../../riverpod/providers/home.dart';

class AccountInfoScreen extends ConsumerStatefulWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends ConsumerState<AccountInfoScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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

    // Fetch account info when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = ref.watch(userProvider);
      ref
          .read(accountInfoProvider.notifier)
          .fetchAccountInfo(user!.user!.token, ref);
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
    var user = ref.watch(userProvider);
    final accountInfo = accountInfoState!.accountInfo;
    if (accountInfo != null) {
      // Update controllers with fetched data
      nameController.text = accountInfo.name;
      emailController.text = accountInfo.email;
      phoneController.text = accountInfo.phoneNumber;
      ageController.text = accountInfo.age.toString();
      genderController.text = accountInfo.gender!;
      healthStatusController.text = accountInfo.healthStatus!;
      heightController.text = accountInfo.height.toString();
      weightController.text = accountInfo.weight.toString();
      activityLevelController.text = accountInfo.activityLevel ?? '';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Account Info')),
      body: accountInfoState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
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
                    // _buildAccountItem("Activity Level", activityLevelController),
                  ],
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
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              ref.read(accountInfoProvider.notifier).updateProfile(
                  token: user!.user!.token,
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  age: int.parse(ageController.text),
                  gender: genderController.text,
                  healthStatus: healthStatusController.text,
                  height: double.parse(heightController.text),
                  weight: double.parse(weightController.text),
                  activityLevel: accountInfo!.activityLevel ?? '',
                  dietaryPreferences: accountInfo.dietaryPreferences,
                  ref: ref,
                  context: context);
            },
            child:
                // accountInfoState.isLoading
                //     ? const CircularProgressIndicator(color: Colors.white,)
                //     :
                const Text(
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
    );
  }
}
