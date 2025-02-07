import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:go_router/go_router.dart';

import '../../constants/_assets.dart';
import '../../utls/styles.dart';
import 'widgets/input_dec.dart';

class Reset {
  final String code;
  final String identifier;

  Reset({required this.code, required this.identifier});
}

class NewPasswordScreen extends ConsumerStatefulWidget {
  final Reset resetData;
  const NewPasswordScreen({super.key, required this.resetData});

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();


  final _key = GlobalKey<FormState>();

  // void register()async{
  //   if (_key.currentState?.validate() ?? false) {
  //     setState(() {
  //       _loading = true;
  //     });
  //     await ajax(url: "reset_password/newPassword",
  //         method: "POST",
  //         data: FormData.fromMap(
  //             {
  //               "user_id": widget.user.id,
  //               "new_password": _newPassword.text,
  //             }), onValue: (obj, url) {
  //           if( obj['code'] == 200 ){
  //             User.user = widget.user;
  //             push(const Homepage(),replaceAll: true);
  //           }else{
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
    bool _loading = ref.watch(userProvider)!.isLoading;

    return Scaffold(
      body: Form(
        key: _key,
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
              "Reset password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "Type and confirm your new password below",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                decoration: iDecoration(hint: "New Password"),
                controller: _newPassword,
                obscureText: true,
                validator: (s) =>
                    s?.isNotEmpty == true ? null : "Password is required !",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: TextFormField(
                decoration: iDecoration(hint: "Confirm Password"),
                controller: _confirmPassword,
                obscureText: true,
                validator: (s) => s?.isNotEmpty == true
                    ? s == _newPassword.text
                        ? null
                        : "Password and confirm has to match"
                    : "Confirm Password is required !",
              ),
            ),
            _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: StyleUtls.buttonStyle,
                    onPressed: () {
                      ref.read(userProvider.notifier).resetPassword(
                          context,
                          widget.resetData.identifier,
                          widget.resetData.code,
                          _newPassword.text);
                    },
                    child: const Text(
                      "Update password",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: OutlinedButton(
                  onPressed: () => context.go('/login'),
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red),
                  child: const Text("Cancel")),
            )
          ],
        ),
      ),
    );
  }
}
