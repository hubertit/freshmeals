import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/user_notifier.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState?>((ref) {
  return UserNotifier();
});

