import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/preferences.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/general.dart';
import 'package:go_router/go_router.dart';

import '../../models/general/preferances_model.dart';
import '../../models/user_model.dart';

class PreferencesScreen extends ConsumerStatefulWidget {
  final UserModel user;
  const PreferencesScreen({Key? key, required this.user}) : super(key: key);

  @override
  ConsumerState<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<PreferencesScreen> {
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 150.0,
                      ),
                      itemCount: preferences.preferances.length,
                      itemBuilder: (context, index) {
                        PreferenceModel preference =
                            preferences.preferances[index];
                        bool isSelected = selPref
                            .contains(preference.preferenceId);

                        return GestureDetector(
                          onTap: () {
                            // final selectedPreferences =
                            // ref.read(selectedPreferenceProvider.notifier);
                            //
                            // if (selectedPreferences.state
                            //     .contains(int.parse(preference.preferenceId))) {
                            //   selectedPreferences
                            //       .state = List.from(selectedPreferences.state)
                            //     ..remove(int.parse(preference.preferenceId));
                            //   setState(() {
                            //     widget.user.dietaryPreferences = selectedPref;
                            //   });
                            // } else {
                            //   selectedPreferences.state =
                            //   List.from(selectedPreferences.state)
                            //     ..add(int.parse(preference.preferenceId));
                            //   setState(() {
                            //     widget.user.dietaryPreferences = selectedPref;
                            //   });
                            // }

                            if (selPref
                                .contains(preference.name)) {

                              setState(() {
                                selPref = List.from(selPref)
                                  ..remove(preference.name);                              });
                            } else {

                              setState(() {
                                selPref =
                                List.from(selPref)
                                  ..add(preference.name);                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: isSelected
                                  ? Border.all(
                                      color: Colors.green,
                                      width: 2,
                                    )
                                  : null,
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  preference.imageUrl,
                                  height: 70,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  preference.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
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
