import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/_api_utls.dart';
import '../../models/user_model.dart';

class UserNotifier extends StateNotifier<UserState?> {
  UserNotifier() : super(UserState.initial());

  final Dio _dio = Dio();

  Future<void> login(BuildContext context, WidgetRef ref, String phone,
      String password) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.post(
        '${baseUrl}user/login',
        data: {
          'identifier': phone,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data['message']}')),
      );
      print(response.data);
      if (response.statusCode == 200 && response.data['data'] != null) {
        User user = User.fromJson(response.data['data']);
        state = UserState(user: user, isLoading: false);
        print(response.data['data']);
        await saveUserToPreferences(user);
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor:redItaryana,content: Text('${response.data['message']}')),
        );
        throw Exception(' ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('${e.response?.statusCode} ${e.response?.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: redItaryana,
              content: Text(' ${e.response?.data['message']}')),
        );
      } else {
        print('${e.response}');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Login failed: ${e.message}')),
        // );
      }
    } catch (e) {
      print('You Failed to login: ${e}');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Login failed: $e')),
      // );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  Future<void> register(
      BuildContext context, WidgetRef ref, Map<String, dynamic> json) async {
    try {
      state = state!.copyWith(isLoading: true);
      print(json);
      final response = await _dio.post(
        '${baseUrl}user/register',
        data: json,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print(response.data);
      if (response.statusCode == 201 && response.data['data'] != null) {
        // User user = User.fromJson(response.data['data']);
        // state = UserState(user: user, isLoading: false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered successfully')),
        );
        // await _saveUserToPreferences(user);
        // context.go("/login");
        context.push('/welcome');

      } else {
        throw Exception('${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print(' ${e.response?.data['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e.response?.data['message']}')),
        );
      } else {
        print(' ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('register failed: ${e.message}')),
        );
      }
    } catch (e) {
      print(' $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' $e')),
      );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  // Future<void> update(
  //     BuildContext context, WidgetRef ref, Map<String, dynamic> json) async {
  //   try {
  //     state = state!.copyWith(isLoading: true);
  //     final response = await _dio.post(
  //       '${baseUrl}account/update',
  //       data: json,
  //       options: Options(
  //         headers: {
  //           'Content-Type': 'application/json',
  //         },
  //       ),
  //     );
  //
  //     if (response.statusCode == 200 && response.data['data'] != null) {
  //       UserModel user = UserModel.fromJson(response.data['data']);
  //       state = UserState(user: user, isLoading: false);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Updated successfully')),
  //       );
  //       await _saveUserToPreferences(user);
  //       context.pop();
  //     } else {
  //       throw Exception('Failed to Update');
  //     }
  //   } on DioError catch (e) {
  //     if (e.response != null) {
  //       print(
  //           ' Failed to register: ${e.response?.statusCode} ${e.response?.data}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content: Text('register failed: ${e.response?.data['message']}')),
  //       );
  //     } else {
  //       print('You Failed to register: ${e.message}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('register failed: ${e.message}')),
  //       );
  //     }
  //   } catch (e) {
  //     print('You Failed to register: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('register failed: $e')),
  //     );
  //   } finally {
  //     state = state!.copyWith(isLoading: false);
  //   }
  // }
  //
  Future<void> saveUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }
  //
  // Future<void> _loadUserFromPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userData = prefs.getString('user');
  //   if (userData != null) {
  //     final userMap = jsonDecode(userData) as Map<String, dynamic>;
  //     state = UserState(user: UserModel.fromJson(userMap), isLoading: false);
  //   }
  // }
  //
  Future<void> logout(WidgetRef ref, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    state = UserState(user: null, isLoading: false);
    context.go('/login');
  }
}

class UserState {
  final User? user;
  final bool isLoading;

  UserState({this.user, required this.isLoading});

  factory UserState.initial() => UserState(user: null, isLoading: false);

  UserState copyWith({User? user, bool? isLoading}) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
