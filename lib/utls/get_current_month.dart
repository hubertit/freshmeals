import 'package:easy_localization/easy_localization.dart';

String getCurrentMonth() {
  DateTime now = DateTime.now();
  return DateFormat('MMM').format(now); // e.g., "Apr"
}
