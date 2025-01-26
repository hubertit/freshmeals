import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class IngredientItem extends StatelessWidget {
  final String itemTitle;
  final String itemValue;
  final bool isStatus;
  final bool isSmall;
  final Color? statusColor;

  final bool isLast;
  const IngredientItem(
      {super.key,
        required this.itemTitle,
        required this.itemValue,
        this.isStatus = false,
        this.isSmall = false,
        this.statusColor,
        this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(
                itemTitle,
                style:  TextStyle(color: secondarTex,fontSize: 14,fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Container()),
            isStatus
                ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(5),
              )
              ,
              child: Text(
                itemValue,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white),
              ),
            )
                : Text(
              itemValue,
              style: const TextStyle(
                   ),
            )
          ],
        ),
        if (isLast == false)
          const Divider(
            thickness: 0.2,
          )
      ],
    );
  }
}
