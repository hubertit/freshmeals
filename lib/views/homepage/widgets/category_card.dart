import 'package:flutter/material.dart';

Widget buildCategoryTab(String text, {bool isSelected = false}) {
  return Column(
    children: [
      Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.green : Colors.grey,
        ),
      ),
      if (isSelected)
        Container(
          margin: const EdgeInsets.only(top: 4),
          height: 2,
          width: 20,
          color: Colors.green,
        ),
    ],
  );
}
