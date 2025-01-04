import 'package:flutter/material.dart';

import '../theme/colors.dart';

class StyleUtls {
  static InputBorder commonInputBorder = OutlineInputBorder(
    borderSide:  BorderSide.none,
    borderRadius: BorderRadius.circular(1),
  );

  static InputBorder homeCommonInputBorder = OutlineInputBorder(
    borderSide:  BorderSide(color: fieldsBorder),
    borderRadius: BorderRadius.circular(1),
  );
  static InputBorder dashInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide:  BorderSide.none,
  );
  static ButtonStyle? buttonStyle = ElevatedButton.styleFrom(
      // backgroundColor: ColorConstants.primaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)));
  static ButtonStyle? textButtonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)));
}

Brightness getSystemBrightness(BuildContext context) {
  return MediaQuery.platformBrightnessOf(context);
}

