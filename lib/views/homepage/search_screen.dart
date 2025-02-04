import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:freshmeals/utls/callbacks.dart';
import 'package:go_router/go_router.dart';

import '../../models/home/meal_model.dart';
import '../../theme/colors.dart';
import '../../utls/styles.dart';
import 'search_delegate.dart';
import 'widgets/add_to_cart.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(randomMealsProvider.notifier).fetchMeals(context);

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var meals = ref.watch(randomMealsProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          readOnly: true,
          onTap: (){
            showSearch(
              context: context,
              delegate: OpportunitySearchDelegate(ref),
            );
          },
          decoration: InputDecoration(
            hintText: "Find something...",

            suffixIcon: Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: primarySwatch,
                ),
                child: const Icon(Icons.search, color: Colors.white)),
            filled: true,
            fillColor: Colors.transparent,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),

          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 15),
          //   color: Colors.white,
          //   child: Column(
          //     children: [
          //       const Row(
          //         children: [
          //           Text(
          //             "History",
          //             style: TextStyle(fontWeight: FontWeight.bold),
          //           ),
          //           Spacer(),
          //           Text("clear")
          //         ],
          //       ),
          //       Container(
          //         margin: EdgeInsets.only(top: 10),
          //         padding: EdgeInsets.only(bottom: 3),
          //         decoration: BoxDecoration(
          //             border: Border(
          //           bottom: BorderSide(
          //             color: Colors.grey.shade100, // Choose your desired color
          //             width: 1.0, // Set the desired width
          //           ),
          //         )),
          //         child: const Row(
          //           children: [
          //             Text(
          //               "Eggs",
          //               style: TextStyle(
          //                   color: Colors.grey, fontWeight: FontWeight.bold),
          //             ),
          //             Spacer(),
          //             Icon(
          //               Icons.close,
          //               color: Colors.grey,
          //               size: 15,
          //             )
          //           ],
          //         ),
          //       ),
          //       Container(
          //         margin: EdgeInsets.only(top: 10),
          //         padding: EdgeInsets.only(bottom: 3),
          //         decoration: BoxDecoration(
          //             border: Border(
          //           bottom: BorderSide(
          //             color: Colors.grey.shade100, // Choose your desired color
          //             width: 1.0, // Set the desired width
          //           ),
          //         )),
          //         child: const Row(
          //           children: [
          //             Text(
          //               "Apple",
          //               style: TextStyle(
          //                   color: Colors.grey, fontWeight: FontWeight.bold),
          //             ),
          //             Spacer(),
          //             Icon(
          //               Icons.close,
          //               color: Colors.grey,
          //               size: 15,
          //             )
          //           ],
          //         ),
          //       ),
          //       Container(
          //         margin: const EdgeInsets.only(top: 10),
          //         padding: const EdgeInsets.only(bottom: 3),
          //         child: const Row(
          //           children: [
          //             Text(
          //               "Banana",
          //               style: TextStyle(
          //                   color: Colors.grey, fontWeight: FontWeight.bold),
          //             ),
          //             Spacer(),
          //             Icon(
          //               Icons.close,
          //               color: Colors.grey,
          //               size: 15,
          //             )
          //           ],
          //         ),
          //       ),
          //       const Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           Text("Show More", style: TextStyle(color: Colors.green)),
          //         ],
          //       ),
          //
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 0),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             _buildCategoryTab("For You", isSelected: true),
          //             _buildCategoryTab("Popular"),
          //             _buildCategoryTab("Cheapest"),
          //             _buildCategoryTab("Discount"),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: meals!.isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: meals.mealCategories.length,
                        itemBuilder: (context, index) {
                          var meal = meals.mealCategories[index];
                          return _buildMealCard(context: context, meal: meal);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
            color: isSelected ? primarySwatch : Colors.grey,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 40,
            color: primarySwatch,
          ),
      ],
    );
  }
  Widget _buildMealCard({required BuildContext context, required Meal meal
    // bool isSale = false,
    // String? saleText,
  }) {
    return InkWell(
      onTap: () => context.push('/mealDetails/${meal.mealId}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.2),
          //     blurRadius: 6,
          //     offset: Offset(0, 3),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(7)),
                    child: Image.network(
                      meal.imageUrl,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.favorite_border, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trimm(17, meal.name),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  // const SizedBox(height: 4),
                  const Text(
                    "For lunch",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "RWF ${formatMoney(meal.price)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => AddToCartModel(
                                    productModel: meal,
                                  ));
                            },
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 20,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
