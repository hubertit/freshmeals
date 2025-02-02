import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/constants/_assets.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:freshmeals/utls/styles.dart';
import 'package:freshmeals/views/homepage/widgets/success_model.dart';
import 'package:go_router/go_router.dart';

import '../../riverpod/providers/auth_providers.dart';
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
      }
    });
    super.initState();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var defaultAddress = ref.watch(defaultAddressProvider);
    var user = ref.watch(userProvider);
    var orderState = ref.watch(orderProvider);
    return Scaffold(
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ID',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '#OD2204',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Address',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: secondarTex),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        Text(
                                          defaultAddress.address!.mapAddress,
                                          style: TextStyle(
                                              fontSize: 14, color: secondarTex),
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
                                          style: const TextStyle(fontSize: 14),
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

              // Delivery Time Settings
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(8),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.1),
              //         blurRadius: 8,
              //         spreadRadius: 2,
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Delivery Time Settings',
              //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //       ),
              //       SizedBox(height: 8),
              //       DropdownButtonFormField<String>(
              //         items: ['Time Slot 1', 'Time Slot 2', 'Time Slot 3']
              //             .map((slot) => DropdownMenuItem(
              //                   child: Text(slot),
              //                   value: slot,
              //                 ))
              //             .toList(),
              //         onChanged: (value) {},
              //         decoration: InputDecoration(
              //           hintText: 'Time Slot',
              //           border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(8),
              //           ),
              //         ),
              //       ),
              //       SizedBox(height: 16),
              //       TextFormField(
              //         decoration: InputDecoration(
              //           hintText: 'Jan 01, 2025',
              //           suffixIcon: const Icon(Icons.calendar_today),
              //           border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(8),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 16),

              // Order Bill Section
              Container(
                padding: EdgeInsets.all(16),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Bill',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order List'),
                        Text('12 Items'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Price'),
                        Text('RWF 5,000'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Fee'),
                        Text('RWF 1,200'),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Bill',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'RWF 6,200',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Payment Method Section
              // Container(
              //   padding: EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(8),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.1),
              //         blurRadius: 8,
              //         spreadRadius: 2,
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const Text(
              //             'Payment Method',
              //             style: TextStyle(
              //                 fontSize: 16, fontWeight: FontWeight.bold),
              //           ),
              //           TextButton(
              //             onPressed: () {},
              //             child: Text(
              //               'Add new Method',
              //               style: TextStyle(color: Colors.green),
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 8),
              //       ListTile(
              //         leading: Icon(Icons.credit_card),
              //         title: Text('**** **** **** *368'),
              //         trailing:
              //             Radio(value: 1, groupValue: 2, onChanged: (value) {}),
              //       ),
              //       ListTile(
              //         leading: Icon(Icons.phone_android, color: Colors.yellow),
              //         title: Text('0788 123 456'),
              //         trailing:
              //             Radio(value: 2, groupValue: 2, onChanged: (value) {}),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 16),
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
              const SizedBox(height: 16),

              // Confirm Order Button
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                var json = {
                  "token": user!.user!.token,
                  "address_id": defaultAddress.address!.addressId,
                  "comment": commentController.text
                };
                ref
                    .read(orderProvider.notifier)
                    .createOrder(context, json, ref);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: orderState!.isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Confirm Order',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
