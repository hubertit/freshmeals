import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class OrderItem extends StatelessWidget {
  final String itemTitle;
  final String itemValue;
  final bool isStatus;
  final bool isSmall;
  final Color? statusColor;

  final bool isLast;
  const OrderItem(
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
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                itemTitle,
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
            Expanded(child: Container()),
            isStatus
                ? Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmall ? 12 : 16,
                        color: isSmall ? Colors.black : primarySwatch),
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
