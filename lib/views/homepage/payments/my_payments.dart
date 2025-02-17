import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/notifiers/home/order_notifier.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:freshmeals/utls/callbacks.dart';
import 'package:freshmeals/views/appointment/widgets/empty_widget.dart';

import '../widgets/cover_container.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _RiderScreenState();
}

class _RiderScreenState extends ConsumerState<PaymentsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(paymentsProvider.notifier)
          .fetchPayments(context, ref.watch(userProvider)!.user!.token);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appointments = ref.watch(paymentsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Payments"),
        // actions: [
        //   IconButton(onPressed: ()=>context.push("/booking"), icon: Icon(Icons.add_circle_outline))
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appointments!.isLoading
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  )
                : appointments.payments.isEmpty
                    ? const Column(
                        children: [
                          SizedBox(
                            height: 200,
                          ),
                          CustomEmptyWidget(message: "You have  no Payments.")
                        ],
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 8.0),
                        itemCount: appointments.payments.length,
                        itemBuilder: (context, index) {
                          final appontment = appointments.payments[index];
                          return InkWell(
                            onTap: appontment.status == "pending"
                                ? () {
                                    Uri uri = Uri.parse(appontment.paymentUrl);

                                    String? invoiceNumber =
                                        uri.queryParameters['invoiceNumber'];
                                    launchPaymentUrl(context,
                                        appontment.paymentUrl, invoiceNumber!);
                                  }
                                : null,
                            child: CoverContainer(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "No: #${appontment.paymentReference}",
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: 70,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                          color: appontment.status == "FAILED"
                                              ? Colors.red
                                              : appontment.status == "paid"
                                                  ? primarySwatch
                                                  : Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: Text(
                                          appontment.status.toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // address("Amount",
                                //     "${formatMoney(appontment.amount)} Rwf"),
                                address(
                                    "Payment method", appontment.paymentMethod),
                                address("Payment type", appontment.paymentType),
                                address("Transaction date",
                                    appontment.transactionDate),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 150,
                                      child: Text(
                                        "Total Amount:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Text(
                                      "${formatMoney(appontment.amount)} Rwf",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}

Widget address(String attr, String vle) {
  return Row(
    children: [
      SizedBox(
        width: 150,
        child: Text(
          "${attr}:",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
      Flexible(
        child: Text(
          vle,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    ],
  );
}

int calculateDuration(String startTime, String endTime) {
  // Parse the start and end times into DateTime objects
  final start = DateFormat("HH:mm:ss").parse(startTime);
  final end = DateFormat("HH:mm:ss").parse(endTime);

  // Calculate the difference in minutes
  final duration = end.difference(start).inMinutes;

  return duration;
}
