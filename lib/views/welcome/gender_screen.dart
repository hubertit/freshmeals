import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshmeals/models/user_model.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:go_router/go_router.dart';

class GenderScreen extends StatefulWidget {
  final UserModel user;
  const GenderScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  // Variable to store the selected gender
  String selectedGender ="";

  // Helper method to set the selected gender
  void selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "What is your gender?",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Spacer(),
            GestureDetector(
              onTap: () => selectGender("Male"),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selectedGender == "Male" ? primarySwatch : const Color(0xffF5F8FD),
                      shape: BoxShape.circle,
                    ),
                    child:  Icon(
                      FontAwesomeIcons.mars,
                      size: 40,
                      color:selectedGender == "Male" ?Colors.white: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Male',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: selectedGender == "Male" ? primarySwatch : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => selectGender("Female"),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selectedGender == "Female" ? Colors.pink : const Color(0xffF5F8FD),
                      shape: BoxShape.circle,
                    ),
                    child:  Icon(
                      FontAwesomeIcons.venus,
                      size: 40,
                      color:selectedGender == "Female" ?Colors.white: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Female',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: selectedGender == "Female" ? Colors.pink : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: selectedGender == null
                  ? null
                  : () {
                // Save the selected gender in the user object
                widget.user.gender = selectedGender;
                // var userM = widget.user;
                // userM.gender = selectedGender;
                // Navigate to the next screen
                context.push('/height',extra: widget.user);
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
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
