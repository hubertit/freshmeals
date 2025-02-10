import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/_api_utls.dart';
import '../../../models/home/order_model.dart';
import '../../../views/homepage/widgets/success_model.dart';

class OderNotifier extends StateNotifier<OrderState> {
  OderNotifier() : super(OrderState.initial());

  final Dio _dio = Dio();

  Future<void> fetchOrders(BuildContext context, String token) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}orders/my_orders',
        data: {"token": token},
      );
      if (response.statusCode == 200) {
        final myList = response.data['data'];

        if (myList is List && myList.isNotEmpty) {
          // Convert response data to Address model list
          final addressList = myList
              .map<OrdersModel>((json) => OrdersModel.fromJson(json))
              .toList();

          // Update state
          state = state.copyWith(slotsData: addressList, isLoading: false);
        } else {
          state = state.copyWith(slotsData: [], isLoading: false);
        }
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      // Optionally show a SnackBar for error feedback
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> createOrder(BuildContext context, json, WidgetRef ref) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _dio.post(
        '$baseUrl/orders/create',
        data: json,
      );
      // Check response code and show Snackbar with message
      if (response.data['code'] == 200) {
        // state = SlotsState(isLoading: false, slotsData: []);
        // ref
        //     .read(addressesProvider.notifier)
        //     .fetchAddress(context, json['token']);
        ref.read(cartProvider.notifier).myCart(context, json['token'], ref);
        launchUrl(Uri.parse(response.data['payment_url']));

        // context.pop();

        context.go("/processing/${response.data['invoice_number']}");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.data['message']}')),
        );
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('An error occurred: $e')),
      // );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateAddress(BuildContext context, json, WidgetRef ref) async {
    try {
      // state = state.copyWith(isLoading: true);

      final response = await _dio.post(
        '$baseUrl/addresses/update',
        data: json,
      );
      // Check response code and show Snackbar with message
      if (response.data['code'] == 200) {
        // state = SlotsState(isLoading: false, slotsData: []);
        ref
            .read(addressesProvider.notifier)
            .fetchAddress(context, json['token']);
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.data['message']}')),
        );
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('An error occurred: $e')),
      // );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> setDefault(BuildContext context, json, WidgetRef ref) async {
    try {
      // state = state.copyWith(isLoading: true);

      final response = await _dio.post(
        '$baseUrl/addresses/set_default',
        data: json,
      );

      // Check response code and show Snackbar with message
      if (response.data['code'] == 200) {
        // state = SlotsState(isLoading: false, slotsData: []);
        ref
            .read(addressesProvider.notifier)
            .fetchAddress(context, json['token']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.data['message']}')),
        );
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('An error occurred: $e')),
      // );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> checkOrderStatus(
      BuildContext context, String invoiceNumber) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _dio.get(
        '${baseUrl}payments/status?invoiceNumber=$invoiceNumber',
      );
      print(response);
      if (response.statusCode == 200) {
        final data = response.data['invoiceDetails'];
        final status = data['paymentStatus'];
        if (status == "PAID") {
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return const SuccessModel();
          //   },
          // );
          context.go("/success");
        } else if (status == "FAILED") {
          context.go("/failed");
        }

        // You can also store this data in the state if needed
      } else {
        throw Exception('Failed to fetch order status');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking order status: $e')),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> deleteAddress(BuildContext context, json, WidgetRef ref) async {
    try {
      // state = state.copyWith(isLoading: true);

      final response = await _dio.post(
        '$baseUrl/addresses/delete',
        data: json,
      );

      // Check response code and show Snackbar with message
      if (response.data['code'] == 200) {
        // state = SlotsState(isLoading: false, slotsData: []);
        ref
            .read(addressesProvider.notifier)
            .fetchAddress(context, json['token']);
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.data['message']}')),
        );
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('An error occurred: $e')),
      // );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

// Future<void> addAddress(BuildContext context, json, WidgetRef ref) async {
//   try {
//     // state = state.copyWith(isLoading: true);
//
//     final response = await _dio.post(
//       '$baseUrl/addresses/add',
//       data: json,
//     );
//
//     // Check response code and show Snackbar with message
//     if (response.data['code'] == 200) {
//       // state = SlotsState(isLoading: false, slotsData: []);
//       ref.read(addressesProvider.notifier).fetchAddress(context, json['token']);
//       context.pop();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(response.data['message'])),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('${response.data['message']}')),
//       );
//     }
//   } catch (e) {
//     // ScaffoldMessenger.of(context).showSnackBar(
//     //   SnackBar(content: Text('An error occurred: $e')),
//     // );
//   } finally {
//     state = state.copyWith(isLoading: false);
//   }
// }
}

class OrderState {
  final List<OrdersModel> orders;
  final bool isLoading;

  // Constructor
  OrderState({required this.orders, required this.isLoading});

  // Initial state factory
  factory OrderState.initial() => OrderState(orders: [], isLoading: false);

  // CopyWith method
  OrderState copyWith({List<OrdersModel>? slotsData, bool? isLoading}) {
    return OrderState(
      orders: slotsData ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
