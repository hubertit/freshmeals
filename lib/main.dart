import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routers/app_router.dart';
import 'theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RITCO',
      theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSeed(seedColor: primarySwatch),
          primaryColor: primarySwatch,
          scaffoldBackgroundColor: scaffold,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              scrolledUnderElevation: 0,
              elevation: 0,
              titleTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(color: Colors.black87)),
          cardTheme: CardTheme(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          bottomSheetTheme: const BottomSheetThemeData(
            elevation: 0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primarySwatch),
            padding: MaterialStateProperty.all(const EdgeInsets.all(14)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32))),
            elevation: MaterialStateProperty.all(0),
          )),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
            // fillColor: fieldsBackground,
            //
            // filled: true,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 0.2,
                  color: Colors.grey), // Set the default border color to grey
              borderRadius: BorderRadius.circular(3),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(

                  color: Colors.grey), // Set the focused border color to grey
              borderRadius: BorderRadius.circular(5),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 0.2,
                  color: Colors.grey), // Set the enabled border color to grey
              borderRadius: BorderRadius.circular(5),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 0.2,

                  color: Colors.grey), // Set the error border color to red
              borderRadius: BorderRadius.circular(5),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey
                      .shade400), // Set the disabled border color to light grey
              borderRadius: BorderRadius.circular(5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color:
                      Colors.red), // Set the focused error border color to red
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          dialogTheme: DialogTheme(
            elevation: 0,
            backgroundColor: Colors.white, // Set your desired background color
            // titleTextStyle: TextStyle(color: Colors.white), // Set title text color
            // contentTextStyle: TextStyle(color: Colors.white), // Set content text color
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Set dialog border radius
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                  textStyle: const TextStyle(color: primarySwatch),
                  foregroundColor: primarySwatch,
                  side: const BorderSide(color: primarySwatch),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32))))),
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
