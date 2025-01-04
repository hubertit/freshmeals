import 'package:flutter/material.dart';

import '../../../utls/styles.dart';

InputDecoration iDecoration({String? hint}) {
  return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      border: StyleUtls.dashInputBorder,

      // filled: false,
      // fillColor: Colors.grey.withOpacity(0.1),
    );
}
