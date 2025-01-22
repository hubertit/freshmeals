import 'package:flutter/material.dart';
import 'package:freshmeals/theme/colors.dart';

class ProfileItemIcon extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData leadingIcon;
  final Color avatarColor;
  final Color arrowColor;
  final Color? iconColor;
  final Color? titleColor;
  final double avatarRadius;
  final double? iconSize;
  final bool isLast;
  const ProfileItemIcon(
      {super.key,
        required this.title,
        required this.onPressed,
        required this.leadingIcon,
         this.avatarColor = primarySwatch,
        this.arrowColor = Colors.black38,
        this.iconColor=Colors.white,
        this.titleColor ,  this.avatarRadius = 30, this.iconSize,this.isLast=false
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // margin: const EdgeInsets.only(
      //   left: 20,
      //   right: 20,
      // ),
      onTap: onPressed,
      child: Column(
        children: [
          Row(
            children: [
              Container(height: avatarRadius,
                  width: avatarRadius,

                  decoration: BoxDecoration(color: avatarColor,borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    leadingIcon,
                    color: iconColor,
                    size: iconSize,
                  )),
              const SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  title,
                  style: TextStyle(color: titleColor,fontWeight: FontWeight.w400),
                ),
              ),
              Expanded(child: Container()),
              Icon(
                Icons.arrow_forward_ios,
                color: arrowColor,
                size: 15,

              )
            ],
          ),
          if(isLast==false)const Divider(thickness: 0.4,)
        ],
      ),
    );
  }
}
