import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/meal_model.dart';
import 'package:freshmeals/utls/styles.dart';
import 'package:go_router/go_router.dart';
import '../../riverpod/providers/home.dart';
import '../../theme/colors.dart';
import '../../utls/callbacks.dart';

class OpportunitySearchDelegate extends SearchDelegate<Meal?> {
  final WidgetRef ref;

  OpportunitySearchDelegate(this.ref) {
    _initialize();
  }

  List<Meal> _jobs = [];
  bool _loading = true;

  void _initialize() async {
    final jobNotifier = ref.read(searchedProductsProvider.notifier);
    _jobs =
        (await jobNotifier.searchProducts(query))!; // Fetch all jobs initially
    _loading = false;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      query.isEmpty
          ? IconButton(
              icon: const Icon(Icons.mic),
              onPressed: () {
                // Implement voice search if needed
              },
            )
          : IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildJobList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildJobList();
  }

  Widget _buildJobList() {
    final jobNotifier = ref.read(searchedProductsProvider.notifier);

    return FutureBuilder<List<Meal>>(
      future: query.isEmpty
          ? jobNotifier.searchProducts('')
          : jobNotifier.searchProducts(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || _loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found'));
        }

        final jobs = snapshot.data!;
        return Container(
          color: scaffold,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        var meal = jobs[index];
                        return buildMealCard(
                          context: context,
                          meal: meal,
                          isSale: index == 4,
                          saleText: "SALE 12%",
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget buildMealCard({
  required BuildContext context,
  required Meal meal,
  bool isSale = false,
  String? saleText,
}) {
  return InkWell(
    onTap: () => context.push("/mealDetails/:${meal.mealId}"),
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
                if (isSale)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        saleText!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                      "Rwf ${formatMoney(meal.price)}",
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
                            context.push("/mealDetails/:${meal.mealId}");
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
