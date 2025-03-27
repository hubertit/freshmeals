import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';

import '../../constants/_assets.dart';
import '../../riverpod/providers/auth_providers.dart';
import '../../riverpod/providers/home.dart';
import '../../theme/colors.dart';
import '../../utls/callbacks.dart';
import '../../utls/styles.dart';

class ChartScreen extends ConsumerStatefulWidget {
  const ChartScreen({super.key});

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
        await ref
            .read(cartProvider.notifier)
            .myCart(context, user.user!.token, ref);
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
    // var count = ref.watch(countProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Cart",
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
                  child: Column(
                    children: List.generate(
                      cart.cartItems.length,
                      (index) {
                        var item = cart.cartItems[index];
                        return Stack(
                          children: [
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.all(10),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              item.mealName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Rwf ${formatMoney((item.price).toString())} / Item",
                                        style: TextStyle(
                                            color: secondarTex,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          cart.isAddingItem
                                              ? const SizedBox(
                                                  height: 15,
                                                  width: 15,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ))
                                              : Text(
                                                  "Rwf ${formatMoney((item.price * item.quantity).toString())}",
                                                  style: const TextStyle(
                                                      color: primarySwatch,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 1, horizontal: 1),
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
                                                    "token": user!.user!.token,
                                                    "meal_id": item.mealId,
                                                    "quantity":
                                                        item.quantity - 1
                                                  };
                                                  if (item.quantity > 1) {
                                                    ref
                                                        .read(cartProvider
                                                            .notifier)
                                                        .updateCart(
                                                            ref, context, json);
                                                  }
                                                },
                                                child: const Icon(
                                                  Ionicons.remove,
                                                  color: primarySwatch,
                                                )),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: cart.isAddingItem
                                                ? const SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ))
                                                : Text(
                                                    "${item.quantity}",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 1, horizontal: 1),
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
                                                    "token": user!.user!.token,
                                                    "meal_id": item.mealId,
                                                    "quantity":
                                                        item.quantity + 1
                                                  };
                                                  ref
                                                      .read(
                                                          cartProvider.notifier)
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
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        var json = {
                                          "token": user!.user!.token,
                                          "meal_id": item.mealId,
                                        };
                                        ref
                                            .read(cartProvider.notifier)
                                            .remove(context, ref, json);
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
                            ),
                          ],
                        );
                      },
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
                      cart.isAddingItem
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ))
                          : Text(
                              "Rwf ${formatMoney(cart!.summary.subtotal)}",
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
