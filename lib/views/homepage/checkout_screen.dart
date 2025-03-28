import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/constants/_assets.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:freshmeals/utls/callbacks.dart';
import 'package:freshmeals/utls/styles.dart';
import 'package:freshmeals/views/appointment/widgets/empty_widget.dart';
import 'package:freshmeals/views/homepage/widgets/cover_container.dart';
import 'package:go_router/go_router.dart';

import '../../riverpod/providers/auth_providers.dart';
import '../../riverpod/providers/general.dart';
import '../../riverpod/providers/home.dart';

class CheckOutScreen extends ConsumerStatefulWidget {
  const CheckOutScreen({super.key});

  @override
  ConsumerState<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends ConsumerState<CheckOutScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.watch(userProvider);
      if (user!.user != null) {
        await ref
            .read(defaultAddressProvider.notifier)
            .fetchDefaultAdress(user.user!.token);
        await ref
            .read(subscriptionsProvider.notifier)
            .fetchActiveSubscription(context, user.user!.token);
      }
    });
    super.initState();
  }

  String _meetingType = "Delivery"; // Default selection

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var defaultAddress = ref.watch(defaultAddressProvider);
    var user = ref.watch(userProvider);
    var orderState = ref.watch(orderProvider);
    var summary = ref.watch(cartProvider);
    var subscription = ref.watch(subscriptionsProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Check Out',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order ID Section
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Order ID',
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       '#OD2204',
              //       style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.green),
              //     ),
              //   ],
              // ),
              DropdownButtonFormField<String>(
                value: _meetingType,
                decoration: InputDecoration(
                  filled: true,
                  label: const Text("Select delivery method"),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                items: ["Delivery", "Pickup"].map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _meetingType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 16),
              if (_meetingType == "Delivery")
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: defaultAddress!.isLoading
                      ? const SizedBox(
                          height: 100,
                          width: double.maxFinite,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : defaultAddress.address == null
                          ? Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              // height: 150,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Delivery Address',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.push('/changeAddress');
                                        },
                                        child: const Text(
                                          'Select',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const CustomEmptyWidget(
                                    iconSize: 60,
                                    message: "Select delivered address first",
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Delivery Address',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.push('/changeAddress');
                                      },
                                      child: const Text(
                                        'Change',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Image.asset(
                                      AssetsUtils.rectangle,
                                      height: 80,
                                      width: 80,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: 30,
                                                  child: Icon(
                                                    Icons.location_pin,
                                                    color: secondarTex,
                                                    size: 16,
                                                  )),
                                              Flexible(
                                                child: Text(
                                                  defaultAddress
                                                      .address!.mapAddress,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: 30,
                                                  child: Icon(
                                                    Icons.person,
                                                    color: secondarTex,
                                                    size: 16,
                                                  )),
                                              Text(
                                                user!.user!.name,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: 30,
                                                  child: Icon(
                                                    Icons.call,
                                                    color: secondarTex,
                                                    size: 16,
                                                  )),
                                              Text(
                                                user.user!.phoneNumber,
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Bill',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sub Total'),
                        Text('Rwf ${formatMoney(summary!.summary.subtotal)}'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Fee'),
                        Text('Rwf ${formatMoney(summary.summary.shippingFee)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tax'),
                        Text('Rwf ${formatMoney(summary.summary.vat)}'),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Bill',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rwf ${formatMoney(summary.summary.totalPrice)}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (subscription!.activeSubscription != null)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Color(0xff0d1e7dd),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0xffbadbcc))),
                  child: Text.rich(
                    // textAlign: TextAlign.center,
                    TextSpan(
                      text: "You have ",
                      style: const TextStyle(
                        fontSize: 14,
                        // color: Color(0xf0f5132),
                        // fontWeight: FontWeight.bold
                      ),
                      children: [
                        TextSpan(
                          text:
                              "${formatMoney(subscription.activeSubscription!.walletBalance)} RWF",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green, // Highlight balance
                          ),
                        ),
                        const TextSpan(
                          text:
                              " remaining on your subscription plan. Your order amount will be deducted from this balance, excluding the delivery fee.",
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              const Text(
                'Comment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Note Section
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                    hintText: 'Add a special comment...',
                    border: StyleUtls.commonInputBorder,
                    filled: true,
                    fillColor: Colors.white),
                controller: commentController,
              ),
              // Confirm Order Button
              const SizedBox(height: 20),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      var json = {
                        "token": user!.user!.token,
                        "address_id": defaultAddress!.address!.addressId,
                        "comment": commentController.text,
                        "delivery_method": _meetingType
                      };
                      ref
                          .read(orderProvider.notifier)
                          .createOrder(context, json, ref);
                      ref.read(cartProvider.notifier).clearCart();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: orderState!.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Confirm Order',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: SafeArea(
      //   child: Padding(
      //     padding: const EdgeInsets.all(10),
      //     child: ElevatedButton(
      //       onPressed: () {
      //         var json = {
      //           "token": user!.user!.token,
      //           "address_id": defaultAddress.address!.addressId,
      //           "comment": commentController.text
      //         };
      //         ref.read(orderProvider.notifier).createOrder(context, json, ref);
      //         ref.read(cartProvider.notifier).clearCart();
      //       },
      //       style: ElevatedButton.styleFrom(
      //         padding: const EdgeInsets.symmetric(vertical: 16),
      //         backgroundColor: Colors.green,
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(8),
      //         ),
      //       ),
      //       child: orderState!.isLoading
      //           ? const CircularProgressIndicator(
      //         color: Colors.white,
      //       )
      //           : const Text(
      //         'Confirm Order',
      //         style: TextStyle(fontSize: 16, color: Colors.white),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
