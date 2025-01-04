
import 'package:email_validator/email_validator.dart';

String? validateName(String? name) {
  if (name == null || name.isEmpty) {
    // Name field is empty
    return 'Please enter your name.';
  }

  if (name.length < 3) {
    // Name is not valid if it's less than three characters
    return 'Name must be at least 3 characters long.';
  }

  return null; // Return null for valid input
}

String? validateEmptyness(String? name) {
  if (name == null || name.isEmpty) {
    // Name field is empty
    return '';
  }

  return null; // Return null for valid input
}

String? validatePhoneNumber(String? phoneNumber) {
  if (phoneNumber == null || phoneNumber.isEmpty) {
    // Phone number field is empty
    return 'Andikamo nomero ya Telephone.';
  }

  // Remove any non-digit characters from the phone number
  final cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

  if (cleanedPhoneNumber.length != 10) {
    // Phone number is not valid if it doesn't have 10 digits
    return 'Igomba kuba ari imibare icumi.';
  }

  return null; // Return null for valid input
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    // Password field is empty
    return 'Please enter your password.';
  }

  // Define a regex pattern for a strong password (at least 8 characters, containing letters and numbers)

  if (password.length < 6) {
    // Password does not meet the regex pattern
    return 'Password must be at least 6 characters.';
  }

  return null; // Return null for valid input
}
String? validateRequired(dynamic value) {
  const msg = "This field is required !!";
  if(value == null){
    return msg;
  }

  if(value is String && value.trim().isEmpty){
    return msg;
  }

  return null;
}






String? validateMobile(String? value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{8,14}$)';
  RegExp regExp = RegExp(pattern);
  if (value == null || value.isEmpty) {
    return "Phone number can not be empty";
  } else if (!regExp.hasMatch(value)) {
    return "Please input a valid phone number";
  } else {
    return null;
  }
}


String? validateEmail(String? value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern.toString());
  if (value == null || value.isEmpty) {
    return "Email can not be empty";
  } else {
    if (!regex.hasMatch(value)) {
      return "Enter a valid email.";
    }
    {
      final bool isValid = EmailValidator.validate(value);
      if (isValid) {
        return null;
      } else {
        return "Enter a valid email.";
      }
    }
  }
}