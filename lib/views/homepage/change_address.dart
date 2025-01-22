import 'package:flutter/material.dart';
import 'package:freshmeals/constants/_assets.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:freshmeals/utls/styles.dart';
import 'package:go_router/go_router.dart';

class ChangeAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Change Delivery Address',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
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
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Home',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: secondarTex),
                        ),
                        const Text(
                          'Default Address',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
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
                                  'Kibagabaga, Kimironko, Kigali',
                                  style: TextStyle(
                                      fontSize: 14, color: secondarTex),
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
                                  'John Doe',
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
                                  '+250780 000 000',
                                  style: TextStyle(fontSize: 14),
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
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(10),
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
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Work',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: secondarTex),
                        ),
                      ],
                    ),
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
                                  'Kibagabaga, Kimironko, Kigali',
                                  style: TextStyle(
                                      fontSize: 14, color: secondarTex),
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
                                  'John Doe',
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
                                  '+250780 000 000',
                                  style: TextStyle(fontSize: 14),
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
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(10),
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
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Company',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: secondarTex),
                        ),
                      ],
                    ),
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
                                  'Kibagabaga, Kimironko, Kigali',
                                  style: TextStyle(
                                      fontSize: 14, color: secondarTex),
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
                                  'John Doe',
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
                                  '+250780 000 000',
                                  style: TextStyle(fontSize: 14),
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
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push("/newAddress");
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add New Address',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
