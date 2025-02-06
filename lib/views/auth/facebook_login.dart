import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/facebook_user.dart';
import 'package:freshmeals/models/user_model.dart';
import 'package:go_router/go_router.dart';

import '../../constants/_assets.dart';
import '../../riverpod/providers/auth_providers.dart';
import '../../utls/styles.dart';
import '../../utls/validatots.dart';
import 'widgets/input_dec.dart';
import 'widgets/phone_field.dart';

class FacebookRegisterScreen extends ConsumerStatefulWidget {
  final FacebookUser facebookUser;
  const FacebookRegisterScreen({super.key, required this.facebookUser});

  @override
  ConsumerState<FacebookRegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<FacebookRegisterScreen> {
  var key = GlobalKey<FormState>();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController(text: "password");
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
    country = CountryService().findByCode("US")!;
    super.initState();
    namesController.text = widget.facebookUser.name;
    emailController.text = widget.facebookUser.email;
    passwordController.text = "password";
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
              "Continue Registration",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                readOnly: true,
                controller: namesController,
                validator: (s) =>
                    s?.trim().isNotEmpty == true ? null : 'Enter your name',
                decoration: iDecoration(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                readOnly: true,
                controller: emailController,
                validator: validateEmail,
                decoration: iDecoration(),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 15),
            //   child: TextFormField(
            //       controller: passwordController,
            //       validator: (s) => s?.trim().isNotEmpty == true
            //           ? null
            //           : 'Password is required',
            //       decoration: iDecoration(hint: "Password"),
            //       obscureText: true),
            // ),
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
                        phone: "+${country.phoneCode}${phoneController.text}" ??
                            "",
                        email: emailController.text ?? "",
                        password: passwordController.text ?? "",
                        age: 0,
                        gender: '',
                        healthStatus: 'Good',
                        height: 0,
                        weight: 0,
                        activityLevel: "Moderately Active",
                        dietaryPreferences: [],
                      );
                      if (key.currentState!.validate()) {
                        context.push("/goal", extra: user);
                      }
                    },
                    child: const Text(
                      "Continue",
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
                child: const Text("Go back"))
          ],
        ),
      ),
    );
  }
}
