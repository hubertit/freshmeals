import 'package:flutter/material.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';

class MyOrderDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '#OD2204',
          style: TextStyle(color: Colors.black),
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
                    Container(margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
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
                borderRadius: BorderRadius.circular(12),
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
                    _buildOrderDetailRow('Order List', '12 Items'),
                    const Divider(
                      thickness: 0.3,
                    ),
                    _buildOrderDetailRow('Total Price', 'RWF 2000'),
                    const Divider(
                      thickness: 0.3,
                    ),
                    _buildOrderDetailRow('Delivery Fee', 'RWF 1200'),
                    const Divider(
                      thickness: 0.3,
                    ),
                    _buildOrderDetailRow(
                      'Total Bill',
                      'RWF 3200',
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),
            ),
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
  // Text(
  // title,
  // style: TextStyle(
  // fontSize: 12,
  // color: isActive ? Colors.green : Colors.grey,
  // ),
  // ),
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
