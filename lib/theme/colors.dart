import 'package:flutter/material.dart';

Color blackColor = Colors.black;
// Color formFieldsColor = const Color(0xffF4F4F4);

MaterialColor createMaterialColor(Color color) {
  List<int> strengths = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int strength in strengths) {
    swatch[strength] =
        Color.fromRGBO(r, g, b, (strength / 900).clamp(0.0, 1.0));
  }

  return MaterialColor(color.value, swatch);
}

// MaterialColor primarySwatch = createMaterialColor(const Color(0xff264E9A));
// const Color primaryColor = Color(0xFF0181C6);

const int primaryColorValue = 0xff64BA02; // Updated primary color value
const MaterialColor primarySwatch = MaterialColor(
  primaryColorValue,
  {
    50: Color(0xfff2fbe7),  // Lighter shade
    100: Color(0xffdef4bf), // Lighter shade
    200: Color(0xffc6ec94), // Lighter shade
    300: Color(0xffafe36a), // Lighter shade
    400: Color(0xff99db46), // Lighter shade
    500: Color(primaryColorValue), // Primary color
    600: Color(0xff5caf02),       // Darker shade
    700: Color(0xff509b02),       // Darker shade
    800: Color(0xff438702),       // Darker shade
    900: Color(0xff306902),       // Darker shade
  },
);


// Color scaffold = const Color(0xffffffff);

Color redItaryana = const Color(0xffDC3545);
Color scaffold = const Color(0xffF5f5f7);
Color primaryText = const Color(0xff202123);
Color secondarTex = const Color(0xff8F9BB3);
Color fieldsBackground = const Color(0xffFFFFFF);
Color fieldsBorder = const Color(0xff051e32);
Color errorColor = const Color(0xffD93025);
Color successColor = const Color(0xff34A853);
Color accentColor = const Color(0xff6DAA3C);
// #f5f5f7
