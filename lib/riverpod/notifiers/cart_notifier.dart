import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/_api_utls.dart';
import '../../models/home/cart_model.dart';
import '../providers/auth_providers.dart';
import '../providers/home.dart';

class CartNotifier extends StateNotifier<CartState?> {
  CartNotifier() : super(CartState.initial());

  final Dio _dio = Dio();

  Future<void> myCart(BuildContext context, String token, WidgetRef ref) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.post(
        '${baseUrl}cart/items',
        data: {"token": token},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> myList = response.data['data']['cart_items'] ?? [];
        final Map<String, dynamic>? summaryJson =
            response.data['data']['summary'];

        List<CartItem> products =
            myList.map((json) => CartItem.fromJson(json)).toList();
        CartSummary summary = CartSummary.fromJson(summaryJson);

        state =
            CartState(cartItems: products, summary: summary, isLoading: false);
        ref.read(countProvider.notifier).fetchCount(context, token);
      }
    } catch (e) {
      // Handle error
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  Future<void> updateCart(WidgetRef ref, BuildContext context, var json) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.put(
        '${baseUrl}cart/update',
        data: json,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        var user = ref.watch(userProvider);
        if (user!.user != null) {
          await ref
              .read(cartProvider.notifier)
              .myCart(context, user.user!.token, ref);
        }
        // List<CartItem> products = (response.data['data'] as List)
        //     .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
        //     .toList();
        // state = CartState(cartItems: products, isLoading: false);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(response.data['message'])),
        // );
      }
    } catch (e) {
      // Handle the error
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  Future<void> addToCart(WidgetRef ref, BuildContext context, var json) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.post(
        '${baseUrl}cart/add',
        data: json,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        var user = ref.watch(userProvider);
        if (user!.user != null) {
          await ref
              .read(cartProvider.notifier)
              .myCart(context, user.user!.token, ref);
        }
        //   List<CartItem> products = (response.data['data'] as List)
        //       .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
        //       .toList();
        //   state = CartState(cartItems: products, isLoading: false);
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'])),
        );
      }
    } catch (e) {
      // Handle the error
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  Future<void> remove(BuildContext context, WidgetRef ref, var json) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.put(
        '${baseUrl}cart/remove',
        data: json,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // List<CartItem> products = (response.data['data'] as List)
        //     .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
        //     .toList();
        // state = CartState(cartItems: products, isLoading: false);
        // context.pop();
        var user = ref.watch(userProvider);
        if (user!.user != null) {
          await ref
              .read(cartProvider.notifier)
              .myCart(context, user.user!.token, ref);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'])),
        );
      }
    } catch (e) {
      // Handle the error
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }
}

class CartState {
  final List<CartItem> cartItems;
  final CartSummary summary;
  final bool isLoading;

  CartState({
    required this.cartItems,
    required this.summary,
    required this.isLoading,
  });

  factory CartState.initial() => CartState(
        cartItems: [],
        summary: CartSummary.initial(),
        isLoading: false,
      );

  CartState copyWith({
    List<CartItem>? cartItems,
    CartSummary? summary,
    bool? isLoading,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
