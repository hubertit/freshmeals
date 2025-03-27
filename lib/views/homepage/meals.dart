import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:freshmeals/utls/callbacks.dart';
import 'package:freshmeals/utls/styles.dart';
import 'package:go_router/go_router.dart';

import '../../constants/_assets.dart';
import '../../riverpod/providers/home.dart';
import 'search_delegate.dart';
import 'widgets/choices_dialogue.dart';

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
      ref.read(mealTypesProvider.notifier).mealTypes(context, 'instant');
      ref.read(homeMealsDataProvider.notifier).fetchMeals(context);
      var user = ref.watch(userProvider)!.user;
      ref
          .read(breakFastProvider.notifier)
          .mealByTypes(context, '1', user!.token);
      ref
          .read(lunchDinerProvider.notifier)
          .mealByTypes(context, '2', user.token);
      ref
          .read(desertProvider.notifier)
          .mealByTypes(context, '4', user.token);
      ref
          .read(snacksProvider.notifier)
          .mealByTypes(context, '3', user.token);


    });
    super.initState();
  }
  String _meetingType = "Online"; // Default selection

  @override
  Widget build(BuildContext context) {
    var types = ref.watch(mealTypesProvider);
    var mealsHome = ref.watch(homeMealsDataProvider);
    var appointment = ref.watch(appointmentsProvider);
    var breakFast = ref.watch(breakFastProvider);
    var lunchDiner = ref.watch(lunchDinerProvider);
    var desert = ref.watch(desertProvider);
    var snacks = ref.watch(snacksProvider);
    var user = ref.watch(userProvider);
    return Scaffold(
      appBar:
          // AppBar(
          //   elevation: 0,
          //   leadingWidth: 200,
          //   // backgroundColor: primaryColor,
          //   leading: Row(
          //     children: [
          //       const SizedBox(
          //         width: 10,
          //       ),
          //       Container(
          //         padding: const EdgeInsets.only(bottom: 10),
          //         child: Image.asset(
          //           AssetsUtils.logo2,
          //           height: 50,
          //         ),
          //       ),
          //     ],
          //   ),
          //   actions: [
          //     CircleAvatar(
          //         radius: 18,
          //         backgroundColor: scaffold,
          //         // backgroundColor:
          //         //     Theme.of(context).inputDecorationTheme.fillColor,
          //         child:   GestureDetector(
          //           onTap: () {
          //
          //             context.push('/myAppointments');
          //           },
          //           child: Padding(
          //             padding: const EdgeInsets.all(9.0),
          //             child: Image.asset(AssetsUtils.consult),
          //           ),
          //         )
          //         // const Icon(
          //         //   Icons.schedule,
          //         //   color: Colors.black,
          //         //   size: 20,
          //         // )
          //         ),
          //     const SizedBox(
          //       width: 10,
          //     ),
          //     Material(
          //       clipBehavior: Clip.antiAliasWithSaveLayer,
          //       shape: RoundedRectangleBorder(
          //           // side: const BorderSide(color: Color(0xffE3E7EC)),
          //           borderRadius: BorderRadius.circular(1000)),
          //       child: InkWell(
          //         onTap: () {},
          //         child: Container(
          //             // color: Theme.of(context).inputDecorationTheme.fillColor,
          //             color: scaffold,
          //             height: 36,
          //             width: 36,
          //             child: const Center(
          //               child: Stack(
          //                 children: [
          //                   Icon(
          //                     Icons.notifications_none,
          //                     size: 20,
          //                     color: Colors.black,
          //                   ),
          //                   // Positioned(
          //                   //     top: 0,
          //                   //     right: 0,
          //                   //     child: Container(
          //                   //       decoration: BoxDecoration(
          //                   //           color: _notifications > 0
          //                   //               ? Colors.red
          //                   //               : Colors.red,
          //                   //           shape: BoxShape.circle),
          //                   //       width: 10,
          //                   //       height: 10,
          //                   //     ))
          //                 ],
          //               ),
          //             )),
          //       ),
          //     ),
          //     const SizedBox(
          //       width: 10,
          //     ),
          //     InkWell(
          //       onTap: () {
          //         showSearch(
          //           context: context,
          //           delegate: OpportunitySearchDelegate(ref),
          //         );
          //       },
          //       child: CircleAvatar(
          //           radius: 18,
          //           backgroundColor: scaffold,
          //           child: const Icon(
          //             Icons.search,
          //             color: Colors.black,
          //             size: 20,
          //           )),
          //     ),
          //     const SizedBox(
          //       width: 10,
          //     ),
          //   ],
          //   centerTitle: true,
          // ),

          AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 110,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              Row(
                children: [
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      AssetsUtils.logo2,
                      height: 50,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                      radius: 18,
                      backgroundColor: scaffold,
                      // backgroundColor:
                      //     Theme.of(context).inputDecorationTheme.fillColor,
                      child: GestureDetector(
                        onTap: (){
                          context.push("/nutritionists");
                        },
                        // onTap: () {
                        //   showModalBottomSheet(
                        //     context: context,
                        //     shape: const RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.vertical(
                        //           top: Radius.circular(15.0)),
                        //     ),
                        //     builder: (context) {
                        //       return Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 16.0, vertical: 50),
                        //         child: SizedBox(
                        //           width: double.infinity,
                        //           height: 150,
                        //           child: Column(
                        //             children: [
                        //               DropdownButtonFormField<String>(
                        //                 value: _meetingType,
                        //                 decoration: InputDecoration(
                        //                   border: OutlineInputBorder(
                        //                     borderRadius:
                        //                     BorderRadius.circular(
                        //                         8),
                        //                   ),
                        //                   contentPadding:
                        //                   const EdgeInsets
                        //                       .symmetric(
                        //                       vertical: 12,
                        //                       horizontal: 16),
                        //                 ),
                        //                 items: ["Online", "In-person"]
                        //                     .map((String option) {
                        //                   return DropdownMenuItem<
                        //                       String>(
                        //                     value: option,
                        //                     child: Text(option),
                        //                   );
                        //                 }).toList(),
                        //                 onChanged: (String? newValue) {
                        //                   setState(() {
                        //                     _meetingType = newValue!;
                        //                   });
                        //                 },
                        //               ),
                        //
                        //               Container(
                        //                 width: double.maxFinite,
                        //                 margin: EdgeInsets.only(top: 20),
                        //                 child: ElevatedButton(
                        //                   onPressed: () {
                        //                     // if (_meetingType ==
                        //                     //     "Online") {
                        //                     //   context.pop();
                        //                     //   launchUrl(Uri.parse(
                        //                     //       "https://freshmeals.rw/app/questionnaire"));
                        //                     // } else {
                        //                     ref
                        //                         .read(appointmentsProvider.notifier)
                        //                         .bookAppointment(
                        //                         context, user!.user!.token, _meetingType
                        //                       // "$_eventDate",
                        //                       // appontment
                        //                       //     .startTime,
                        //                       // "${calculateDuration(appontment.startTime, appontment.endTime)}",
                        //                       // ref,_meetingType
                        //                     );
                        //                     // }
                        //                   },
                        //                   style: ElevatedButton.styleFrom(
                        //                     backgroundColor:
                        //                     primarySwatch, // Use your app's theme color
                        //                     padding: const EdgeInsets.symmetric(
                        //                         vertical: 14),
                        //                     shape: RoundedRectangleBorder(
                        //                       borderRadius: BorderRadius.circular(10),
                        //                     ),
                        //                   ),
                        //                   child: appointment!.isLoading
                        //                       ? const Center(
                        //                     child: CircularProgressIndicator(),
                        //                   )
                        //                       : const Text(
                        //                     "Request For Nutritionist Appointment",
                        //                     style: TextStyle(
                        //                         fontSize: 16,
                        //                         fontWeight: FontWeight.bold,
                        //                         color: Colors.white),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   );
                        // },
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Image.asset(AssetsUtils.consult),
                        ),
                      )
                      // const Icon(
                      //   Icons.schedule,
                      //   color: Colors.black,
                      //   size: 20,
                      // )
                      ),
                  const SizedBox(
                    width: 10,
                  ),
                  Material(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                        // side: const BorderSide(color: Color(0xffE3E7EC)),
                        borderRadius: BorderRadius.circular(1000)),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                          // color: Theme.of(context).inputDecorationTheme.fillColor,
                          color: scaffold,
                          height: 36,
                          width: 36,
                          child: const Center(
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                // Positioned(
                                //     top: 0,
                                //     right: 0,
                                //     child: Container(
                                //       decoration: BoxDecoration(
                                //           color: _notifications > 0
                                //               ? Colors.red
                                //               : Colors.red,
                                //           shape: BoxShape.circle),
                                //       width: 10,
                                //       height: 10,
                                //     ))
                              ],
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: OpportunitySearchDelegate(ref),
                      );
                    },
                    child: CircleAvatar(
                        radius: 18,
                        backgroundColor: scaffold,
                        child: const Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 20,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              // TextField(
              //   readOnly: true,
              //   onTap: () {
              //     showSearch(
              //       context: context,
              //       delegate: OpportunitySearchDelegate(ref),
              //     );
              //   },
              //   decoration: InputDecoration(
              //     hintText: "Find something...",
              //     suffixIcon: Container(
              //         margin: const EdgeInsets.all(6),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(5),
              //           color: primarySwatch,
              //         ),
              //         child: const Icon(Icons.search, color: Colors.white)),
              //     filled: true,
              //     fillColor: Colors.transparent,
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(30),
              //       borderSide: BorderSide.none,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),
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

                      // context
                      // .push('/lunch/${mealType.typeId}/${mealType.name}');
                    });
                  })),
                ),
              const SizedBox(height: 10),
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
                    // Container(
                    //   // height: 220,
                    //   // width: MediaQuery.of(context).size.width / 1.7,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     color: Colors.white,
                    //     boxShadow: const [],
                    //   ),
                    //   child: InkWell(
                    //     onTap:()=> context.push(
                    //         "/mealDetails/${mealsHome.mealsData!.featured.mealId}"),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         ClipRRect(
                    //           borderRadius:
                    //           const BorderRadius.vertical(top: Radius.circular(10)),
                    //           child: Image.network(
                    //             mealsHome.mealsData!.featured.imageUrl, fit: BoxFit.cover,
                    //             width: double
                    //                 .infinity, // Makes the image fill the container width
                    //             height: 200, // Set a fixed height to ensure uniformity
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Text(trimm(25, mealsHome.mealsData!.featured.name),
                    //                   style: const TextStyle(
                    //                       fontWeight: FontWeight.w500, fontSize: 14)),
                    //               const SizedBox(height: 5),
                    //               Text("${formatMoney(mealsHome.mealsData!.featured.price)} Rwf ",
                    //                   style: const TextStyle(
                    //                       color: primarySwatch,
                    //                       fontSize: 16,
                    //                       fontWeight: FontWeight.bold)),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    if(mealsHome.mealsData!.featured!=null)InkWell(
                      onTap: () => context.push(
                          "/mealDetails/${mealsHome.mealsData!.featured!.mealId}"),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  mealsHome.mealsData!.featured!.imageUrl),
                              // NetworkImage(categories
                              //     .mealCategories[index]
                              //     .imageUrl)
                            )),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black54
                              ],
                              begin: Alignment.center,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                  left: 10,
                                  bottom: 10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          trimm(
                                              25,
                                              mealsHome
                                                  .mealsData!.featured!.name),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.white)),
                                      const SizedBox(height: 5),
                                      Text(
                                          "${formatMoney(mealsHome.mealsData!.featured!.price)} Rwf ",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )),
                              Positioned(
                                  right: 1,
                                  top: 1,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: primarySwatch.withOpacity(0.8),
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(15))),
                                      child: const Text(
                                        "Today’s dinner special",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                      ))),

                              // const Positioned(
                              //     left: 10,
                              //     top: 10,
                              //     child: Text("Today’s dinner special",
                              //         style: TextStyle(
                              //             fontWeight: FontWeight.w500,
                              //             fontSize: 16,
                              //             color: Colors.white)))
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // _buildSection(
                    //     "Recommended",
                    //     List.generate(
                    //       recommendations.recomendations.length,
                    //       (index) {
                    //         var pick = recommendations.recomendations[index];
                    //         return InkWell(
                    //           onTap: () =>
                    //               context.push("/mealDetails/${pick.mealId}"),
                    //           child: Padding(
                    //             padding: const EdgeInsets.only(right: 10.0),
                    //             child: Container(
                    //               width: 140,
                    //               height: 210,
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(10),
                    //                 color: Colors.white,
                    //                 boxShadow: const [],
                    //               ),
                    //               child: Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   Expanded(
                    //                     child: ClipRRect(
                    //                       borderRadius:
                    //                           const BorderRadius.vertical(
                    //                               top: Radius.circular(10)),
                    //                       child: Image.network(pick.imageUrl,
                    //                           fit: BoxFit.cover),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Column(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.start,
                    //                       children: [
                    //                         Text(formatStringDigits(pick.name),
                    //                             style: const TextStyle(
                    //                                 fontWeight: FontWeight.w500,
                    //                                 fontSize: 14)),
                    //                         const SizedBox(height: 5),
                    //                         Text(
                    //                             "${formatMoney(pick.price)} Rwf ",
                    //                             style: const TextStyle(
                    //                                 color: primarySwatch,
                    //                                 fontSize: 16,
                    //                                 fontWeight:
                    //                                     FontWeight.bold)),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //     '0'),
                    // const SizedBox(height: 16),
                    // _buildMealSection(
                    //   "Recommended",
                    //   "These are the meals recommended for you",
                    //   List.generate(recommendations.recomendations.length,
                    //           (index) {
                    //         var recom = recommendations.recomendations[index];
                    //
                    //         return _buildMealCard(
                    //             recom.name,
                    //             recom.price,
                    //             recom.imageUrl,
                    //                 () =>
                    //                 context.push("/mealDetails/${recom.mealId}"));
                    //       }),
                    // ),
                    // const SizedBox(height: 16),
                    if(breakFast!.mealCategories.isNotEmpty) _buildMealSection(
                        "Breakfast",
                        "Start your day with wholesome and nutritious meals",
                        List.generate(breakFast.mealCategories.length,
                            (index) {
                          var breakF = breakFast.mealCategories[index];

                          return _buildMealCard(
                              breakF.name,
                              breakF.price,
                              breakF.imageUrl,
                              () => context
                                  .push("/mealDetails/${breakF.mealId}"));
                        }),
                        "1"),

                    const SizedBox(height: 16),
                    if(lunchDiner!.mealCategories.isNotEmpty)_buildMealSection(
                        "Lunch/Diner",
                        "Fuel your afternoon with hearty, balanced meals",
                        List.generate(lunchDiner.mealCategories.length,
                            (index) {
                          var lunch = lunchDiner.mealCategories[index];

                          return _buildMealCard(
                              lunch.name,
                              lunch.price,
                              lunch.imageUrl,
                              () =>
                                  context.push("/mealDetails/${lunch.mealId}"));
                        }),
                        "2"),
                    const SizedBox(height: 16),
                   if(desert!.mealCategories.isNotEmpty) _buildMealSection(
                        "Desert",
                        "End your day with a healthy, delicious, and satisfying meal",
                        List.generate(desert.mealCategories.length,
                            (index) {
                          var dinner = desert.mealCategories[index];

                          return _buildMealCard(
                              dinner.name,
                              dinner.price,
                              dinner.imageUrl,
                              () => context
                                  .push("/mealDetails/${dinner.mealId}"));
                        }),
                        "3"),
                    const SizedBox(height: 16),
                    if(snacks!.mealCategories.isNotEmpty)_buildMealSection(
                        "Snack",
                        "Midday snacks to keep your energy levels high",
                        List.generate(snacks.mealCategories.length,
                                (index) {
                              var breakF = snacks.mealCategories[index];

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

  Widget _buildSection(String title, List<Widget> cards, String typeId) {
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
                  context
                      .push('/lunch/${typeId}/${Uri.encodeComponent(title)}');
                  print(Uri.encodeComponent(title));
                  // context.push(
                  //     "/lunch/extra: {'typeId': ${typeId}, 'title': ${title}}");
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
}
