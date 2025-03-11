import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/_assets.dart';
import '../../../riverpod/providers/general.dart';

class FailedScreen extends ConsumerStatefulWidget {
  const FailedScreen({super.key});

  @override
  ConsumerState<FailedScreen> createState() => _FailedScreenState();
}

class _FailedScreenState extends ConsumerState<FailedScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:  Text("Payment Failed".tr()),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 35,
        ),
        // height: MediaQuery.of(context).size.height / 1.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Image.asset(
              AssetsUtils.failed,
              height: 60,
            ),
            const SizedBox(
              height: 30,
            ),
             const Text("The payment process has failed, try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            const SizedBox(
              height: 30,
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                onPressed: () {
                  var isFirst = ref.watch(firstTimeProvider);

                  if(isFirst){
                    context.go("/newAddress");
                  }else {
                    context.go('/');
                  }

                  ref.read(firstTimeProvider.notifier).state = false;
                },
                child:  const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continue",
                      style: TextStyle(
                           fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
