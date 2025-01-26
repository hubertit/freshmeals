import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../models/home/meal_details.dart';

class NutritionChartPainter extends CustomPainter {
  final Map<String, ContentDetails> contents;

  NutritionChartPainter(this.contents);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 20.0;

    // Background circle
    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Calculate total percentage
    final totalPercentage = contents.values
        .map((entry) => entry.percentage)
        .reduce((a, b) => a + b);

    // Draw segments dynamically based on contents
    var startAngle = -math.pi / 2;
    contents.forEach((key, value) {
      final sweepAngle = 2 * math.pi * value.percentage / totalPercentage;
      final paint = Paint()
        ..color = _getColorForContent(key)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Draw the arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    });
  }

  // Helper method to get colors based on content
  Color _getColorForContent(String content) {
    switch (content) {
      case 'Protein':
        return Colors.purple;
      case 'Carbohydrates':
        return Colors.orange;
      case 'Fat':
        return Colors.green;
      case 'Fiber':
        return Colors.blue;
      case 'Sugar':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
