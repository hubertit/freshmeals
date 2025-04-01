import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/nutritionist.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';

import '../../riverpod/providers/home.dart';
import '../../theme/colors.dart';

class NutritionDetails extends ConsumerStatefulWidget {
  final Nutritionist nutritionist;
  const NutritionDetails({super.key, required this.nutritionist});

  @override
  ConsumerState<NutritionDetails> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<NutritionDetails> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(availabilityProvider.notifier).fetchAvailability(
         ref.watch(userProvider)!.user!.token,
        widget.nutritionist.userId,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.nutritionist.userId);
    var availability = ref.watch(availabilityProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image with Buttons
            Stack(
              children: [
                Image.network(
                  widget.nutritionist.profilePicture, // Add your image path
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
                          widget.nutritionist!.name,
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
                      // Text(
                      //   widget.nutritionist.availability?"Available":"Not available",
                      //   style: const TextStyle(
                      //       color: primarySwatch,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 16),
                      // ),
                      // const SizedBox(height: 10),
                      Text(
                        widget.nutritionist.email,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),

                    ],
                  ),
                ),


                Container(
                  margin: const EdgeInsets.all(10).copyWith(top: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    // boxShadow: const [
                    //   BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
                    // ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(availability.slots.isNotEmpty)const Text(
                        'Availability',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      availability.slots.isEmpty
                          ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No available slots!!',
                            style: TextStyle( fontSize: 16),
                          ),
                        ),
                      )
                          : Column(
                        children: availability.slots.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date header
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '📅 ${entry.key}', // Date heading
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Time slots
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: entry.value.map((slot) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 18, color: Colors.blueGrey),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${slot["start_time"]} - ${slot["end_time"]}',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                            ],
                          );
                        }).toList(),
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
                    // var meall = meal.mealsData;
                    // showModalBottomSheet(
                    //     context: context,
                    //     builder: (context) => AddToCartModel(
                    //       productModel: Meal(
                    //           mealId: meall!.mealId,
                    //           name: meall.name,
                    //           description: meall.description,
                    //           price: meall.price,
                    //           imageUrl: meall.imageUrl),
                    //     ));
                  },
                  child: const Text(
                    "Book Appointment",
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
