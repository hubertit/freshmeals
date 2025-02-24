import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/user_model.dart';

class AgeScreen extends StatefulWidget {
  final UserModel user;

  const AgeScreen({super.key, required this.user});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  int _selectedAge = 30; // Default selected age

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "What's your age?",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                if (details.delta.dx > 0 && _selectedAge < 120) {
                  _selectedAge++; // Swiping right to increase age
                } else if (details.delta.dx < 0 && _selectedAge > 1) {
                  _selectedAge--; // Swiping left to decrease age
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 30),
                  onPressed: () {
                    setState(() {
                      if (_selectedAge > 1) _selectedAge--;
                    });
                  },
                ),
                const SizedBox(width: 20),
                Text(
                  _selectedAge.toString(),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 30),
                  onPressed: () {
                    setState(() {
                      if (_selectedAge < 120) _selectedAge++;
                    });
                  },
                ),
              ],
            ),
          ),

          const Text(
            "YEARS OLD",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                var userM = widget.user;
                userM.age = _selectedAge;
                context.push('/gender', extra: userM);
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
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
