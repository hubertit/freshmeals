import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/address_model.dart';
import '../../../constants/_api_utls.dart';

class DefaultAddressNotifier extends StateNotifier<DefaultAddressState?> {
  DefaultAddressNotifier() : super(DefaultAddressState.initial());

  final Dio _dio = Dio();

  Future<void> fetchDefaultAdress(String token) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.post(
        '${baseUrl}addresses/get_default',
        data: {"token": token},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print(response.data);
      if (response.statusCode == 200 && response.data['data'] != null) {
        DefaultAddress user = DefaultAddress.fromJson(response.data['data']);
        state = DefaultAddressState(address: user, isLoading: false);
        print(response.data['data']);
      } else {
        throw Exception(' ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('${e.response?.statusCode} ${e.response?.data}');
      } else {}
    } catch (e) {
      print('You Failed to login: ${e}');
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }
}

class DefaultAddressState {
  final DefaultAddress? address;
  final bool isLoading;

  DefaultAddressState({this.address, required this.isLoading});

  factory DefaultAddressState.initial() =>
      DefaultAddressState(address: null, isLoading: false);

  DefaultAddressState copyWith({DefaultAddress? user, bool? isLoading}) {
    return DefaultAddressState(
      address: user ?? this.address,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
