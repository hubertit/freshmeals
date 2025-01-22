import 'package:flutter/material.dart';


class CoverContainer extends StatelessWidget {
  final List<Widget> children;
  final double margin;
  final double horizontalPadding;
  const CoverContainer({super.key, required this.children,this.margin= 10,this.horizontalPadding = 10 });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(vertical: 20, horizontal: horizontalPadding),
      margin:   EdgeInsets.only(left: margin,right: margin,top: margin),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
