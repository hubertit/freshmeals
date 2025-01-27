// import 'package:flutter/material.dart';
// import 'package:freshmeals/theme/colors.dart';
//
// import '../../constants/_assets.dart';
// import '../../models/general/calendar.dart';
//
// class NutritionistBookingScreen extends StatefulWidget {
//   const NutritionistBookingScreen({super.key});
//
//   @override
//   State<NutritionistBookingScreen> createState() =>
//       _NutritionistBookingScreenState();
// }
//
// class _NutritionistBookingScreenState extends State<NutritionistBookingScreen> {
//   List<CalendarDay> calendar =
//       (calenderDatas as Iterable).map((e) => CalendarDay.fromJson(e)).toList();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Greeting Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Hello, Aristide 👋",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         "How are you today?",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         backgroundColor: Colors.white,
//                         child: IconButton(
//                           onPressed: () {},
//                           icon: const Icon(Icons.search),
//                         ),
//                       ),
//                       SizedBox(width: 5),
//                       CircleAvatar(
//                         backgroundColor: Colors.white,
//                         child: IconButton(
//                           onPressed: () {},
//                           icon: Icon(Icons.notifications_outlined),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               // Categories Section
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     _buildCategoryItem("General", Icons.health_and_safety),
//                     _buildCategoryItem("Weight Loss", Icons.scale),
//                     _buildCategoryItem("Sports", Icons.fitness_center),
//                     _buildCategoryItem("Diet Plans", Icons.restaurant_menu),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               // Top Nutritionists Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Top Nutritionists",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {},
//                     child: const Text("See All"),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               // Nutritionist Cards
//               Expanded(
//                 child: ListView(
//                   children: [
//                     _buildNutritionistCard(
//                       name: "Dr. Sarah Johnson",
//                       specialty: "Dietitian",
//                       price: "\$80/session",
//                       rating: 4.9,
//                       availableSlots: "8 slots",
//                       imagePath: "assets/nutritionist1.jpg",
//                     ),
//                     _buildNutritionistCard(
//                       name: "Dr. Michael Smith",
//                       specialty: "Sports Nutritionist",
//                       price: "\$90/session",
//                       rating: 4.8,
//                       availableSlots: "6 slots",
//                       imagePath: "assets/nutritionist2.jpg",
//                     ),
//                     _buildNutritionistCard(
//                       name: "Dr. Sarah Johnson",
//                       specialty: "Dietitian",
//                       price: "\$80/session",
//                       rating: 4.9,
//                       availableSlots: "8 slots",
//                       imagePath: "assets/nutritionist1.jpg",
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCategoryItem(String title, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 16.0),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: Colors.white,
//             child: Icon(icon, size: 30, color: Colors.black),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNutritionistCard({
//     required String name,
//     required String specialty,
//     required String price,
//     required double rating,
//     required String availableSlots,
//     required String imagePath,
//   }) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 40,
//                   backgroundImage: const AssetImage(AssetsUtils.profile),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         name,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         specialty,
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         price,
//                         style: TextStyle(fontSize: 14, color: primarySwatch),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Icon(Icons.star, color: primarySwatch, size: 18),
//                           SizedBox(width: 4),
//                           Text(
//                             "$rating",
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           Spacer(),
//                           Text(
//                             availableSlots,
//                             style: TextStyle(
//                                 fontSize: 12, color: Colors.grey[600]),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(
//               thickness: 0.3,
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//               // height: 50,
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: List.generate(
//                       calendar.length,
//                       (index) => Column(
//                             children: [
//                               Text(
//                                 calendar[index].day,
//                                 style: const TextStyle(fontSize: 15),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 calendar[index].date,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 19,
//                                     color: index == 0
//                                         ? primarySwatch
//                                         : Colors.black),
//                               )
//                             ],
//                           ))),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
