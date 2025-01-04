
import 'package:flutter/material.dart';

import '../../../models/cousers.dart';

class CarouselCard extends StatelessWidget {
  CarouselsCard carouselsCard;
  int? indexCard;

  CarouselCard({Key? key, required this.carouselsCard, this.indexCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top:  100 ,
                ),
                child: Image.asset(
                  carouselsCard.image,
                  height:  300,
                ),
              ),
              const Flexible(
                child: SizedBox(
                  height:40 ,
                ),
              ),
              Text(
                carouselsCard.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Flexible(
                child: SizedBox(
                  height: 0 ,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  carouselsCard.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xff262626), fontSize: 13),
                ),
              )
            ],
          ),
        ));
  }
}