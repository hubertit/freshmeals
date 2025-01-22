import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:freshmeals/constants/_assets.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';
import '../../../utls/styles.dart';

class AddToCartModel extends ConsumerStatefulWidget {
  // final ProductModel productModel;
  const AddToCartModel({
    super.key,
    // required this.productModel
  });

  @override
  ConsumerState<AddToCartModel> createState() => _AddToCartModelState();
}

class _AddToCartModelState extends ConsumerState<AddToCartModel> {
  int productQt = 1;

  @override
  Widget build(BuildContext context) {
    // var store = ref.watch(myStoreProvider);
    // var amount =(widget.productModel.productPrice)*productQt;
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: CircleAvatar(
                        backgroundColor: scaffold,
                        radius: 15,
                        child: const Icon(
                          Ionicons.close,
                          size: 15,
                        ))),
                const SizedBox(
                  width: 40,
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      "Add new items",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                thickness: 0.2,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    child: Image.asset(AssetsUtils.fruits),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  const Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Local Cherry",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "For lunch",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            "Rwf 700",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                thickness: 0.2,
              ),
            ),
            Row(
              children: [
                const Text(
                  "Amount",
                  style: TextStyle(),
                ),
                Spacer(),
                const Text(
                  "Rwf 700",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Total price",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Rwf ${productQt * 700}",
                  style: const TextStyle(
                      color: primarySwatch,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                thickness: 0.2,
              ),
            ),

            // ref.watch(cartProvider)!.isLoading
            //     ? const CircularProgressIndicator()
            //     :
            Container(
              margin: const EdgeInsets.only(
                   top: 20, bottom: 40),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: scaffold),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            if (productQt > 1) {
                              productQt -= 1;
                            }
                          });
                        },
                        child: const Icon(
                          Ionicons.remove,
                          color: primarySwatch,
                        )),
                  ),
                  Container(margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "${productQt}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: scaffold),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            productQt += 1;
                          });
                        },
                        child: const Icon(
                          Ionicons.add,
                          color: primarySwatch,
                        )),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: ElevatedButton(
                      style: StyleUtls.buttonStyle,
                      onPressed: () {
                        context.push("/newAddress");
                        // var json = {
                        //   "token": ref.watch(userProvider)!.user!.token,
                        //   "product_id": widget.productModel.productId,
                        //   "quantity": productQt
                        // };
                        // ref
                        //     .read(cartProvider.notifier)
                        //     .addToCart(context, json);
                        // context.pop();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add to cart",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
