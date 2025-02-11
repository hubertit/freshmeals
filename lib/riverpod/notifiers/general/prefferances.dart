import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/general/preferances_model.dart';

import '../../../constants/_api_utls.dart';


class PreferencesNotifier extends StateNotifier<PreferencesState?> {
  PreferencesNotifier() : super(PreferencesState.initial());

  final Dio _dio = Dio();

  Future<void> preferences(BuildContext context) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.get(
        '${baseUrl}general/preferences',
      );
      print(response.data['data']);
      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = PreferencesState(
          preferances: myList.map((json) => PreferenceModel.fromJson(json)).toList(),
          isLoading: false,
        );

      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

}

class PreferencesState {
  final List<PreferenceModel> preferances;
  final bool isLoading;

  PreferencesState({required this.preferances, required this.isLoading});

  factory PreferencesState.initial() =>
      PreferencesState(preferances: [], isLoading: false);

  PreferencesState copyWith({List<PreferenceModel>? preferances, bool? isLoading}) {
    return PreferencesState(
      preferances: preferances ?? this.preferances,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
