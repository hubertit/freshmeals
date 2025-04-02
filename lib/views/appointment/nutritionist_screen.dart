import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/nutritionist.dart';
import 'package:freshmeals/models/preferences.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:go_router/go_router.dart';

import '../../models/general/preferances_model.dart';
import '../../models/user_model.dart';

class NutritionistsScreen extends ConsumerStatefulWidget {
  const NutritionistsScreen({super.key});

  @override
  ConsumerState<NutritionistsScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<NutritionistsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(nutritionistsProvider.notifier)
          .fetchNutritionists(context);
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var nutritionists = ref.watch(nutritionistsProvider);
    return Scaffold(
      // backgroundColor: const Color(0xfff5f8fe),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Choose Nutritionist"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: nutritionists!.isLoading? Center(child: CircularProgressIndicator(),):Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: nutritionists.nutritionists.length,
                itemBuilder: (context, index) {
                  Nutritionist preference = nutritionists.nutritionists[index];

                  return GestureDetector(
                    onTap: (){
                      context.push('/nutDetails',extra: preference);
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              preference.profilePicture,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  preference.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "Click to view the available time slots",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}
