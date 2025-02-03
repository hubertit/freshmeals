import 'package:flutter/material.dart';

import '../../../constants/_assets.dart';

class CustomEmptyWidget extends StatelessWidget {
  final String message;
  const CustomEmptyWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return                          Column(children: [
      Center(
        child: Center(
          child: Image.asset(
            AssetsUtils.emptyLogo,
            height: 90,
          ),
        ),
      ),
       Text(
        message,
        style: TextStyle(fontWeight: FontWeight.w500),
      )
    ],)
    ;
  }
}
