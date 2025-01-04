import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

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
        title:    const Text(
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

          // const SizedBox(height: 30),
          const Spacer(),

          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                if (details.delta.dx > 0) {
                  // Swiping right (increment age)
                  if (_selectedAge < 120) {
                    _selectedAge++;
                  }
                } else if (details.delta.dx < 0) {
                  // Swiping left (decrement age)
                  if (_selectedAge > 1) {
                    _selectedAge--;
                  }
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (_selectedAge > 1 ? _selectedAge - 1 : '').toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _selectedAge.toString(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  (_selectedAge < 120 ? _selectedAge + 1 : '').toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            "YEARS OLD",
            style: TextStyle(
              // fontSize: 16,
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
                context.push('/gender');
                // Handle the "Next" button press
                // print('Selected Age: $_selectedAge');
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
