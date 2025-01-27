import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';

import '../../constants/_assets.dart';
import '../../riverpod/providers/auth_providers.dart';
import '../../riverpod/providers/home.dart';
import '../../theme/colors.dart';
import '../../utls/styles.dart';

class ChartScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen> {
  int productQt = 1;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.watch(userProvider);
      if (user!.user != null) {
        await ref.read(cartProvider.notifier).myCart(context, user.user!.token,ref);
        await ref
            .read(countProvider.notifier)
            .fetchCount(context, user.user!.token);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cart = ref.watch(cartProvider);
    var user = ref.watch(userProvider);
    var count = ref.watch(countProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Chart",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: cart!.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : cart.cartItems.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        AssetsUtils.empty,
                        height: 100,
                      ),
                    ),
                    const Text("You have no items in cart!")
                  ],
                )
              : SingleChildScrollView(
                  child: Container(
                    // color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 15.0),
                        //   child: Text(
                        //     "Single items",
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold, fontSize: 16),
                        //   ),
                        // ),

                        Column(
                          children: List.generate(
                            cart.cartItems.length,
                            (index) {
                              var item = cart.cartItems[index];
                              return Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(20),
                                margin: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(item.imageUrl)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      // child: ,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item.mealName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Spacer(),
                                            IconButton(
                                                onPressed: () {
                                                  var json = {
                                                    "token": user!.user!.token,
                                                    "meal_id": item.mealId,
                                                  };
                                                  ref
                                                      .read(
                                                          cartProvider.notifier)
                                                      .remove(
                                                          context, ref, json);
                                                },
                                                icon: CircleAvatar(
                                                    radius: 13,
                                                    backgroundColor: scaffold,
                                                    child: const Icon(
                                                      Ionicons.close,
                                                      size: 17,
                                                    ))),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Rwf ${item.price}",
                                              style: const TextStyle(
                                                  color: primarySwatch,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1,
                                                      horizontal: 1),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: scaffold),
                                              child: InkWell(
                                                  onTap: () {
                                                    var user =
                                                        ref.watch(userProvider);
                                                    var json = {
                                                      "token":
                                                          user!.user!.token,
                                                      "meal_id": item.mealId,
                                                      "quantity":
                                                          item.quantity - 1
                                                    };
                                                    if (item.quantity > 1) {
                                                      ref
                                                          .read(cartProvider
                                                              .notifier)
                                                          .updateCart(ref,
                                                              context, json);
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Ionicons.remove,
                                                    color: primarySwatch,
                                                  )),
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                "${item.quantity}",
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1,
                                                      horizontal: 1),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: scaffold),
                                              child: InkWell(
                                                  onTap: () {
                                                    var user =
                                                        ref.watch(userProvider);
                                                    var json = {
                                                      "token":
                                                          user!.user!.token,
                                                      "meal_id": item.mealId,
                                                      "quantity":
                                                          item.quantity + 1
                                                    };
                                                    ref
                                                        .read(cartProvider
                                                            .notifier)
                                                        .updateCart(
                                                            ref, context, json);
                                                  },
                                                  child: const Icon(
                                                    Ionicons.add,
                                                    color: primarySwatch,
                                                  )),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        // const Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 8.0),
                        //   child: Divider(
                        //     thickness: 0.2,
                        //   ),
                        // ),
                        // Column(
                        //   children: List.generate(
                        //     3,
                        //     (index) => Container(
                        //       margin: const EdgeInsets.only(bottom: 20),
                        //       child: Row(
                        //         children: [
                        //           Container(
                        //             width: 70,
                        //             height: 70,
                        //             child: Image.asset(AssetsUtils.fruits),
                        //           ),
                        //           const SizedBox(
                        //             width: 10,
                        //           ),
                        //           const Expanded(
                        //               child: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Text(
                        //                 "Local Cherry",
                        //                 style: TextStyle(
                        //                     fontWeight: FontWeight.bold,
                        //                     fontSize: 16),
                        //               ),
                        //               SizedBox(
                        //                 height: 5,
                        //               ),
                        //               Row(
                        //                 children: [
                        //                   Text(
                        //                     "Rwf ${7000}",
                        //                     style: TextStyle(
                        //                         color: primarySwatch,
                        //                         fontSize: 16,
                        //                         fontWeight: FontWeight.bold),
                        //                   ),
                        //                 ],
                        //               )
                        //             ],
                        //           )),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        // ref.watch(cartProvider)!.isLoading
                        //     ? const CircularProgressIndicator()
                        //     :
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: cart.cartItems.isEmpty
          ? null
          : SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: StyleUtls.buttonStyle,
                  onPressed: () {
                    context.push('/checkout');
                  },
                  child: Row(
                    children: [
                      Text(
                        "Rwf ${count!.count.totalAmount}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const Spacer(),
                      const Text(
                        "Check Out",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
