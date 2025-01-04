
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/_assets.dart';
import '../../utls/styles.dart';
import 'widgets/input_dec.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword>  {
  final TextEditingController _usernameController = TextEditingController();


  bool _loading = false;

  final _form = GlobalKey<FormState>();

  // Future<void> sendCode() async {
  //   if(_form.currentState?.validate()??false) {
  //     setState(() {
  //       _loading = true;
  //     });
  //     String phone = _usernameController.text;
  //     await ajax(url: "reset_password/",
  //         method: "POST",
  //         data: FormData.fromMap({
  //           "user_phone": phone,
  //         }),
  //         onValue: (obj, url) {
  //           if (obj['code'] == 200) {
  //             push(ValidateCode(phone: phone,));
  //           } else {
  //             showSnack(obj['message']);
  //           }
  //         });
  //     setState(() {
  //       _loading = false;
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(20)
              .copyWith(top: MediaQuery.of(context).padding.top),
          children: [
            Image.asset(AssetsUtils.logo,height: 150,),
            // Padding(
            //   padding: const EdgeInsets.all(0.0),
            //   child: Image.asset(AssetsUtils.logo),
            // ),
            const SizedBox(height: 30,),

            const Text(
              "Forgot your password?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30,),
            // Center(
            //     child: Padding(
            //       padding: const EdgeInsets.only(bottom: 20),
            //       child: Text(
            //         "Forgot your password?",
            //         style: Theme.of(context).textTheme.bodyLarge,
            //       ),
            //     )),
            Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Please type your email or phone number below",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: TextFormField(
                validator: (s)=>s?.trim().isNotEmpty == true ? null : "Field is required !",
                decoration: iDecoration(hint: "Email or Phone Number"),controller: _usernameController,),
            ),
            _loading ? const Center(
              child: CircularProgressIndicator(),
            ) :ElevatedButton(
              style: StyleUtls.buttonStyle,
              onPressed: (){
                context.go('/resetPassword');
              },
              child: const Text(
                "Send",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: OutlinedButton(onPressed: () =>context.go('/login'),style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  foregroundColor: Colors.red
              ), child: const Text("Cancel")),
            )
          ],
        ),
      ),
    );
  }
}
