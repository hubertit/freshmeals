import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/constants/_assets.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';

import '../../riverpod/providers/auth_providers.dart';

class ChangeAddress extends ConsumerStatefulWidget {
  const ChangeAddress({super.key});

  @override
  ConsumerState<ChangeAddress> createState() => _ChangeAddressState();
}

class _ChangeAddressState extends ConsumerState<ChangeAddress> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.watch(userProvider);
      if (user!.user != null) {
        await ref
            .read(addressesProvider.notifier)
            .fetchAddress(context, user.user!.token);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var addresses = ref.watch(addressesProvider);
    var user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          ' Delivery Addresses',
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                context.push("/newAddress");
              },
              icon: const Icon(Icons.add_circle_outline)),
          const SizedBox(
            width: 5,
          )
        ],
      ),
      body: addresses!.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(addresses.slotsData.length, (index) {
                    var address = addresses.slotsData[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Default Address',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: secondarTex),
                              ),
                              // if()
                              Switch(
                                value: address.isDefault,
                                onChanged: (value) {
                                  // _toggleTheme();
                                  var json = {
                                    "token": user!.user!.token,
                                    "address_id": address.addressId
                                  };
                                  ref
                                      .read(addressesProvider.notifier)
                                      .setDefault(context, json, ref);
                                },
                                inactiveTrackColor: scaffold,
                                activeTrackColor: primarySwatch,
                                activeColor: Colors.white,
                                inactiveThumbColor: Colors.black54,
                              ),
                              //  const Text(
                              //   'Default Address',
                              //   style: TextStyle(color: Colors.green),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 8),
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
                                        Flexible(
                                          child: Text(
                                            address.mapAddress,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: secondarTex),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
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
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            context.push('/newAddress',
                                                extra: address);
                                          },
                                          child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor:
                                                primarySwatch.withOpacity(0.1),
                                            child: const Icon(Icons.edit,
                                                color: primarySwatch, size: 14),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Delete Address',
                                                    // style: TextStyle(color: Colors.red),
                                                  ),
                                                  content: const Text(
                                                      'Are you sure you want to delete this Address?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () async {
                                                        var json = {
                                                          "token":
                                                              user.user!.token,
                                                          "address_id":
                                                              address.addressId
                                                        };
                                                        ref
                                                            .read(
                                                                addressesProvider
                                                                    .notifier)
                                                            .deleteAddress(
                                                                context,
                                                                json,
                                                                ref);
                                                      },
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.redAccent
                                                .withOpacity(0.2),
                                            child: const Icon(Icons.delete,
                                                color: Colors.redAccent,
                                                size: 14),
                                          ),
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
                    );
                  })
                  // [
                  //   Container(
                  //     padding: const EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(8),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey.withOpacity(0.1),
                  //           blurRadius: 8,
                  //           spreadRadius: 2,
                  //         ),
                  //       ],
                  //     ),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               'Home',
                  //               style: TextStyle(
                  //                   fontSize: 16,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: secondarTex),
                  //             ),
                  //             const Text(
                  //               'Default Address',
                  //               style: TextStyle(color: Colors.green),
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(height: 8),
                  //         Row(
                  //           children: [
                  //             Image.asset(
                  //               AssetsUtils.rectangle,
                  //               height: 80,
                  //               width: 80,
                  //             ),
                  //             Expanded(
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Row(
                  //                     children: [
                  //                       SizedBox(
                  //                           width: 30,
                  //                           child: Icon(
                  //                             Icons.location_pin,
                  //                             color: secondarTex,
                  //                             size: 16,
                  //                           )),
                  //                       Text(
                  //                         'Kibagabaga, Kimironko, Kigali',
                  //                         style: TextStyle(
                  //                             fontSize: 14, color: secondarTex),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   SizedBox(height: 4),
                  //                   Row(
                  //                     children: [
                  //                       SizedBox(
                  //                           width: 30,
                  //                           child: Icon(
                  //                             Icons.person,
                  //                             color: secondarTex,
                  //                             size: 16,
                  //                           )),
                  //                       Text(
                  //                         'John Doe',
                  //                         style: TextStyle(fontSize: 14),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   Row(
                  //                     children: [
                  //                       SizedBox(
                  //                           width: 30,
                  //                           child: Icon(
                  //                             Icons.call,
                  //                             color: secondarTex,
                  //                             size: 16,
                  //                           )),
                  //                       Text(
                  //                         '+250780 000 000',
                  //                         style: TextStyle(fontSize: 14),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   SizedBox(height: 16),
                  //   Container(
                  //     padding: EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(8),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey.withOpacity(0.1),
                  //           blurRadius: 8,
                  //           spreadRadius: 2,
                  //         ),
                  //       ],
                  //     ),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Container(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Text(
                  //                 'Work',
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: secondarTex),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         SizedBox(height: 8),
                  //         Row(
                  //           children: [
                  //             Image.asset(
                  //               AssetsUtils.rectangle,
                  //               height: 80,
                  //               width: 80,
                  //             ),
                  //             Expanded(
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Row(
                  //                     children: [
                  //                       SizedBox(
                  //                           width: 30,
                  //                           child: Icon(
                  //                             Icons.location_pin,
                  //                             color: secondarTex,
                  //                             size: 16,
                  //                           )),
                  //                       Text(
                  //                         'Kibagabaga, Kimironko, Kigali',
                  //                         style: TextStyle(
                  //                             fontSize: 14, color: secondarTex),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   SizedBox(height: 4),
                  //                   Row(
                  //                     children: [
                  //                       SizedBox(
                  //                           width: 30,
                  //                           child: Icon(
                  //                             Icons.person,
                  //                             color: secondarTex,
                  //                             size: 16,
                  //                           )),
                  //                       Text(
                  //                         'John Doe',
                  //                         style: TextStyle(fontSize: 14),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   Row(
                  //                     children: [
                  //                       SizedBox(
                  //                           width: 30,
                  //                           child: Icon(
                  //                             Icons.call,
                  //                             color: secondarTex,
                  //                             size: 16,
                  //                           )),
                  //                       Text(
                  //                         '+250780 000 000',
                  //                         style: TextStyle(fontSize: 14),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   SizedBox(height: 16),
                  //   Container(
                  //     padding: EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(8),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey.withOpacity(0.1),
                  //           blurRadius: 8,
                  //           spreadRadius: 2,
                  //         ),
                  //       ],
                  //     ),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Container(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Text(
                  //                 'Company',
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: secondarTex),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         SizedBox(height: 8),
                  //         Row(
                  //           children: [
                  //             Image.asset(
                  //               AssetsUtils.rectangle,
                  //               height: 80,
                  //               width: 80,
                  //             ),
                  //             Expanded(
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Row(
                  //                     children: [
                  //                       SizedBox(
                  //                           width: 30,
                  //                           child: Icon(
                  //                             Icons.location_pin,
                  //                             color: secondarTex,
                  //                             size: 16,
                  //                           )),
                  //                       Text(
                  //                         'Kibagabaga, Kimironko, Kigali',
                  //                         style: TextStyle(
                  //                             fontSize: 14, color: secondarTex),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   SizedBox(height: 4),
                  //                   Row(
                  //                     children: [
                  //                       SizedBox(
                  //                           width: 30,
                  //                           child: Icon(
                  //                             Icons.person,
                  //                             color: secondarTex,
                  //                             size: 16,
                  //                           )),
                  //                       Text(
                  //                         'John Doe',
                  //                         style: TextStyle(fontSize: 14),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   Row(
                  //                     children: [
                  //                       SizedBox(
                  //                           width: 30,
                  //                           child: Icon(
                  //                             Icons.call,
                  //                             color: secondarTex,
                  //                             size: 16,
                  //                           )),
                  //                       Text(
                  //                         '+250780 000 000',
                  //                         style: TextStyle(fontSize: 14),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ],
                  ),
            ),
      // bottomNavigationBar: SafeArea(
      //   child: Container(
      //     color: Colors.white,
      //     padding: const EdgeInsets.all(10),
      //     child: SizedBox(
      //       width: double.infinity,
      //       child: ElevatedButton(
      //         onPressed: () {
      //           context.push("/newAddress");
      //         },
      //         style: ElevatedButton.styleFrom(
      //           padding: EdgeInsets.symmetric(vertical: 16),
      //           backgroundColor: Colors.green,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //         ),
      //         child: const Text(
      //           'Add New Address',
      //           style: TextStyle(fontSize: 16, color: Colors.white),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
