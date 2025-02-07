// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
//
// class PhoneField<T> extends StatelessWidget {
//   final TextEditingController? controller;
//   final Country country;
//   final void Function(Country country) callback;
//   final FormFieldValidator<String>? validator;
//
//   const PhoneField(
//       {super.key,
//       this.controller,
//       required this.country,
//       required this.callback,
//       this.validator});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       child: TextFormField(
//         controller: controller,
//         validator: validator,
//         keyboardType: TextInputType.phone,
//         decoration: InputDecoration(
//           prefixIcon: SizedBox(
//               width: 100,
//               child: InkWell(
//                   onTap: () {
//                     showCountryPicker(
//                       context: context,
//                       showPhoneCode:
//                           true, // optional. Shows phone code before the country name.
//                       onSelect: callback,
//                     );
//                   },
//                   child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 10),
//                         child: Row(children: [
//                           Text(country.flagEmoji,
//                               style: const TextStyle(fontSize: 40)),
//                           Text(
//                             " +${country.phoneCode}",
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Container(
//                             height: 30,
//                             width: 0.2,
//                             color: Colors.grey,
//                             margin: EdgeInsets.only(left: 5),
//                           )
//                         ]),
//                       )))),
//           hintText: "Phone number",
//         ),
//       ),
//     );
//   }
// }

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PhoneField<T> extends StatelessWidget {
  final TextEditingController? controller;
  final Country country;
  final void Function(Country country) callback;
  final FormFieldValidator<String>? validator;
  final InputDecoration? inputDecoration;
  final bool enabled;

  const PhoneField(
      {super.key,
        this.controller,
        required this.country,
        required this.callback,
        this.validator,
        this.inputDecoration,
        this.enabled = true});

  @override
  Widget build(BuildContext context) {
    var icon = SizedBox(
        width: 100,
        child: InkWell(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode:
                true, // optional. Shows phone code before the country name.
                onSelect: callback,
              );
            },
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(children: [
                    MediaQuery(    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),

                      child: Text(country.flagEmoji,
                          style: const TextStyle(fontSize: 33)),
                    ),
                    MediaQuery(    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),

                      child: Text(
                        " +${country.phoneCode}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),

                  ]),
                ))));
    return TextFormField(
      controller: controller,
      validator: validator,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      decoration: inputDecoration?.copyWith(prefixIcon: icon) ??
          InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8)),
            prefixIcon: icon,
            hintText: "Enter your phone number",
          ),
    );
  }
}
