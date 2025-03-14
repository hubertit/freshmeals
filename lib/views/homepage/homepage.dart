import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart' as vector_icons;
import 'package:freshmeals/views/homepage/cart_screen.dart';
import 'package:freshmeals/views/homepage/favorites_screen.dart';
import 'package:freshmeals/views/homepage/meals.dart';
import 'package:freshmeals/views/homepage/profile.dart';
import 'package:freshmeals/views/homepage/recomended_screen.dart';
import 'package:freshmeals/views/homepage/search_screen.dart';
import 'package:go_router/go_router.dart';

import '../../riverpod/providers/auth_providers.dart';
import '../../riverpod/providers/general.dart';
import '../../riverpod/providers/home.dart';
import '../appointment/appointments_booking.dart';
import 'non_instant_meals.dart';

// int screenIndex =1;
class Homepage extends ConsumerStatefulWidget {
  final bool isSearching;
  const Homepage({super.key, this.isSearching = false});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  late Timer _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var isFist = ref.watch(firstTimeProvider);
      if(isFist){
        context.go("/newAddress");
      }
      ref.read(firstTimeProvider.notifier).state =false;
      var user = ref.watch(userProvider);
      if (user!.user != null) {
        await ref
            .read(favoritesProvider.notifier)
            .fetchFavorites(context, user.user!.token);
      }
      _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
        ref
            .read(userProvider.notifier)
            .verifyToken(context, user.user!.token, ref);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    // var user = ref.watch(userProvider);
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          MealsPage(),
          RecommendedScreen(),
          NonInstantMealsScreen(),
          ChartScreen(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal_sharp), label: "Instant"),
          BottomNavigationBarItem(
              icon: Icon(Icons.recommend), label: "For You"),
          BottomNavigationBarItem(
              icon: Icon(Icons.nfc), label: "Pre-order"),
          BottomNavigationBarItem(
              icon: Icon(vector_icons.Ionicons.ios_cart), label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(vector_icons.Ionicons.person_outline),
              label: "Account"),
        ],
      ),
    );
  }
}
