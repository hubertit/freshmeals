import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/_assets.dart';
import '../../../theme/colors.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          context.go('/');
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),
                const Text(
                  "You've Ordered Successfully",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your order has been received. Sit tight while we prepare your hearty meal.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: secondarTex),
                ),
                // const SizedBox(height: 10),
                // RichText(
                //   text: const TextSpan(
                //     text: 'View Order',
                //     style: TextStyle(
                //       color: primarySwatch, // Set text color
                //       fontSize: 16, // Set font size
                //       decoration: TextDecoration.underline, // Underline the text
                //     ),
                //   ),
                // ),
                const SizedBox(height: 10),
                Image.asset(AssetsUtils.success)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
