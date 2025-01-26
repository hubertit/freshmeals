import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/home/meal_model.dart';
import '../../../theme/colors.dart';
import '../../../utls/styles.dart';


class ProductGridCard extends ConsumerStatefulWidget {
  final Meal product;
  const ProductGridCard({super.key, required this.product});

  @override
  ConsumerState<ProductGridCard> createState() => _ProductGridCardState();
}

class _ProductGridCardState extends ConsumerState<ProductGridCard> {
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        context.push("/mealDetails", extra: widget.product);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.network(widget.product.imageUrl),
                  Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                          onPressed: () {
                            // if (user!.user != null) {
                            //   showModalBottomSheet(
                            //       context: context,
                            //       builder: (context) => AddToCartModel(
                            //         productModel: widget.product,
                            //       ));
                            // } else {
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         content: const Text(
                            //             'Login to add products in cart!'),
                            //         actions: <Widget>[
                            //           TextButton(
                            //             onPressed: () {
                            //               context.go('/login');
                            //             },
                            //             child: const Text(
                            //               'Login',
                            //               style: TextStyle(color: Colors.black),
                            //             ),
                            //           ),
                            //           TextButton(
                            //             onPressed: () {
                            //               Navigator.of(context).pop();
                            //             },
                            //             child: const Text(
                            //               'Cancel',
                            //               style: TextStyle(color: Colors.black),
                            //             ),
                            //           ),
                            //         ],
                            //       );
                            //     },
                            //   );
                            // }
                          },
                          icon: const CircleAvatar(
                              radius: 13,
                              backgroundColor: primarySwatch,
                              child: Icon(
                                Icons.add,
                                size: 15,
                                color: Colors.white,
                              ))))
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trimm(18, widget.product.name),
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      "${widget.product.price}",
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
