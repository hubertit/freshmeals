import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/utls/styles.dart';
import 'package:go_router/go_router.dart';

import '../../models/home/meal_model.dart';
import '../../riverpod/providers/auth_providers.dart';
import '../../riverpod/providers/general.dart';
import '../../riverpod/providers/home.dart';
import '../../theme/colors.dart';
import '../../utls/callbacks.dart';
import '../appointment/widgets/empty_widget.dart';
import 'widgets/add_to_cart.dart';

class NonInstantMealsScreen extends ConsumerStatefulWidget {
  const NonInstantMealsScreen({super.key});

  @override
  ConsumerState<NonInstantMealsScreen> createState() => _LunchPageState();
}

class _LunchPageState extends ConsumerState<NonInstantMealsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = ref.read(userProvider);
      if (user != null) {
        ref
            .read(preOrderMealsProvider.notifier)
            .fetchPreOrderMeals(context, user.user!.token);
        ref
            .read(mealTypesProviderNI.notifier)
            .mealTypes(context, 'non-instant');
        ref
            .read(preOrderMealsProvider.notifier)
            .fetchBreakfastMeals(context, user.user!.token);
        ref
            .read(preOrderMealsProvider.notifier)
            .fetchDessertMeals(context, user.user!.token);
        ref
            .read(preOrderMealsProvider.notifier)
            .fetchLunchDinnerMeals(context, user.user!.token,);
        ref
            .read(preOrderMealsProvider.notifier)
            .fetchSnackMeals(context, user.user!.token);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var meals = ref.watch(preOrderMealsProvider);
    var types = ref.watch(mealTypesProviderNI);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 90,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              const Text("Non-Instant Meals"),
              const SizedBox(
                height: 10,
              ),
              if (types!.mealCategories.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children:
                          List.generate(types.mealCategories.length, (index) {
                    var mealType = types.mealCategories[index];
                    return _buildCategoryChip(mealType.name, mealType.imageUrl,
                        () {
                      context.push(
                          '/lunch/${mealType.typeId}/${Uri.encodeComponent(mealType.name)}');
                    });
                  })),
                ),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      body: meals!.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : meals.preOrderMeals.isEmpty
              ? const Column(
                  children: [
                    SizedBox(
                      height: 200,
                    ),
                    CustomEmptyWidget(
                        message: "There are no items in this category")
                  ],
                )
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       _buildCategoryTab("All", isSelected: true),
                        //       _buildCategoryTab("For You"),
                        //       _buildCategoryTab("Recommended"),
                        //     ],
                        //   ),
                        // ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          margin:
                              const EdgeInsets.only( top: 10),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: const Color(0xff0d1e7dd),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: const Color(0xffbadbcc))),
                          child: const Text.rich(
                            // textAlign: TextAlign.center,
                            // These meals take a   long time to prepare. Kindly make your order at least 24 hours in advance
                            TextSpan(
                              text:
                                  "These meals take a long time to prepare. Kindly make your order at least",
                              style: TextStyle(
                                fontSize: 14,
                                // color: Color(0xf0f5132),
                                // fontWeight: FontWeight.bold
                              ),
                              children: [
                                TextSpan(
                                  text: " 24 hours ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green, // Highlight balance
                                  ),
                                ),
                                TextSpan(
                                  text: "in advance.",
                                ),
                              ],
                            ),
                          ),
                        ),

                        // const SizedBox(height: 16),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: GridView.builder(
                        //     shrinkWrap: true,
                        //     physics: const NeverScrollableScrollPhysics(),
                        //     gridDelegate:
                        //         const SliverGridDelegateWithFixedCrossAxisCount(
                        //       crossAxisCount: 2,
                        //       mainAxisSpacing: 16,
                        //       crossAxisSpacing: 16,
                        //       childAspectRatio: 0.8,
                        //     ),
                        //     itemCount: meals.preOrderMeals.length,
                        //     itemBuilder: (context, index) {
                        //       var meal = meals.preOrderMeals[index];
                        //       return _buildMealCard(context: context, meal: meal);
                        //     },
                        //   ),
                        // ),
                        if(meals.breakfast.isNotEmpty) _buildMealSection(
                            "Breakfast",
                            "Start your day with wholesome and nutritious meals",
                            List.generate(meals.breakfast.length,
                                    (index) {
                                  var breakF = meals.breakfast[index];

                                  return _buildMealCard(
                                      breakF.name,
                                      breakF.price,
                                      breakF.imageUrl,
                                          () => context
                                          .push("/mealDetails/${breakF.mealId}"));
                                }),
                            "1"),

                        const SizedBox(height: 16),
                        if(meals.lunchDinner.isNotEmpty)_buildMealSection(
                            "Lunch/Dinner",
                            "Fuel your afternoon with hearty, balanced meals",
                            List.generate(meals.lunchDinner.length,
                                    (index) {
                                  var lunch = meals.lunchDinner[index];

                                  return _buildMealCard(
                                      lunch.name,
                                      lunch.price,
                                      lunch.imageUrl,
                                          () =>
                                          context.push("/mealDetails/${lunch.mealId}"));
                                }),
                            "2"),
                        const SizedBox(height: 16),
                        if(meals.dessert.isNotEmpty) _buildMealSection(
                            "Desert",
                            "End your day with a healthy, delicious, and satisfying meal",
                            List.generate(meals.dessert.length,
                                    (index) {
                                  var dinner = meals.dessert[index];

                                  return _buildMealCard(
                                      dinner.name,
                                      dinner.price,
                                      dinner.imageUrl,
                                          () => context
                                          .push("/mealDetails/${dinner.mealId}"));
                                }),
                            "3"),
                        const SizedBox(height: 16),
                        if(meals.snacks.isNotEmpty)_buildMealSection(
                            "Snack",
                            "Midday snacks to keep your energy levels high",
                            List.generate(meals.snacks.length,
                                    (index) {
                                  var breakF = meals.snacks[index];

                                  return _buildMealCard(
                                      breakF.name,
                                      breakF.price,
                                      breakF.imageUrl,
                                          () => context
                                          .push("/mealDetails/${breakF.mealId}"));
                                }),
                            "4"),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildCategoryTab(String text, {bool isSelected = false}) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.grey,
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

  Widget _buildMealSection(
      String title, String subtitle, List<Widget> cards, String typeId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            InkWell(
                onTap: () {
                  // context.push("/lunch/${title}");
                  context
                      .push('/lunch/${typeId}/${Uri.encodeComponent(title)}');

                  // context.push(
                  //     "/lunch/extra: {'typeId': , 'title': ${title}}");
                },
                child: const Text("View All",
                    style: TextStyle(color: Colors.green))),
          ],
        ),
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: cards),
        ),
      ],
    );
  }
  Widget _buildMealCard(
      String title, String price, String imagePath, void Function()? onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        // height: 220,
        width: MediaQuery.of(context).size.width / 1.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [],
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  imagePath, fit: BoxFit.cover,
                  width: double
                      .infinity, // Makes the image fill the container width
                  height: 200, // Set a fixed height to ensure uniformity
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trimm(25, title),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(height: 5),
                    Text("${formatMoney(price)} Rwf ",
                        style: const TextStyle(
                            color: primarySwatch,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Widget _buildMealCard({required BuildContext context, required Meal meal
  //     // bool isSale = false,
  //     // String? saleText,
  //     }) {
  //   return InkWell(
  //     onTap: () => context.push('/mealDetails/${meal.mealId}'),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12),
  //         // boxShadow: [
  //         //   BoxShadow(
  //         //     color: Colors.grey.withOpacity(0.2),
  //         //     blurRadius: 6,
  //         //     offset: Offset(0, 3),
  //         //   ),
  //         // ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Expanded(
  //             child: Stack(
  //               children: [
  //                 ClipRRect(
  //                   borderRadius:
  //                       const BorderRadius.vertical(top: Radius.circular(7)),
  //                   child: Image.network(
  //                     meal.imageUrl,
  //                     height: 130,
  //                     width: double.infinity,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //                 const Positioned(
  //                   top: 8,
  //                   right: 8,
  //                   child: Icon(Icons.favorite_border, color: Colors.grey),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   trimm(17, meal.name),
  //                   style: const TextStyle(
  //                       fontWeight: FontWeight.bold, fontSize: 16),
  //                 ),
  //                 // const SizedBox(height: 4),
  //                 // Text(
  //                 //   "For ${widget.title}",
  //                 //   style: const TextStyle(color: Colors.grey, fontSize: 12),
  //                 // ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "RWF ${formatMoney(meal.price)}",
  //                       style: const TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.green,
  //                       ),
  //                     ),
  //                     Container(
  //                       padding: const EdgeInsets.all(5),
  //                       decoration: BoxDecoration(
  //                         color: Colors.green,
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                       child: InkWell(
  //                           onTap: () {
  //                             showModalBottomSheet(
  //                                 context: context,
  //                                 builder: (context) => AddToCartModel(
  //                                       productModel: meal,
  //                                     ));
  //                           },
  //                           child: const Icon(
  //                             Icons.add_shopping_cart,
  //                             color: Colors.white,
  //                             size: 20,
  //                           )),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 8),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

Widget _buildCategoryChip(String label, String image, void Function()? onTap) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    margin: const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      color: scaffold,
      borderRadius: BorderRadius.circular(5),
    ),
    child: InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.network(
            image,
            height: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    ),
  );
}
