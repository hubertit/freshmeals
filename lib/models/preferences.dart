import '../constants/_assets.dart';

class Preference {
  final String name;
  final String imagePath;

  Preference({required this.name, required this.imagePath});
}


final List<Preference> preferences = [
  Preference(name: "Drinks", imagePath: AssetsUtils.drinks),
  Preference(name: "Healthy", imagePath: AssetsUtils.healthy),
  Preference(name: "Fish", imagePath: AssetsUtils.fish),
  Preference(name: "Fruits", imagePath: AssetsUtils.fruits),
  Preference(name: "Meat", imagePath: AssetsUtils.meat),
  Preference(name: "Medicine", imagePath: AssetsUtils.medicine),
  Preference(name: "Nuts", imagePath: AssetsUtils.nuts),
  Preference(name: "Pasta", imagePath: AssetsUtils.pasta),
  Preference(name: "Vegetables", imagePath: AssetsUtils.vegetables),
];
