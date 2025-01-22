import 'package:flutter/material.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:go_router/go_router.dart';

import '../../models/user_model.dart';

class HeightInputScreen extends StatefulWidget {
  final UserModel user;
  const HeightInputScreen({super.key, required this.user});

  @override
  _HeightInputScreenState createState() => _HeightInputScreenState();
}

class _HeightInputScreenState extends State<HeightInputScreen> {
  double _height = 170; // Default height

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("What's your height?"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Linear gauge container
                Container(
                  height: 500,
                  child: LinearGauge(
                    start: 0,
                    end: 250, // Adjust max height as needed
                    rulers: RulerStyle(
                        rulerPosition: RulerPosition.right,
                        showLabel: false,
                        secondaryRulerPerInterval: 9,
                        showSecondaryRulers: true),
                    gaugeOrientation: GaugeOrientation.vertical,
                    pointers: [
                      Pointer(
                        color: primarySwatch,
                        height: 50,
                        width: 20,
                        pointerPosition: PointerPosition.right,
                        pointerAlignment: PointerAlignment.center,
                        // showLabel: true,
                        labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        value: _height,
                        shape: PointerShape.triangle,
                        isInteractive: true,
                        onChanged: (v) {
                          setState(() {
                            _height = v.ceil().toDouble();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Spacer(),
                // Next button
                Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      widget.user.height = _height.ceil() / 100;

                      context.push('/weight', extra: widget.user);
                    },
                    child: const Text(
                      "NEXT",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
            Positioned(
              right: 0,
              bottom: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: Text(
                  '${_height.ceil() / 100} M', // Always show ceiled value
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
