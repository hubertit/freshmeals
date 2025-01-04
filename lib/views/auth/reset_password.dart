import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../constants/_assets.dart';
import '../../utls/styles.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();

  bool _loading = false;

  final _form = GlobalKey<FormState>();
  String otpCode = ''; // Variable to store the OTP code
  // Future<void> sendCode() async {
  //   if (_form.currentState?.validate() ?? false) {
  //     setState(() {
  //       _loading = true;
  //     });
  //     await ajax(
  //         url: "reset_password/verify",
  //         method: "POST",
  //         data: FormData.fromMap({
  //           "user_phone": widget.phone,
  //           "code": _usernameController.text,
  //         }),
  //         onValue: (obj, url) {
  //           if (obj['code'] == 200) {
  //             var user = User.fromJson(obj['data']);
  //             push(NewPassword(user: user));
  //           } else {
  //             showSnack(obj['message']);
  //           }
  //         },
  //         error: (s, v) => showSnack("$s"));
  //     setState(() {
  //       _loading = false;
  //     });
  //   }
  // }
  late Timer _timer;
  int _remainingTime = 60; // Countdown starts at 60 seconds

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel(); // Stop the timer when it reaches zero
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(20)
              .copyWith(top: MediaQuery.of(context).padding.top),
          children: [
            Image.asset(
              AssetsUtils.logo,
              height: 150,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(0.0),
            //   child: Image.asset(AssetsUtils.logo),
            // ),
            const SizedBox(
              height: 30,
            ),

            const Text(
              "Password reset code",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            // Center(
            //     child: Padding(
            //       padding: const EdgeInsets.only(bottom: 20),
            //       child: Text(
            //         "Password reset code",
            //         style: Theme.of(context).textTheme.bodyLarge,
            //       ),
            //     )),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "An OTP has been sent to your email. Please enter it below to verify.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            )),
            PinCodeTextField(
              backgroundColor: Colors.transparent,
              appContext: context,
              length: 6, // 6-digit OTP
              obscureText: false,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 45,
                  fieldWidth: 35,
                  activeFillColor: Colors.white,
                  selectedColor: Colors.black,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  inactiveColor: Colors.grey),
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              onCompleted: (value) {
                setState(() {
                  otpCode = value;
                });
              },
              onChanged: (value) {
                setState(() {
                  otpCode = value;
                });
              },
            ),
            // Countdown Timer Display
            Text(
                textAlign: TextAlign.center,
                _remainingTime > 0
                    ? "Resend OTP in $_remainingTime seconds"
                    : "You can now resend the OTP",
                style: const TextStyle(
                    fontSize: 11,
                    color: primarySwatch,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: StyleUtls.buttonStyle,
                    onPressed: () {
                      context.go('/newPassword');
                    },
                    child: const Text(
                      "Complete",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: OutlinedButton(
                  onPressed: () => context.go('/login'),
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      foregroundColor: Colors.red),
                  child: const Text("Cancel")),
            )
          ],
        ),
      ),
    );
  }
}
