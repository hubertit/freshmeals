import 'package:flutter/material.dart';

import '../../../constants/_assets.dart';

class CustomEmptyWidget extends StatelessWidget {
  final String message;
  final double iconSize;
  final String icon;
  const CustomEmptyWidget(
      {super.key,
      required this.message,
      this.iconSize = 90,
      this.icon = AssetsUtils.emptyLogo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Center(
            child: Image.asset(
              icon,
              height: iconSize,
            ),
          ),
        ),
        Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
