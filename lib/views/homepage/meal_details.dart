import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:freshmeals/constants/_assets.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import '../../theme/colors.dart';
import 'widgets/add_to_cart.dart';

class MealDetailScreen extends StatelessWidget {
  const MealDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image with Buttons
            Stack(
              children: [
                Image.asset(
                  AssetsUtils.banner, // Add your image path
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon:
                          const Icon(Icons.favorite_border, color: Colors.red),
                      onPressed: () {},
                    ),
                  ),
                ),
                Positioned(
                    left: 10,
                    right: 10,
                    bottom: 0,
                    child: Container(
                      height: 30,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(4))),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 8),
                        child: Text(
                          "Fresh Salad Pasta",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )),
              ],
            ),

            // Content Container
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Section
                      const Text(
                        'Dinner of the day',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Quick Info Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoItem(Icons.access_time, '10 mins', false),
                          _buildInfoItem(
                              Icons.restaurant_menu, '6 ingr', false),
                          _buildInfoItem(Icons.scale, '260 g', false),
                          _buildInfoItem(
                              Icons.local_fire_department, '268 kcal', true),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10).copyWith(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      // Nutrition Information
                      const Text(
                        'Nutrition Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Per serving',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      // Nutrition Chart
                      Center(
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: CustomPaint(
                            painter: NutritionChartPainter(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Nutrition Values
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNutritionValue(
                              'Protein', '46%', '27.0g', Colors.purple),
                          _buildNutritionValue(
                              'Fat', '34%', '19.0g', Colors.orange),
                          _buildNutritionValue(
                              'Protein', '20%', '6.0g', Colors.green),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Add to Basket Button
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10).copyWith(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        "Nutrition Quality",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(height: 26),

                      // Slider with an emoji indicator
                      Container(
                        height: 150,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            FlutterSlider(
                              values: [2],
                              max: 4,
                              min: 0,
                              step: const FlutterSliderStep(step: 1),
                              handler: FlutterSliderHandler(
                                child: const Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),

                              trackBar: FlutterSliderTrackBar(
                                activeTrackBarHeight: 4,
                                activeTrackBar:
                                    const BoxDecoration(color: Colors.green),
                                inactiveTrackBar:
                                    BoxDecoration(color: Colors.grey[300]),
                              ),
                              onDragging:
                                  (handlerIndex, upperValue, lowerValue) {
                                // Handle dragging event if needed
                              },
                            ),
                            // Emoji Indicator
                            const Positioned(
                              top: 0,
                              left:80, // Adjust dynamically for positioning
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.green,
                                    radius: 20,
                                    child: Text(
                                      "💪",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  // SizedBox(height: 4),
                                  // Text(
                                  //   "B",
                                  //   style: TextStyle(
                                  //     color: Colors.green,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Labels (A, B, C, D, E)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ["A", "B", "C", "D", "E"].map((label) {
                          return Text(
                            label,
                            style: TextStyle(
                              fontWeight: label == "B"
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: label == "B" ? Colors.green : Colors.grey,
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height
                          : 16),

                      // Description
                      const Text(
                        "Healthy if taken in moderation. Nutrient-packed. Contains trans fats, saturated fats, sugar etc.",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(

        child: Container(color: Colors.white,
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red,size: 30,),
                onPressed: () {},
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => AddToCartModel(
                          // productModel: widget.product,
                        ));
                  },
                  child: const Text(
                    "Add to Basket",
                    style: TextStyle(fontSize: 16,color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, bool isLast) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(
              right: BorderSide(
                color: Colors.grey.shade100, // Choose your desired color
                width: 1.0, // Set the desired width
              ),
            )),
      child: Column(
        children: [
          Icon(icon, size: 20, color: primarySwatch),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildNutritionValue(
      String label, String percentage, String grams, Color color) {
    return Column(
      children: [
        Text(
          percentage,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(grams, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class NutritionChartPainter extends CustomPainter {
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

    // Draw segments
    final segments = [
      Segment(0.46, Colors.purple, "46%"),
      Segment(0.34, Colors.orange, "34%"),
      Segment(0.20, Colors.green, "20%"),
    ];

    var startAngle = -math.pi / 2;
    for (var segment in segments) {
      final sweepAngle = 2 * math.pi * segment.value;
      final paint = Paint()
        ..color = segment.color
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

      // Calculate text position
      final labelAngle = startAngle + sweepAngle / 2;
      final labelRadius =
          radius - strokeWidth * 1.2; // Adjust to position text inside
      final labelOffset = Offset(
        center.dx + labelRadius * math.cos(labelAngle),
        center.dy + labelRadius * math.sin(labelAngle),
      );

      // Draw percentage text
      final textSpan = TextSpan(
        text: segment.label,
        style: TextStyle(
          color: segment.color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        labelOffset -
            Offset(textPainter.width / 2,
                textPainter.height / 2), // Center the text
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Segment {
  final double value;
  final Color color;
  final String label;

  Segment(this.value, this.color, this.label);
}
