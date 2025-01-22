import 'package:flutter/material.dart';
import 'package:freshmeals/views/homepage/widgets/cover_container.dart';
import 'package:freshmeals/views/homepage/widgets/order_item.dart';
import 'package:go_router/go_router.dart';
import 'widgets/category_card.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

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
          'My Orders',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCategoryTab("Meals", isSelected: true),
                ],
              ),
            ),
          ),
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CoverContainer(margin: 0, children: [
                    OrderItem(
                      itemTitle: "Order ID",
                      itemValue: "#OD2204",
                    ),
                    OrderItem(
                      itemTitle: "Order List",
                      itemValue: "12 Items",
                      isSmall: true,
                    ),
                    OrderItem(
                      itemTitle: "Total Bill",
                      itemValue: "RWF 1960",
                    ),
                    OrderItem(
                      itemTitle: "Status",
                      itemValue: "On the way",
                      isLast: true,
                      isSmall: true,
                      isStatus: true,
                      statusColor: Colors.blue,
                    ),
                  ]),
                  SizedBox(height: 20,),
                  CoverContainer(margin: 0, children: [
                    OrderItem(
                      itemTitle: "Order ID",
                      itemValue: "#OD2204",
                    ),
                    OrderItem(
                      itemTitle: "Order List",
                      itemValue: "12 Items",
                      isSmall: true,
                    ),
                    OrderItem(
                      itemTitle: "Total Bill",
                      itemValue: "RWF 1960",
                    ),
                    OrderItem(
                      itemTitle: "Status",
                      itemValue: "Pending",
                      isLast: true,
                      isSmall: true,
                      isStatus: true,
                      statusColor: Colors.orangeAccent,
                    ),
                  ])
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push('/myOrderDetails');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Go To Shopping',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
