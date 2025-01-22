import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart' as vector_icons;
import 'package:freshmeals/views/homepage/cart_screen.dart';
import 'package:freshmeals/views/homepage/favorites_screen.dart';
import 'package:freshmeals/views/homepage/meals.dart';
import 'package:freshmeals/views/homepage/profile.dart';
import 'package:freshmeals/views/homepage/search_screen.dart';

// int screenIndex =1;
class Homepage extends ConsumerStatefulWidget {
  final bool isSearching;
  const Homepage({super.key, this.isSearching = false});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    // var user = ref.watch(userProvider);
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children:  [
          const MealsPage(),
          SearchPage(),
          ChartScreen(),
          const FavoritesScreen(),
          const Profile(),
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
              icon: Icon(Icons.set_meal_sharp), label: "Merals"),
          BottomNavigationBarItem(
              icon: Icon(vector_icons.AntDesign.search1), label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(vector_icons.Ionicons.ios_cart), label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favorites"),
          BottomNavigationBarItem(
              icon: Icon(vector_icons.Ionicons.person_outline),
              label: "Account"),
        ],
      ),
    );
  }
}
