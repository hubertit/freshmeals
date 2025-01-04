import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class PhoneField<T> extends StatelessWidget {
  final TextEditingController? controller;
  final Country country;
  final void Function(Country country) callback;
  final FormFieldValidator<String>? validator;

  const PhoneField(
      {super.key,
      this.controller,
      required this.country,
      required this.callback,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          prefixIcon: SizedBox(
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
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(children: [
                          Text(country.flagEmoji,
                              style: const TextStyle(fontSize: 40)),
                          Text(
                            " +${country.phoneCode}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 30,
                            width: 0.2,
                            color: Colors.grey,
                            margin: EdgeInsets.only(left: 5),
                          )
                        ]),
                      )))),
          hintText: "Phone number",
        ),
      ),
    );
  }
}
