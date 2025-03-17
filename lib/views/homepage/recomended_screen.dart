import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/utls/styles.dart';
import 'package:go_router/go_router.dart';

import '../../models/home/meal_model.dart';
import '../../riverpod/providers/auth_providers.dart';
import '../../riverpod/providers/home.dart';
import '../../utls/callbacks.dart';
import '../appointment/widgets/empty_widget.dart';
import 'widgets/add_to_cart.dart';

class RecommendedScreen extends ConsumerStatefulWidget {
  const RecommendedScreen({super.key});

  @override
  ConsumerState<RecommendedScreen> createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends ConsumerState<RecommendedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.watch(userProvider)!.user;
      ref
          .read(recommendedMealsProvider.notifier)
          .fetchInstantRecommended(context, user!.token);
      ref
          .read(recommendedMealsProvider.notifier)
          .fetchNonInstantRecommended(context, user!.token);
    });

    _tabController = TabController(
        length: 2, vsync: this); // 3 tabs: All, Instant, Non-Instant
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var meals = ref.watch(recommendedMealsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Recommended",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.green,
          tabs: const [
            // Tab(text: "All"),
            Tab(text: "Instant"),
            Tab(text: "Non-Instant"),
          ],
        ),
      ),
      body: meals!.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                // _buildMealsList(meals.recomendations), // All Meals
                _buildMealsList(
                    meals.instantRecommendations, false), // Instant Meals
                _buildMealsList(meals.nonInstantRecommendations, true
                    // .where((meal) => !meal.isInstant)
                    // .toList()
                    ), // Non-Instant Meals
              ],
            ),
    );
  }

  Widget _buildMealsList(List<Meal> meals, bool nonInstant) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 10),
      child: meals.isEmpty
          ? const Column(
              children: [
                SizedBox(height: 200),
                CustomEmptyWidget(message: "There are no recommended meals")
              ],
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  if (nonInstant)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      // margin:
                      // const EdgeInsets.only(left: 16, right: 16, top: 10),
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
                  if (nonInstant)
                    const SizedBox(
                      height: 10,
                    ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      var meal = meals[index];
                      return _buildMealCard(context: context, meal: meal);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMealCard({required BuildContext context, required Meal meal}) {
    return InkWell(
      onTap: () => context.push('/mealDetails/${meal.mealId}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
                          ),
                        ),
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
