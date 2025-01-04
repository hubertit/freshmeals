import 'package:flutter/material.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:go_router/go_router.dart';

class WeightInputScreen extends StatefulWidget {
  @override
  _HeightInputScreenState createState() => _HeightInputScreenState();
}

class _HeightInputScreenState extends State<WeightInputScreen> {
  double _height = 70.0; // Default height

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("How much do you weigh?"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),

                Center(
                  child: Text(
                    '${_height.ceil()} Kg', // Always show ceiled value
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                // Linear gauge container
                LinearGauge(
                  start: 0,
                  end: 250, // Adjust max height as needed
                  rulers: RulerStyle(
                      rulerPosition: RulerPosition.top,
                      showLabel: false,
                      secondaryRulerPerInterval: 9,
                      showSecondaryRulers: true),
                  gaugeOrientation: GaugeOrientation.horizontal,
                  pointers: [
                    Pointer(
                      color: primarySwatch,
                      height: 50,
                      width: 20,
                      pointerPosition: PointerPosition.top,
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
                // const Spacer(),
                // Next button
                Spacer(),
                SizedBox(
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
                      context.push('/subscription');
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


          ],
        ),
      ),
    );
  }
}
