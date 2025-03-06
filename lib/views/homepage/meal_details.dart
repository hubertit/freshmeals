import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import 'package:freshmeals/constants/_assets.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:freshmeals/models/home/meal_model.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/utls/callbacks.dart';
import 'package:freshmeals/views/homepage/widgets/contents_chart.dart';
import 'package:freshmeals/views/homepage/widgets/ingredient_item.dart';

import '../../theme/colors.dart';
import 'widgets/add_to_cart.dart';
import 'widgets/cover_container.dart';

class MealDetailScreen extends ConsumerStatefulWidget {
  final String mealId;
  const MealDetailScreen({super.key, required this.mealId});

  @override
  ConsumerState<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  @override
  void initState() {
    var id = widget.mealId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print(widget.mealId);
      ref
          .read(mealDetailsDataProvider.notifier)
          .fetchMealDetails(context, id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
print(widget.mealId);
    var meal = ref.watch(mealDetailsDataProvider);
    var favorites = ref.watch(favoritesProvider);
    var user = ref.watch(userProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: meal!.isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : Column(
                children: [
                  // Header Image with Buttons
                  Stack(
                    children: [
                      Image.network(
                        meal.mealsData!.imageUrl, // Add your image path
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
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.black),
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
                            icon: Icon(
                                isFavorite(meal.mealsData!.mealId,
                                        favorites!.favoriteMeals)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red),
                            onPressed: () {
                              if (isFavorite(meal.mealsData!.mealId,
                                  favorites.favoriteMeals)) {
                                ref
                                    .read(favoritesProvider.notifier)
                                    .removeFavorite(context, user!.user!.token,
                                        int.parse(meal.mealsData!.mealId));
                              } else {
                                ref
                                    .read(favoritesProvider.notifier)
                                    .addFavorite(context, user!.user!.token,
                                        int.parse(meal.mealsData!.mealId));
                              }
                            },
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
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(4))),
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.0, left: 8),
                              child: Text(
                                meal.mealsData!.name,
                                style: const TextStyle(
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
                      Container(width: double.maxFinite,
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
                            Text(
                              "${meal.mealsData!.price} RWF",
                              style: const TextStyle(
                                  color: primarySwatch,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${meal.mealsData!.calories} Kcal",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              meal.mealsData!.description,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Quick Info Row
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     _buildInfoItem(
                            //         Icons.access_time, '10 mins', false),
                            //     _buildInfoItem(
                            //         Icons.restaurant_menu, '6 ingr', false),
                            //     _buildInfoItem(Icons.scale, '260 g', false),
                            //     _buildInfoItem(Icons.local_fire_department,
                            //         '268 kcal', true),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      if (meal.mealsData!.allergens!.isNotEmpty)
                        Container(
                          width: double.maxFinite,
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
                              const SizedBox(height: 10),
                              const Text(
                                'Allergens',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: List.generate(
                                      meal.mealsData!.allergens!.length,
                                      (index) {
                                    return Chip(
                                      label: Text(
                                          meal.mealsData!.allergens![index]),
                                      color: WidgetStateProperty.all(scaffold),
                                      elevation: 0,
                                      side: BorderSide.none,
                                    );
                                  })
                                  // ...() [
                                  //   Chip(label: Text('Lead')),
                                  //   Chip(label: Text('UX Design')),
                                  //   Chip(label: Text('Problem Solving')),
                                  //   Chip(label: Text('Critical')),
                                  // ],
                                  ),
                            ],
                          ),
                        ),

                      // Container(
                      //   margin: const EdgeInsets.all(10).copyWith(top: 20),
                      //   padding: const EdgeInsets.all(10),
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius:
                      //         BorderRadius.vertical(top: Radius.circular(10)),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       const SizedBox(height: 20),
                      //
                      //       // Nutrition Information
                      //       const Text(
                      //         'Nutrition Information',
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       const Text(
                      //         'Per serving',
                      //         style: TextStyle(color: Colors.grey),
                      //       ),
                      //       const SizedBox(height: 20),
                      //
                      //       // Nutrition Chart
                      //       Center(
                      //         child: SizedBox(
                      //           height: 200,
                      //           width: 200,
                      //           child: CustomPaint(
                      //             painter: NutritionChartPainter(
                      //                 meal.mealsData!.contents),
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(height: 20),
                      //
                      //       // Nutrition Values
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //         children:
                      //             meal.mealsData!.contents.entries.map((entry) {
                      //           final contentName = entry.key;
                      //           final contentDetails = entry.value;
                      //
                      //           return _buildNutritionValue(
                      //             contentName,
                      //             '${contentDetails.percentage}%', // You can adjust to the right format if needed
                      //             contentDetails
                      //                 .amount, // Assuming `amount` is the value in grams
                      //             _getColorForContent(contentName),
                      //           );
                      //         }).toList(),
                      //       ),
                      //       const SizedBox(height: 30),
                      //     ],
                      //   ),
                      // ),
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
                            const Text(
                              'Ingredients',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: meal.mealsData!.ingredients.map((entry) {
                                final ingredientList = meal.mealsData!.ingredients.toList();
                                final isLastEntry = entry == ingredientList[ingredientList.length - 1];


                                return IngredientItem(
                                  itemTitle: '\u25B8 $entry', // Unicode bullet point
                                  isLast: isLastEntry,
                                );
                              }).toList(),
                            )                      ],
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.all(10).copyWith(top: 20),
                      //   padding: const EdgeInsets.all(10),
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius:
                      //         BorderRadius.vertical(top: Radius.circular(10)),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       // Title
                      //       const Text(
                      //         "Nutrition Quality",
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 16,
                      //         ),
                      //       ),
                      //       Container(height: 26),
                      //
                      //       // Slider with an emoji indicator
                      //       Container(
                      //         height: 150,
                      //         child: Stack(
                      //           alignment: Alignment.center,
                      //           children: [
                      //             FlutterSlider(
                      //               values: [2],
                      //               max: 4,
                      //               min: 0,
                      //               step: const FlutterSliderStep(step: 1),
                      //               handler: FlutterSliderHandler(
                      //                 child: const Icon(
                      //                   Icons.circle,
                      //                   color: Colors.green,
                      //                   size: 20,
                      //                 ),
                      //               ),
                      //               trackBar: FlutterSliderTrackBar(
                      //                 activeTrackBarHeight: 4,
                      //                 activeTrackBar: const BoxDecoration(
                      //                     color: Colors.green),
                      //                 inactiveTrackBar: BoxDecoration(
                      //                     color: Colors.grey[300]),
                      //               ),
                      //               onDragging:
                      //                   (handlerIndex, upperValue, lowerValue) {
                      //                 // Handle dragging event if needed
                      //               },
                      //             ),
                      //             // Emoji Indicator
                      //             const Positioned(
                      //               top: 0,
                      //               left:
                      //                   80, // Adjust dynamically for positioning
                      //               child: Column(
                      //                 children: [
                      //                   CircleAvatar(
                      //                     backgroundColor: Colors.green,
                      //                     radius: 20,
                      //                     child: Text(
                      //                       "💪",
                      //                       style: TextStyle(fontSize: 20),
                      //                     ),
                      //                   ),
                      //                   // SizedBox(height: 4),
                      //                   // Text(
                      //                   //   "B",
                      //                   //   style: TextStyle(
                      //                   //     color: Colors.green,
                      //                   //     fontWeight: FontWeight.bold,
                      //                   //   ),
                      //                   // ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       const SizedBox(height: 6),
                      //
                      //       // Labels (A, B, C, D, E)
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: ["A", "B", "C", "D", "E"].map((label) {
                      //           return Text(
                      //             label,
                      //             style: TextStyle(
                      //               fontWeight: label == "B"
                      //                   ? FontWeight.bold
                      //                   : FontWeight.normal,
                      //               color: label == "B"
                      //                   ? Colors.green
                      //                   : Colors.grey,
                      //             ),
                      //           );
                      //         }).toList(),
                      //       ),
                      //
                      //       const SizedBox(height: 16),
                      //
                      //       // Description
                      //       const Text(
                      //         "Healthy if taken in moderation. Nutrient-packed. Contains trans fats, saturated fats, sugar etc.",
                      //         textAlign: TextAlign.left,
                      //         style: TextStyle(color: Colors.grey),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // IconButton(
              //   icon: const Icon(
              //     Icons.favorite,
              //     color: Colors.red,
              //     size: 30,
              //   ),
              //   onPressed: () {
              //     print(meal.mealsData!.ingredients);
              //   },
              // ),
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
                    var meall = meal.mealsData;
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => AddToCartModel(
                              productModel: Meal(
                                  mealId: meall!.mealId,
                                  name: meall.name,
                                  description: meall.description,
                                  price: meall.price,
                                  imageUrl: meall.imageUrl),
                            ));
                  },
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
      padding: const EdgeInsets.only(right: 10),
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
            fontSize: 12,
          ),
        ),
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        Text(grams, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// class NutritionChartPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;
//     final strokeWidth = 20.0;
//
//     // Background circle
//     final bgPaint = Paint()
//       ..color = Colors.grey[200]!
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth;
//
//     canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);
//
//     // Draw segments
//     final segments = [
//       Segment(0.46, Colors.purple, "46%"),
//       Segment(0.34, Colors.orange, "34%"),
//       Segment(0.20, Colors.green, "20%"),
//     ];
//
//     var startAngle = -math.pi / 2;
//     for (var segment in segments) {
//       final sweepAngle = 2 * math.pi * segment.value;
//       final paint = Paint()
//         ..color = segment.color
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = strokeWidth
//         ..strokeCap = StrokeCap.round;
//
//       // Draw the arc
//       canvas.drawArc(
//         Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
//         startAngle,
//         sweepAngle,
//         false,
//         paint,
//       );
//
//       // Calculate text position
//       final labelAngle = startAngle + sweepAngle / 2;
//       final labelRadius =
//           radius - strokeWidth * 1.2; // Adjust to position text inside
//       final labelOffset = Offset(
//         center.dx + labelRadius * math.cos(labelAngle),
//         center.dy + labelRadius * math.sin(labelAngle),
//       );
//
//       // Draw percentage text
//       final textSpan = TextSpan(
//         text: segment.label,
//         style: TextStyle(
//           color: segment.color,
//           fontSize: 14,
//           fontWeight: FontWeight.bold,
//         ),
//       );
//       final textPainter = TextPainter(
//         text: textSpan,
//         textDirection: TextDirection.ltr,
//       );
//       textPainter.layout();
//       textPainter.paint(
//         canvas,
//         labelOffset -
//             Offset(textPainter.width / 2,
//                 textPainter.height / 2), // Center the text
//       );
//
//       startAngle += sweepAngle;
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

class Segment {
  final double value;
  final Color color;
  final String label;

  Segment(this.value, this.color, this.label);
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
