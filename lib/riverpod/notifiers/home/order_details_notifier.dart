import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/address_model.dart';
import 'package:freshmeals/models/home/order_details.dart';
import '../../../constants/_api_utls.dart';

class OrderDetailsNotifier extends StateNotifier<OrderDetailsState?> {
  OrderDetailsNotifier() : super(OrderDetailsState.initial());

  final Dio _dio = Dio();

  Future<void> fetchOderDetails(json) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.post(
        '${baseUrl}orders/details',
        data: json,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print(response.data);
      if (response.statusCode == 200 && response.data['data'] != null) {
        OrderDetails user = OrderDetails.fromJson(response.data['data']);
        state = OrderDetailsState(order: user, isLoading: false);
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

class OrderDetailsState {
  final OrderDetails? order;
  final bool isLoading;

  OrderDetailsState({this.order, required this.isLoading});

  factory OrderDetailsState.initial() =>
      OrderDetailsState(order: null, isLoading: false);

  OrderDetailsState copyWith({OrderDetails? user, bool? isLoading}) {
    return OrderDetailsState(
      order: user ?? this.order,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
