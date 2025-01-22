import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';

import '../../constants/_assets.dart';
import '../../riverpod/providers/auth_providers.dart';
import 'widgets/input_dec.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    return Scaffold(
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            // Logo
            Image.asset(
              AssetsUtils.logo,
              height: 200,
              fit: BoxFit.contain,
            ),
            // const SizedBox(height: 20),
            // Welcome Text
            const Text(
              "Welcome back",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Sign in to continue",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Input Fields
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: phoneController,
                validator: (s) => (s?.trim().length ?? 0) >= 10
                    ? null
                    : 'Enter a valid email or phone number',
                decoration: iDecoration(
                  hint: "Email or Phone Number",
                ),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: passwordController,
                validator: (s) =>
                s?.trim().isNotEmpty == true ? null : 'Password is required',
                decoration: iDecoration(
                  hint: "Password",
                  // suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                ),
                obscureText: true,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.go("/forgetPassword");
                },
                child: const Text(
                  "Forgot password",
                  style: TextStyle(color: Color(0xFF64BA02)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Sign In Button
            user!.isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                :ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF64BA02), // Green
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (key.currentState!.validate()) {
                  ref.read(userProvider.notifier).login(
                      context, ref, phoneController.text, passwordController.text);
                }
                // context.go("/home");
              },
              child: const Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Or Divider
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Or", style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            // Social Media Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(Icons.facebook, Colors.blue),
                _buildSocialButton(Icons.apple, Colors.black),
                _buildSocialButton(Ionicons.logo_google, Colors.red),
              ],
            ),
            const SizedBox(height: 30),
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    context.go('/newUser');
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Color(0xFF64BA02),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.grey[200],
      child: Icon(icon, color: color, size: 30),
    );
  }
}
