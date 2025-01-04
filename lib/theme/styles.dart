import 'package:flutter/material.dart';

class StyleUtils {
  static ButtonStyle commonButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      elevation: MaterialStateProperty.all(0),
      // backgroundColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.disabled)?Colors.red:null),
      minimumSize: MaterialStateProperty.all(const Size(230, 0)));

  static ButtonStyle roundedButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      elevation: MaterialStateProperty.all(0),
      // backgroundColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.disabled)?Colors.red:null),
      minimumSize: MaterialStateProperty.all(const Size(230, 0)));

  static ButtonStyle cardButtonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      elevation: MaterialStateProperty.all(0),
      // backgroundColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.disabled)?Colors.red:null),
      minimumSize: MaterialStateProperty.all(const Size(230, 0)));

  // static InputBorder commonInputBorder=OutlineInputBorder(borderRadius: BorderRadius.circular(12));
}

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
