import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/cousers.dart';
import '../../theme/colors.dart';
import 'widgets/background_stack.dart';
import 'widgets/carousel_card.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController =
        PageController(initialPage: _currentPage, viewportFraction: 1);
  }

  final _listCard = CarouselsCard.generateList();

  @override
  Widget build(BuildContext context) {
    return BackgroundBlur(
      screens: Column(
        children: [
          Container( margin: const EdgeInsets.only(left: 10,right: 10,top: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _listCard
                  .map((e) => Flexible(
                    child: Container(
                                  margin: const EdgeInsets.all(2.0),
                                  height: 2,
                                  // width: 12,
                                  decoration: BoxDecoration(
                      color: _listCard.indexOf(e) == _currentPage
                          ? primarySwatch
                          : Colors.grey.shade100,
                      border:
                      Border.all(color: Colors.grey, width: 0),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(50))),
                                ),
                  ))
                  .toList(),
            ),
          ),

          SizedBox(
            height: 650,
            child: PageView.builder(
                onPageChanged: (index) => setState(() => _currentPage = index),
                physics: const ClampingScrollPhysics(),
                itemCount: _listCard.length,
                controller: _pageController,
                itemBuilder: (context, index) {
                  // return const BackgroundBlur();
                  return CarouselCard(
                    carouselsCard: _listCard[index],
                    indexCard: index,
                  );
                }),
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(0),
          //       child: ,
          //     ),
          //   ],
          // )
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(12.0))),
                  padding:
                  const EdgeInsets.only(top: 15, bottom: 15),
                  backgroundColor: primarySwatch,
                  minimumSize: const Size(254, 45)),
              onPressed: () {
                context.go('/login');
              },
              child: const Text(
                "Next",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.white,),
              )),
          const SizedBox(height: 40,)
        ],
      ),
      paddingSize: 0.0,
    );
  }

  Widget buildImage(String slideImages, int index) => Image.asset(
        slideImages,
      );
}
