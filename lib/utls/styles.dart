import 'package:flutter/material.dart';

import '../theme/colors.dart';

class StyleUtls {
  static InputBorder commonInputBorder = OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(1),
  );

  static InputBorder homeCommonInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: fieldsBorder),
    borderRadius: BorderRadius.circular(1),
  );
  static InputBorder dashInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: BorderSide.none,
  );
  static ButtonStyle? buttonStyle = ElevatedButton.styleFrom(
      // backgroundColor: ColorConstants.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
  static ButtonStyle? textButtonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
}

Brightness getSystemBrightness(BuildContext context) {
  return MediaQuery.platformBrightnessOf(context);
}

String formatStringDigits(String digits) {
  // Extract digits from the string
  // Check the number of digits
  if (digits=='') {
    return ""; // Return all digits if 12 or fewer
  } else if (digits.length <= 13) {
    return digits; // Return all digits if 12 or fewer
  } else {
    return  "${digits.substring(0, 12)}.."; // Return only the first 11 digits
  }
}
