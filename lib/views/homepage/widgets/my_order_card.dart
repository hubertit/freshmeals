import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/order_model.dart';
import 'package:go_router/go_router.dart';
import '../../../riverpod/providers/auth_providers.dart';
import '../../../theme/colors.dart';

class MyOrderCard extends ConsumerStatefulWidget {
  final OrdersModel order;
  const MyOrderCard({
    required this.order,
    super.key,
  });

  @override
  ConsumerState<MyOrderCard> createState() => _CartCardState();
}

class _CartCardState extends ConsumerState<MyOrderCard> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);

    return InkWell(
      onTap: () {
        context.push("/myOrderDetails/${widget.order.orderId.toString()}");
        // },
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              // height: 100,
              width: 95,
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
                widget.order.imageUrl,
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
                      "Order #${widget.order.orderId}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 12,
                          color: Colors.grey,
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          // color: secondaryColor,
                          child: Text(
                            "${widget.order.orderDate}",
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.production_quantity_limits,
                          size: 13,
                          color: Colors.grey,
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            "${widget.order.totalPrice} Rwf",
                            style: const TextStyle(
                                fontSize: 12, color: primarySwatch),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.store,
                          size: 13,
                          color: Colors.grey,
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          // color: secondaryColor,
                          child: Text(
                            widget.order.status,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
