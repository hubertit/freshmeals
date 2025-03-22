import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/preferences.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:go_router/go_router.dart';

import '../../models/general/preferances_model.dart';
import '../../models/user_model.dart';

class NutritionistsScreen extends ConsumerStatefulWidget {
  final UserModel user;
  const NutritionistsScreen({Key? key, required this.user}) : super(key: key);

  @override
  ConsumerState<NutritionistsScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<NutritionistsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(preferencesProvider.notifier).preferences(context);
    });
    super.initState();
  }
  List<String> selPref = [];

  final selectedPreferenceProvider = StateProvider<List<int>>((ref) => []);

  @override
  Widget build(BuildContext context) {
    print(selPref);
    var preferences = ref.watch(preferencesProvider);
    // var selectedPref = ref.watch(selectedPreferenceProvider);
    var user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: const Color(0xfff5f8fe),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Choose preferences"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: preferences!.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "You can choose interests and we have a few suggestions for you",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: preferences.preferances.length,
                itemBuilder: (context, index) {
                  PreferenceModel preference = preferences.preferances[index];
                  bool isSelected = selPref.contains(preference.name);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selPref.contains(preference.name)) {
                          selPref = List.from(selPref)..remove(preference.name);
                        } else {
                          selPref = List.from(selPref)..add(preference.name);
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
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
                              preference.imageUrl,
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
                                Text(
                                  preference.description ?? "No description available",
                                  style: const TextStyle(
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                widget.user.dietaryPreferences = selPref;
                context.push("/additional",extra: widget.user);

                // context.push('/welcome');
              },
              child: const Text(
                "Continue",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
