import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/user_model.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/_api_utls.dart';
import '../../models/account_info.dart';

class AccountInfoNotifier extends StateNotifier<AccountInfoState?> {
  AccountInfoNotifier() : super(AccountInfoState.initial());

  final Dio _dio = Dio();

  Future<void> fetchAccountInfo(String token, WidgetRef ref) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.post(
        '${baseUrl}user/get_profile',
        data: {"token": token},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        User user = User.fromJson(response.data['data']);

        state = AccountInfoState(accountInfo: user, isLoading: false);
        ref.read(userProvider.notifier).saveUserToPreferences(User(
            userId: user.userId,
            name: user.name,
            email: user.email,
            phoneNumber: user.phoneNumber,
            token: token));
      } else {
        throw Exception('${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('${e.response?.statusCode} ${e.response?.data}');
      }
    } catch (e) {
      print('Failed to fetch account info: $e');
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  Future<void> updateProfile(
      {required String token,
      required String name,
      required String email,
      required String phone,
      required int age,
      required String gender,
      required String healthStatus,
      required double height,
      required double weight,
      String? activityLevel,
      required List<int>? dietaryPreferences,
      required WidgetRef ref,
      required BuildContext context}) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.put(
        '${baseUrl}user/update',
        data: {
          "token": token,
          "name": name,
          "email": email,
          "phone": phone,
          "age": age,
          "gender": gender,
          "health_status": healthStatus,
          "height": height,
          "weight": weight,
          "activity_level": activityLevel,
          "dietary_preferences": dietaryPreferences,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        await fetchAccountInfo(token, ref);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'])),
        );
        context.pop();
      } else {
        throw Exception('Failed to update profile: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error updating profile: $e');
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }
}

class AccountInfoState {
  final User? accountInfo;
  final bool isLoading;

  AccountInfoState({this.accountInfo, required this.isLoading});

  factory AccountInfoState.initial() =>
      AccountInfoState(accountInfo: null, isLoading: false);

  AccountInfoState copyWith({User? accountInfo, bool? isLoading}) {
    return AccountInfoState(
      accountInfo: accountInfo ?? this.accountInfo,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
