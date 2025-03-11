import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../riverpod/providers/auth_providers.dart';
import '../../../riverpod/providers/home.dart';

class ProcessingScreen extends ConsumerStatefulWidget {
  final String invoiceNo;
  final bool subscribing;
  const ProcessingScreen(
      {super.key, required this.invoiceNo, required this.subscribing});

  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> {
  late Timer _timer;
  int _executionCount = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.read(userProvider); // Use ref.read instead of watch
      if (user!.user != null) {
        await ref
            .read(cartProvider.notifier)
            .myCart(context, user.user!.token, ref);
        await ref
            .read(countProvider.notifier)
            .fetchCount(context, user.user!.token);

        _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
          _executionCount++;
          print(_executionCount);

          if (_executionCount == 90) {
            _timer.cancel();
            context.go("/failed");
          }

          ref
              .read(orderProvider.notifier)
              .checkOrderStatus(context, widget.invoiceNo, widget.subscribing);
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Ensure timer is cancelled when widget is removed
    super.dispose();
  }
  // nitState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
  //       ref
  //           .read(orderProvider.notifier)
  //           .checkOrderStatus(context, widget.invoiceNo);
  //       // setState(() {
  //       //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //       //     try {
  //       //       final loggedUser = ref.watch(loggedUserProvider);
  //       //       final response =
  //       //       await userServices.getSummary(loggedUser!.userToken);
  //       //       if (response['code'] == 200) {
  //       //         ref.read(userSummaryProvider.notifier).state = response;
  //       //         // print("User summar ${ref.watch(userSummaryProvider)}");
  //       //       }
  //       //     } catch (e) {
  //       //       // print(e);
  //       //     }
  //       //     try {
  //       //       final response =
  //       //       await walletServices.getTransactions(ref.watch(tokenProvider));
  //       //       if (response['code'] == 200) {
  //       //         ref.read(transactionsProvider.notifier).state =
  //       //         response['data']['transactions'];
  //       //         ref.read(walletReportProvider.notifier).state = response['data'];
  //       //       }
  //       //     } catch (e) {
  //       //       print(e);
  //       //     }
  //       //   });
  //       // });
  //     });
  //   });
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Processing your order.."),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {
                context.go('/');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
