import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/home/meal_model.dart';
import '../../riverpod/providers/auth_providers.dart';
import '../../riverpod/providers/home.dart';
import '../../utls/callbacks.dart';
import '../appointment/widgets/empty_widget.dart';
import 'widgets/add_to_cart.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.watch(userProvider);
      if (user!.user != null) {
        await ref
            .read(favoritesProvider.notifier)
            .fetchFavorites(context, user.user!.token);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var meals = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Favorites',
        ),
        centerTitle: false,
      ),
      body: meals!.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : meals.favoriteMeals!.isEmpty
              ? const Column(
                  children: [
                    SizedBox(
                      height: 200,
                    ),
                    CustomEmptyWidget(message: "You have no favorite meals.")
                  ],
                )
              : Column(
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
                          itemCount: meals.favoriteMeals!.length,
                          itemBuilder: (context, index) {
                            var meal = meals.favoriteMeals![index];
                            return _buildMealCard(context: context, meal: meal);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).removeFavorite(
                              context,
                              ref.watch(userProvider)!.user!.token,
                              int.parse(meal.mealId));
                        },
                        icon: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.favorite, color: Colors.red),
                        )),
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
                    meal.name,
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
