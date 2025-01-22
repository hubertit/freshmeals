import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';

import '../../constants/_assets.dart';
import '../../theme/colors.dart';
import '../../utls/styles.dart';

class ChartScreen extends StatefulWidget {
  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  int productQt = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Chart",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  "Single items",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Column(
                children: List.generate(
                  3,
                  (index) => Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          child: Image.asset(AssetsUtils.fruits),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Local Cherry",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Rwf ${productQt * 700}",
                                  style: const TextStyle(
                                      color: primarySwatch,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 1),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
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
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "${productQt}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 1),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
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
                              ],
                            )
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  thickness: 0.2,
                ),
              ),
              Column(
                children: List.generate(
                  3,
                  (index) => Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          child: Image.asset(AssetsUtils.fruits),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Local Cherry",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Rwf ${productQt * 700}",
                                  style: const TextStyle(
                                      color: primarySwatch,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ),

              // ref.watch(cartProvider)!.isLoading
              //     ? const CircularProgressIndicator()
              //     :
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            style: StyleUtls.buttonStyle,
            onPressed: () {
              context.push('/checkout');
            },
            child:  Row(
              children: [
                 Text(
                  "Rwf ${productQt*700}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16),
                ),
                Spacer(),
                const Text(
                  "Check Out",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16),
                ),
                const SizedBox(width: 20,),
                const Icon(Icons.arrow_forward,color: Colors.white,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
