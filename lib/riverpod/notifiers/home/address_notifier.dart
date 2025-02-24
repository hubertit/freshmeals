import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/address_model.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/_api_utls.dart';

class AdressesNotifier extends StateNotifier<AddressState> {
  AdressesNotifier() : super(AddressState.initial());

  final Dio _dio = Dio();

  Future<void> fetchAddress(BuildContext context, String token) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}addresses/retrieve',
        data: {"token": token},
      );

      if (response.statusCode == 200) {
        final myList = response.data['data'];
        print(response.data);
        if (myList is List && myList.isNotEmpty) {
          // Convert response data to Address model list
          final addressList =
              myList.map<Address>((json) => Address.fromJson(json)).toList();

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

  Future<void> addAddress(BuildContext context, json, WidgetRef ref) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}addresses/add',
        data: json,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print(response);
      //
      // Check response code and show Snackbar with message
      if (response.data['code'] == 200) {
        // state = SlotsState(isLoading: false, slotsData: []);
        ref
            .read(addressesProvider.notifier)
            .fetchAddress(context, json['token']);
        context.go('/');
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
      //   SnackBar(content: Text("${e}")),
      // );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateAddress(BuildContext context, json, WidgetRef ref) async {
    try {
      state = state.copyWith(isLoading: true);

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

class AddressState {
  final List<Address> slotsData;
  final bool isLoading;

  // Constructor
  AddressState({required this.slotsData, required this.isLoading});

  // Initial state factory
  factory AddressState.initial() =>
      AddressState(slotsData: [], isLoading: false);

  // CopyWith method
  AddressState copyWith({List<Address>? slotsData, bool? isLoading}) {
    return AddressState(
      slotsData: slotsData ?? this.slotsData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
