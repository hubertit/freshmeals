import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/views/homepage/widgets/cover_container.dart';
import 'package:freshmeals/views/homepage/widgets/order_item.dart';
import 'package:go_router/go_router.dart';
import '../../riverpod/providers/auth_providers.dart';
import 'widgets/my_order_card.dart';

class MyOrderScreen extends ConsumerStatefulWidget {
  const MyOrderScreen({super.key});

  @override
  ConsumerState<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends ConsumerState<MyOrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.watch(userProvider);
      if (user!.user != null) {
        await ref
            .read(orderProvider.notifier)
            .fetchOrders(context, user.user!.token);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var orders = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        // backgroundColor: Colors.white,
        title: const Text('My Orders'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.green,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Created"),
            Tab(text: "Pending"),
            Tab(text: "Confirmed"),
            Tab(text: "Delivering"),
          ],
        ),
      ),
      body: orders!.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(orders.orders, "All"),
                _buildOrderList(orders.orders, "Created"),
                _buildOrderList(orders.orders, "pending"),
                _buildOrderList(orders.orders, "Confirmed"),
                _buildOrderList(orders.orders, "delivering"),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
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

  Widget _buildOrderList(List orders, String status) {
    var filteredOrders = status == "All"
        ? orders
        : orders.where((order) => order.status == status).toList();

    if (filteredOrders.isEmpty) {
      return const Center(
        child: Text("No orders found", style: TextStyle(color: Colors.grey)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(filteredOrders.length, (index) {
          var order = filteredOrders[index];
          return MyOrderCard(order: order,);
            Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () {
                context.push('/myOrderDetails');
              },
              child: CoverContainer(margin: 0, children: [
                OrderItem(
                    itemTitle: "Order ID", itemValue: "#OD${order.orderId}"),
                const OrderItem(
                    itemTitle: "Order List",
                    itemValue: "12 Items",
                    isSmall: true),
                OrderItem(
                    itemTitle: "Total Bill", itemValue: "${order.totalPrice}"),
                OrderItem(
                  itemTitle: "Status",
                  itemValue: order.status,
                  isLast: true,
                  isSmall: true,
                  isStatus: true,
                  statusColor: order.status == "pending"
                      ? Colors.orangeAccent
                      : Colors.blue,
                ),
              ]),
            ),
          );
        }),
      ),
    );
  }
}
