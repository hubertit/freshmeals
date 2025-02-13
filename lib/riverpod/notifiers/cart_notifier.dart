import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/theme/colors.dart';
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

      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data']['cart_items'] ?? [];
        final Map<String, dynamic>? summaryJson =
            response.data['data']['summary'];

        List<CartItem> products =
            myList.map((json) => CartItem.fromJson(json)).toList();
        CartSummary summary = CartSummary.fromJson(summaryJson);

        state = CartState(
            cartItems: products,
            summary: summary,
            isLoading: false,
            isAddingItem: false);
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
      state = state!.copyWith(isAddingItem: true);
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
        print(response.data);
        var user = ref.watch(userProvider);
        if (user!.user != null) {
          final List<dynamic> myList =
              response.data['data']['cart_items'] ?? [];
          final Map<String, dynamic>? summaryJson =
              response.data['data']['summary'];

          List<CartItem> products =
              myList.map((json) => CartItem.fromJson(json)).toList();
          CartSummary summary = CartSummary.fromJson(summaryJson);

          state = CartState(
              cartItems: products,
              summary: summary,
              isLoading: false,
              isAddingItem: false);
        }
        ref.read(countProvider.notifier).fetchCount(context, json['token']);

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
      state = state!.copyWith(isAddingItem: false);
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
        print(response.data);
        //   List<CartItem> products = (response.data['data'] as List)
        //       .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
        //       .toList();
        //   state = CartState(cartItems: products, isLoading: false);
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: response.data['code'] == 400
                  ? const Color(0xffFFF3CD)
                  : primarySwatch,
              content: Text(
                response.data['message'],
                style: TextStyle(
                    color: response.data['code'] == 400
                        ? const Color(0xff664d03)
                        : null),
              )),
        );
      }
    } catch (e) {
      // Handle the error
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  void clearCart() {
    state = state!.copyWith(cartItems: [], summary: null, isLoading: false);
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
        final List<dynamic> myList = response.data['data']['cart_items'] ?? [];
        final Map<String, dynamic>? summaryJson =
            response.data['data']['summary'];

        List<CartItem> products =
            myList.map((json) => CartItem.fromJson(json)).toList();
        CartSummary summary = CartSummary.fromJson(summaryJson);

        state = CartState(
            cartItems: products,
            summary: summary,
            isLoading: false,
            isAddingItem: false);
        // ref.read(countProvider.notifier).fetchCount(context, token);
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
  final bool isAddingItem;
  CartState(
      {required this.cartItems,
      required this.summary,
      required this.isLoading,
      required this.isAddingItem});

  factory CartState.initial() => CartState(
      cartItems: [],
      summary: CartSummary.initial(),
      isLoading: false,
      isAddingItem: false);

  CartState copyWith(
      {List<CartItem>? cartItems,
      CartSummary? summary,
      bool? isLoading,
      bool? isAddingItem}) {
    return CartState(
        cartItems: cartItems ?? this.cartItems,
        summary: summary ?? this.summary,
        isLoading: isLoading ?? this.isLoading,
        isAddingItem: isAddingItem ?? this.isAddingItem);
  }
}
