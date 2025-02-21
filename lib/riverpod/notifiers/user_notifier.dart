import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/_api_utls.dart';
import '../../models/user_model.dart';
import '../../views/auth/new_password.dart';

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
          SnackBar(
              backgroundColor: redItaryana,
              content: Text('${response.data['message']}')),
        );
        throw Exception(' ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('${e.response?.statusCode} ${e.response?.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: redItaryana,
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
        User user = User.fromJson(response.data['data']);
        state = UserState(user: user, isLoading: false);
        print(response.data['data']);
        await saveUserToPreferences(user);
        context.push('/subscribe');
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
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(' $e')),
      // );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  Future<void> saveUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }

  Future<void> logout(WidgetRef ref, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    state = UserState(user: null, isLoading: false);
    await prefs.remove('user');
    context.go('/login');
  }

  Future<void> verifyToken(
      BuildContext context, String token, WidgetRef ref) async {
    try {
      state = state!.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}token/verify',
        data: {'token': token},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        // Token is invalid, log the user out
        await logout(ref, context);
      }
    } on DioError catch (e) {
      await logout(ref, context);
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  Future<void> forgotPassword(BuildContext context, String identifier) async {
    try {
      state = state!.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}user/forgot_password',
        data: {'identifier': identifier},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      context.go('/resetPassword/${identifier}');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('${response.data['message']}')),
      // );

      print(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e.response?.data['message']}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' ${e.message}')),
        );
      }
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  Future<void> verifyResetCode(
      BuildContext context, String identifier, String resetCode) async {
    try {
      state = state!.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}user/verify_code',
        data: {
          'identifier': identifier,
          'reset_code': resetCode,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        // Check if the request was successful
        Reset reset = Reset(code: resetCode, identifier: identifier);
        context.go('/newPassword', extra: reset);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.data['message']}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Unexpected response: ${response.statusCode}')),
        );
      }

      print(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        // Handle errors based on status code
        int statusCode = e.response!.statusCode ?? 0;
        String errorMessage =
            e.response?.data['message'] ?? 'Something went wrong';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e.message}')),
        );
      }
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  Future<void> resetPassword(BuildContext context, String identifier,
      String resetCode, String newPassword) async {
    try {
      state = state!.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}user/reset_password',
        data: {
          'identifier': identifier,
          'reset_code': resetCode,
          'new_password': newPassword,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data['message']}')),
      );

      print(response.data);

      // After resetting the password, navigate to the login page
      context.go('/login');
    } on DioException catch (e) {
      if (e.response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e.response?.data['message']}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' ${e.message}')),
        );
      }
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  Future<void> deleteAccount(
      BuildContext context, String token, WidgetRef ref) async {
    try {
      state = state!.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}user/delete_account',
        data: {'token': token},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data['message']}')),
      );
      if (response.statusCode == 200) {
        await logout(ref, context);
      } else {
        context.pop();
        // Token is invalid, log the user out
      }
    } on DioError catch (e) {
      context.pop();
    } finally {
      state = state!.copyWith(isLoading: false);
    }
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
