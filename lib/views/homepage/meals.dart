import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:freshmeals/utls/callbacks.dart';
import 'package:freshmeals/utls/styles.dart';
import 'package:go_router/go_router.dart';

import '../../constants/_assets.dart';
import '../../riverpod/providers/home.dart';
import 'search_delegate.dart';

class MealsPage extends ConsumerStatefulWidget {
  const MealsPage({super.key});

  @override
  ConsumerState<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends ConsumerState<MealsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(mealCategoriesProvider.notifier).mealCategories(context);
      ref.read(mealTypesProvider.notifier).mealTypes(context);
      ref.read(homeMealsDataProvider.notifier).fetchMeals(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var categories = ref.watch(mealCategoriesProvider);
    var types = ref.watch(mealTypesProvider);
    var mealsHome = ref.watch(homeMealsDataProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              TextField(
                readOnly: true,
                onTap: () {
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
              const SizedBox(height: 10),
              if (types!.mealCategories.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children:
                          List.generate(types.mealCategories.length, (index) {
                    var mealType = types.mealCategories[index];
                    return _buildCategoryChip(mealType.name, mealType.imageUrl,
                        () {
                      context.push('/lunch/${mealType.name}');
                    });
                  })),
                ),
            ],
          ),
        ),
      ),
      body: mealsHome!.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CarouselSlider.builder(
                    //     itemCount: categories!.mealCategories.length,
                    //     itemBuilder: (context, index, id) => Container(
                    //           decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(10.0),
                    //               image: const DecorationImage(
                    //                   fit: BoxFit.fill,
                    //                   image:
                    //                       AssetImage(AssetsUtils.banner),
                    //                       // NetworkImage(categories
                    //                       //     .mealCategories[index]
                    //                       //     .imageUrl)
                    //               )),
                    //         ),
                    //     options: CarouselOptions(
                    //       aspectRatio: 16 / 10,
                    //       enableInfiniteScroll: false,
                    //       enlargeCenterPage: true,
                    //       autoPlay: false, // Enable auto slide
                    //       autoPlayInterval: const Duration(
                    //           seconds: 3), // Slide transition every 3 seconds
                    //       autoPlayAnimationDuration: const Duration(
                    //           milliseconds: 500), // Half-second animation
                    //       autoPlayCurve: Curves.easeInOut, // Smooth transition
                    //     )),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image:  DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(mealsHome.mealsData!.featured.imageUrl),
                            // NetworkImage(categories
                            //     .mealCategories[index]
                            //     .imageUrl)
                          )),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildSection(
                        "Take Your Pick",
                        List.generate(
                          mealsHome.mealsData!.yourPick.length,
                          (index) {
                            var pick = mealsHome.mealsData!.yourPick[index];
                            return InkWell(
                              onTap: () =>
                                  context.push("/mealDetails/${pick.mealId}"),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Container(
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: const [],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(10)),
                                        child: Image.network(pick.imageUrl,
                                            fit: BoxFit.cover),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(formatStringDigits(pick.name),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14)),
                                            const SizedBox(height: 5),
                                            Text(
                                                "${formatMoney(pick.price)} Rwf ",
                                                style: const TextStyle(
                                                    color: primarySwatch,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                    const SizedBox(height: 16),
                    _buildMealSection(
                      "Breakfast",
                      "Start your day with wholesome and nutritious meals",
                      List.generate(mealsHome.mealsData!.breakfast.length,
                          (index) {
                        var breakF = mealsHome.mealsData!.breakfast[index];

                        return _buildMealCard(
                            breakF.name,
                            breakF.price,
                            breakF.imageUrl,
                            () =>
                                context.push("/mealDetails/${breakF.mealId}"));
                      }),
                    ),
                    const SizedBox(height: 16),
                    _buildMealSection(
                        "Snack",
                        "Midday snacks to keep your energy levels high",
                        List.generate(mealsHome.mealsData!.dinner.length,
                            (index) {
                          var breakF = mealsHome.mealsData!.dinner[index];

                          return _buildMealCard(
                              breakF.name,
                              breakF.price,
                              breakF.imageUrl,
                              () => context
                                  .push("/mealDetails/${breakF.mealId}"));
                        })),
                    const SizedBox(height: 16),
                    _buildMealSection(
                        "Lunch",
                        "Fuel your afternoon with hearty, balanced meals",
                        List.generate(mealsHome.mealsData!.lunch.length,
                            (index) {
                          var lunch = mealsHome.mealsData!.lunch[index];

                          return _buildMealCard(
                              lunch.name,
                              lunch.price,
                              lunch.imageUrl,
                              () =>
                                  context.push("/mealDetails/${lunch.mealId}"));
                        })),
                    const SizedBox(height: 16),
                    _buildMealSection(
                        "Dinner",
                        "End your day with a healthy, delicious, and satisfying meal",
                        List.generate(mealsHome.mealsData!.dinner.length,
                            (index) {
                          var dinner = mealsHome.mealsData!.dinner[index];

                          return _buildMealCard(
                              dinner.name,
                              dinner.price,
                              dinner.imageUrl,
                              () => context
                                  .push("/mealDetails/${dinner.mealId}"));
                        })),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCategoryChip(
      String label, String image, void Function()? onTap) {
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
              height: 15,
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

  Widget _buildSection(String title, List<Widget> cards) {
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
                  context.push("/lunch/${title}");
                },
                child: const Text("View All",
                    style: TextStyle(color: Colors.green))),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: cards),
        ),
      ],
    );
  }

  Widget _buildMealSection(
    String title,
    String subtitle,
    List<Widget> cards,
  ) {
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
                  context.push("/lunch/${title}");
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
        width: MediaQuery.of(context).size.width/1.7,
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(imagePath, fit: BoxFit.cover,
                  width: double.infinity, // Makes the image fill the container width
                  height: 200, // Set a fixed height to ensure uniformity
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(trimm(25, title),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                    const SizedBox(height: 5),
                    Text(
                        "${formatMoney(price)} Rwf ",
                        style: const TextStyle(
                            color: primarySwatch,
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
