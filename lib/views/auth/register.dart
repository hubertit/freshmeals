import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/user_model.dart';
import 'package:go_router/go_router.dart';

import '../../constants/_assets.dart';
import '../../riverpod/providers/auth_providers.dart';
import '../../utls/styles.dart';
import '../../utls/validatots.dart';
import 'widgets/input_dec.dart';
import 'widgets/phone_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  var key = GlobalKey<FormState>();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var namesController = TextEditingController();
  // var lNameController = TextEditingController();
  var emailController = TextEditingController();

  bool loading = false;
  final List<String> _categories = ["Customer", "Farmer"];

  String? _category;
  late Country country;
  final String _type = "phone";

  @override
  void initState() {
    country = CountryService().findByCode("RW")!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProv = ref.watch(userProvider);
    return Scaffold(
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(20)
              .copyWith(top: MediaQuery.of(context).padding.top),
          children: [
            Image.asset(
              AssetsUtils.logo,
              height: 170,
            ),
            const Text(
              "Register",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: namesController,
                validator: (s) =>
                    s?.trim().isNotEmpty == true ? null : 'Enter your name',
                decoration: iDecoration(hint: "Full name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: emailController,
                validator: validateEmail,
                decoration: iDecoration(hint: "Email"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                  controller: passwordController,
                  validator: (s) => s?.trim().isNotEmpty == true
                      ? null
                      : 'Password is required',
                  decoration: iDecoration(hint: "Password"),
                  obscureText: true),
            ),
            PhoneField(
              country: country,
              validator: (s) => s?.trim().isNotEmpty == true
                  ? null
                  : 'Phone number is required',
              controller: phoneController,
              callback: (Country country) {
                setState(() {
                  this.country = country;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            userProv!.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: StyleUtls.buttonStyle,
                    onPressed: () {
                      UserModel user = UserModel(
                          names: namesController.text ?? "",
                          phone:
                              "+${country.phoneCode}${phoneController.text}" ??
                                  "",
                          email: emailController.text ?? "",
                          password: passwordController.text ?? "",
                          age: 0,
                          gender: 'male',
                          healthStatus: '',
                          height: 0,
                          weight: 0,
                          targetWeight: 0,
                          calLimit: 0,
                          activityLevel: "Moderately Active",
                          dietaryPreferences: [],
                          preExistingConditions: [],
                          healthyGoals: [],
                          foodAllergies: []);
                      // Show success dialog with options


                      if (key.currentState!.validate()) {
                        showDialog(
                          context: context,
                          barrierDismissible:
                          false, // Prevents dismissing by tapping outside
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Select Your Meal Option'),
                              content: const Column(
                                mainAxisSize: MainAxisSize
                                    .min, // Prevent unnecessary blank space
                                children: [
                                  Text(
                                      "Choose how you'd like to proceed with your meals."),
                                  SizedBox(height: 20),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    ref
                                        .read(userProvider.notifier)
                                        .register(context, ref, user.toJson(), false);
                                  },
                                  child: const Text('No Meal Plan'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context.push("/goal", extra: user);
                                  },
                                  child: const Text('Meal Plan'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "OR",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            OutlinedButton(
                style: StyleUtls.textButtonStyle,
                onPressed: () => context.go('/login'),
                child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
