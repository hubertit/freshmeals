import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class BackgroundBlur extends StatelessWidget {
  Widget? screens;
  double paddingSize;

  BackgroundBlur({Key? key, this.screens, required this.paddingSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Positioned(
            //     top: 150,
            //     left: 250,
            //     child: Container(
            //       height: 100,
            //       width: 100,
            //       decoration: const BoxDecoration(color: Color(0xFF86A7B1)),
            //     )),
            // Positioned(
            //     top: 30,
            //     left: 60,
            //     child: Container(
            //       height: 100,
            //       width: 100,
            //       decoration: const BoxDecoration(color: primarySwatch),
            //     )),
            // Positioned(
            //     top: 200,
            //     left: -80,
            //     child: Container(
            //       height: 200,
            //       width: 100,
            //       decoration: const BoxDecoration(color: Color(0xFF86A7B1)),
            //     )),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 90.0),
              child: Container(
                color: Colors.white.withOpacity(.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: paddingSize),
              child: screens,
            )
          ],
        ),
      ),
    );
  }
}
