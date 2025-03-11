import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/_assets.dart';

class SubscribedScreen extends ConsumerStatefulWidget {
  const SubscribedScreen({super.key});

  @override
  ConsumerState<SubscribedScreen> createState() => _SubscribedScreenState();
}

class _SubscribedScreenState extends ConsumerState<SubscribedScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscribed"),
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
              AssetsUtils.subscribed,
              height: 60,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text("You have successfully payed for subscription",
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

                  if (isFirst) {
                    context.go("/newAddress");
                  } else {
                    context.go('/');
                  }

                  ref.read(firstTimeProvider.notifier).state = false;
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ok",
                      style: TextStyle(
                          color: primarySwatch, fontWeight: FontWeight.bold),
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
