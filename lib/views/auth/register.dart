import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    country = CountryService().findByCode("US")!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
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
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 15),
            //   child: TextFormField(
            //     controller: lNameController,
            //     validator: (s) => s?.trim().isNotEmpty == true
            //         ? null
            //         : 'Last Name is required',
            //     decoration: iDecoration(hint: "Last Name"),
            //   ),
            // ),
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
              controller: phoneController,
              callback: (Country country) {
                setState(() {
                  this.country = country;
                });
              },
            ),
            SizedBox(height: 20,),
            user!.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: StyleUtls.buttonStyle,
                    onPressed: () {
                      context.go("/home");
                      // var json = {
                      //   "phone": phoneController.text,
                      //   "email": emailController.text,
                      //   "names": namesController.text,
                      //   "password": passwordController.text
                      // };
                      // if (key.currentState!.validate()) {
                      //   ref
                      //       .read(userProvider.notifier)
                      //       .register(context, ref, json);
                      // }
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
