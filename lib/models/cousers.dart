
import '../constants/_assets.dart';

class CarouselsCard {
  String image;
  String title;
  String description;

  CarouselsCard(
      {required this.image, required this.title, required this.description});

  static List<CarouselsCard> generateList() {
    return [
      CarouselsCard(
        image: AssetsUtils.order,
        description: "Order your favorite meals anytime, anywhere.",
        title: "Order Online",
      ),
      CarouselsCard(
        image: AssetsUtils.nutri,
        description:"If you are wondering what to cook today, don't worry because we have a list for you.",
        title: "Nutritious and Wholesome Meals",
      ),
      CarouselsCard(
        image: AssetsUtils.derivered,
        description: 'The products you order will be delivered to your address',
        title: "Delivered Right to Your Doorstep",
      ),
    ];
  }
}
