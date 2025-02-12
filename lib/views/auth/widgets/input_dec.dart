import 'package:flutter/material.dart';

import '../../../utls/styles.dart';

InputDecoration iDecoration({String? hint}) {
  return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      border: StyleUtls.dashInputBorder,
    filled: true,
    fillColor: Colors.white
    );
}
