import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:freshmeals/utls/callbacks.dart';
import 'package:go_router/go_router.dart';

import '../../constants/_assets.dart';
import '../../riverpod/providers/auth_providers.dart';
import 'widgets/my_order_card.dart';

class MyOrderDetailsScreen extends ConsumerStatefulWidget {
  final String orderId;
  const MyOrderDetailsScreen({super.key, required this.orderId});

  @override
  ConsumerState<MyOrderDetailsScreen> createState() =>
      _MyOrderDetailsScreenState();
}

class _MyOrderDetailsScreenState extends ConsumerState<MyOrderDetailsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.watch(userProvider);
      if (user!.user != null) {
        var json = {
          "token": user.user!.token,
          "order_id": int.parse(widget.orderId)
        };
        await ref.read(orderDetailsProvider.notifier).fetchOderDetails(json);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var order = ref.watch(orderDetailsProvider);
    var user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          order!.order != null ? '#OD${order.order!.orderId} ' : "",
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stepper Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order'),
                        Text('Arrange'),
                        Text('Delivering'),
                        Text('Done'),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStep('Order', true),
                          Expanded(
                              child: Container(
                            color: primarySwatch,
                            height: 3,
                          )),
                          _buildStep('Arrange', true),
                          Expanded(
                              child: Container(
                            color: primarySwatch,
                            height: 3,
                          )),
                          _buildStep('Delivering', true),
                          Expanded(
                              child: Container(
                            color: Colors.grey[300],
                            height: 3,
                          )),
                          _buildStep('Done', false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add order tracking logic
                          context.push("/trackLocation");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Track Order',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Order Bill Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Bill',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildOrderDetailRow(
                        'Order List', '${order.order!.items.length} Items'),
                    const Divider(
                      thickness: 0.3,
                    ),
                    // _buildOrderDetailRow('Total Price',
                    //     "Rwf ${formatMoney(order.order!.totalPrice)}"),

                    _buildOrderDetailRow(
                        'Address', order.order!.deliveryAddress.mapAddress),
                    const Divider(
                      thickness: 0.3,
                    ),
                    _buildOrderDetailRow(
                      'Total Bill',
                      'Rwf ${formatMoney(order.order!.totalPrice)}',
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: const Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                    order.order!.deliveryAddress.mapAddress,
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
                                    style: const TextStyle(fontSize: 14),
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
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.only(left: 5,bottom: 10),
              child: const Text(
                'Items List',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(order.order!.items.length, (index) {
                  var item = order.order!.items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      children: [
                        Container(
                          // height: 100,
                          width: 75,
                          padding: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border(
                              right: BorderSide(
                                color: Colors.grey, // Border color
                                width: 0.2, // Border width
                              ),
                            ),
                          ),
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 20),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  // color: secondaryColor,
                                  child: Text(
                                    "Quantity: ${item.quantity}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  child: Text(
                                    "${item.price} Rwf",
                                    style: const TextStyle(
                                        fontSize: 12, color: primarySwatch),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, bool isActive) {
    return CircleAvatar(
      radius: 7,
      backgroundColor: isActive ? Colors.green : Colors.grey[300],
    );
  }

  // SizedBox(height: 4),
  Widget _buildOrderDetailRow(String title, String value,
      {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[800],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
              color: isHighlighted ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }


}
