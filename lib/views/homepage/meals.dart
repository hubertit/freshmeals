// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:freshmeals/constants/_assets.dart';
// import 'package:freshmeals/theme/colors.dart';
// import 'package:go_router/go_router.dart';
//
// class MealsPage extends ConsumerStatefulWidget {
//   const MealsPage({super.key});
//
//   @override
//   ConsumerState<MealsPage> createState() => _WelcomePageState();
// }
//
// class _WelcomePageState extends ConsumerState<MealsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: scaffold,
//         appBar: AppBar(
//             elevation: 0,
//             leadingWidth: 200,
//             backgroundColor: primarySwatch,
//             leading: Row(
//               children: [
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Container(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: Image.asset(
//                     AssetsUtils.logo,
//                     height: 35,
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               const SizedBox(
//                 width: 10,
//               ),
//               InkWell(
//                 onTap: () {
//                   // showSearch(
//                   //   context: context,
//                   //   delegate: OpportunitySearchDelegate(ref),
//                   // );
//                 },
//                 child: const CircleAvatar(
//                     radius: 18,
//                     backgroundColor: Color(0xff2E7D32),
//
//                     // backgroundColor:
//                     //     Theme.of(context).inputDecorationTheme.fillColor,
//                     child: Icon(
//                       Icons.search,
//                       color: Colors.white,
//                       size: 20,
//                     )),
//               ),
//               const SizedBox(
//                 width: 5,
//               ),
//               InkWell(
//                   onTap: () {
//                     context.push("/cart");
//                   },
//                   child: Container(
//                     // color: Theme.of(context).inputDecorationTheme.fillColor,
//                     // color: Color(0xffA5D6A7),
//                       height: 38,
//                       width: 47,
//                       child: Stack(
//                         children: [
//                           const Center(
//                             child: Icon(
//                               Ionicons.cart_outline,
//                               size: 25,
//                               color: Colors.white,
//                             ),
//                           ),
//                           Positioned(
//                               top: 0,
//                               right: 0,
//                               child: Container(
//                                 clipBehavior: Clip.antiAlias,
//                                 decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     shape: BoxShape.circle),
//                                 width: 15,
//                                 height: 15,
//                                 child: const Center(
//                                     child: Text("",
//                                       // user!.user == null
//                                       //     ? "0"
//                                       //     :cart!.cart==null?"0": "${cart.cart!.numItems}",
//                                       style: TextStyle(fontSize: 10),
//                                     )),
//                               )),
//                           const SizedBox(
//                             width: 10,
//                           )
//                         ],
//                         // centerTitle: true,
//                       ))),
//               const SizedBox(
//                 width: 15,
//               ),
//             ]
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               CarouselSlider.builder(
//                   itemCount: 3,
//                   itemBuilder: (context, index, id) => Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: AssetImage(
//                               AssetsUtils.banner)),
//                     ),
//                   ),
//                   options: CarouselOptions(
//                     aspectRatio: 16 / 9,
//                     enableInfiniteScroll: false,
//                     enlargeCenterPage: true,
//                     autoPlay: true, // Enable auto slide
//                     autoPlayInterval: const Duration(
//                         seconds: 3), // Slide transition every 3 seconds
//                     autoPlayAnimationDuration: const Duration(
//                         milliseconds: 500), // Half-second animation
//                     autoPlayCurve: Curves.easeInOut, // Smooth transition
//                   )),
//               // Container(
//               //   margin:
//               //   const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//               //   child: Column(
//               //     crossAxisAlignment: CrossAxisAlignment.start,
//               //     children: [
//               //       categories.isEmpty
//               //           ? const Center(child: CircularProgressIndicator())
//               //           : SingleChildScrollView(
//               //         scrollDirection: Axis.horizontal,
//               //         child: Row(
//               //           children:
//               //           List.generate(categories.length, (index) {
//               //             var category = categories[index];
//               //             return InkWell(
//               //               onTap: () {
//               //                 context.push("/category", extra: category);
//               //               },
//               //               child: Container(
//               //                 height: 100,
//               //                 width: 100,
//               //                 margin: const EdgeInsets.only(right: 10),
//               //                 padding: const EdgeInsets.symmetric(
//               //                     vertical: 10, horizontal: 10),
//               //                 decoration: BoxDecoration(
//               //                   color: Colors.white,
//               //                   borderRadius: BorderRadius.circular(5),
//               //                 ),
//               //                 child: Column(
//               //                   children: [
//               //                     Expanded(
//               //                         child: Image.network(
//               //                             category.categoryImage)),
//               //                     Text(
//               //                       trimm(11, category.categoryName),
//               //                       style: const TextStyle(fontSize: 12),
//               //                     )
//               //                   ],
//               //                 ),
//               //               ),
//               //             );
//               //           }),
//               //         ),
//               //       ),
//               //       const SizedBox(
//               //         height: 10,
//               //       ),
//               //       Container(
//               //         padding: const EdgeInsets.symmetric(vertical: 10),
//               //         child: const Text(
//               //           "New Arrivals",
//               //           style: TextStyle(
//               //               fontWeight: FontWeight.bold, fontSize: 16),
//               //         ),
//               //       ),
//               //       newArrivals.isLoading
//               //           ? const Center(child: CircularProgressIndicator())
//               //           : GridView.builder(
//               //         physics: const NeverScrollableScrollPhysics(),
//               //         shrinkWrap: true,
//               //         gridDelegate:
//               //         const SliverGridDelegateWithFixedCrossAxisCount(
//               //           crossAxisCount: 3,
//               //           crossAxisSpacing: 10,
//               //           mainAxisSpacing: 10,
//               //           mainAxisExtent:
//               //           150.0, // Specify the height you want for each item
//               //         ),
//               //         itemCount: specialProducts.products.length,
//               //         itemBuilder: (context, index) {
//               //           ProductModel newArrival =
//               //           newArrivals.products[index];
//               //           return ProductGridCard(product: newArrival);
//               //         },
//               //       ),
//               //       Container(
//               //         padding: const EdgeInsets.symmetric(vertical: 10),
//               //         child: const Text(
//               //           "Specials",
//               //           style: TextStyle(
//               //               fontWeight: FontWeight.bold, fontSize: 16),
//               //         ),
//               //       ),
//               //       newArrivals.isLoading
//               //           ? const Center(child: CircularProgressIndicator())
//               //           : GridView.builder(
//               //         physics: const NeverScrollableScrollPhysics(),
//               //         shrinkWrap: true,
//               //         gridDelegate:
//               //         const SliverGridDelegateWithFixedCrossAxisCount(
//               //           crossAxisCount: 3,
//               //           crossAxisSpacing: 10,
//               //           mainAxisSpacing: 10,
//               //           mainAxisExtent:
//               //           150.0, // Specify the height you want for each item
//               //         ),
//               //         itemCount: specialProducts.products.length,
//               //         itemBuilder: (context, index) {
//               //           ProductModel specials =
//               //           specialProducts.products[index];
//               //           return ProductGridCard(product: specials);
//               //         },
//               //       ),
//               //       Container(
//               //         padding: const EdgeInsets.symmetric(vertical: 10),
//               //         child: const Text(
//               //           "Best selling",
//               //           style: TextStyle(
//               //               fontWeight: FontWeight.bold, fontSize: 16),
//               //         ),
//               //       ),
//               //       newArrivals.isLoading
//               //           ? const Center(child: CircularProgressIndicator())
//               //           : GridView.builder(
//               //         physics: const NeverScrollableScrollPhysics(),
//               //         shrinkWrap: true,
//               //         gridDelegate:
//               //         const SliverGridDelegateWithFixedCrossAxisCount(
//               //           crossAxisCount: 3,
//               //           crossAxisSpacing: 10,
//               //           mainAxisSpacing: 10,
//               //           mainAxisExtent:
//               //           150.0, // Specify the height you want for each item
//               //         ),
//               //         itemCount: bestSellingProducts.products.length,
//               //         itemBuilder: (context, index) {
//               //           ProductModel bestSeller =
//               //           bestSellingProducts.products[index];
//               //           return ProductGridCard(product: bestSeller);
//               //         },
//               //       )
//               //     ],
//               //   ),
//               // ),
//             ],
//           ),
//         ));
//   }
// }
//
// String trimm(int value, String text) {
//   if (text.length > value) {
//     return "${text.substring(0, value - 2)}..";
//   }
//   return text;
// }
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';

import '../../constants/_assets.dart';

class MealsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Find something...",
                  suffixIcon: Container(
                      margin: EdgeInsets.all(6),
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip(
                        "Breakfast", Colors.purple, MaterialCommunityIcons.cup,
                        () {
                      context.push('/lunch');
                    }),
                    _buildCategoryChip(
                        "Lunch", Colors.blue, MaterialCommunityIcons.food, () {
                      context.push('/lunch');
                    }),
                    _buildCategoryChip("Dinner", Colors.green,
                        MaterialCommunityIcons.fruit_grapes, () {
                      context.push('/lunch');
                    }),
                    _buildCategoryChip("Snacks", Colors.orange,
                        MaterialCommunityIcons.bread_slice, () {
                      context.push('/lunch');
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider.builder(
                  itemCount: 3,
                  itemBuilder: (context, index, id) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: const DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(AssetsUtils.banner)),
                        ),
                      ),
                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    autoPlay: true, // Enable auto slide
                    autoPlayInterval: const Duration(
                        seconds: 3), // Slide transition every 3 seconds
                    autoPlayAnimationDuration: const Duration(
                        milliseconds: 500), // Half-second animation
                    autoPlayCurve: Curves.easeInOut, // Smooth transition
                  )),
              _buildSection("Take Your Pick", [
                _buildMealCard("Fresh Salad Thai", "10 mins • 268 kcal",
                  AssetsUtils.salad,
                ),
                _buildMealCard("Fresh Salad Thai", "10 mins • 268 kcal",
                  AssetsUtils.salad,
                ),
              ]),
              const SizedBox(height: 16),
              _buildMealSection("Breakfast",
                  "Start your day with wholesome and nutritious meals", [
                _buildMealCard("Walnut and Nuts", "10 mins • 267 kcal",
                  AssetsUtils.nuts,
                ),
                _buildMealCard("Chocolate", "10 mins • 267 kcal",
                  AssetsUtils.breakfast,
                ),
              ]),
              const SizedBox(height: 16),
              _buildMealSection(
                  "Snack", "Midday snacks to keep your energy levels high", [
                _buildMealCard("Circle Cake", "10 mins • 227 kcal",
                  AssetsUtils.snack,
                ),
                _buildMealCard("Honey Muffins", "10 mins • 227 kcal",
                  AssetsUtils.nuts,
                ),
              ]),
              const SizedBox(height: 16),
              _buildMealSection(
                  "Lunch", "Fuel your afternoon with hearty, balanced meals", [
                _buildMealCard("Salmon Tomato Sauce", "10 mins • 267 kcal",
                  AssetsUtils.breakfast,
                ),
                _buildMealCard("Mushroom Pasta", "10 mins • 267 kcal",
                  AssetsUtils.pasta,
                ),
              ]),
              const SizedBox(height: 16),
              _buildMealSection(
                  "Dinner",
                  "End your day with a healthy, delicious, and satisfying meal",
                  [
                    _buildMealCard("Fresh Salad Pasta", "10 mins • 267 kcal",
                      AssetsUtils.dinner,
                    ),
                    _buildMealCard("Japanese Curry", "10 mins • 267 kcal",
                      AssetsUtils.snack,
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
      String label, Color color, IconData icon, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 13),
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
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("View All", style: TextStyle(color: Colors.green)),
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

  Widget _buildMealSection(String title, String subtitle, List<Widget> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("View All", style: TextStyle(color: Colors.green)),
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

  Widget _buildMealCard(String title, String subtitle, String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(imagePath,
                  height: 100, width: 150, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(subtitle,
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
