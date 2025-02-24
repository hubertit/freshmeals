// import 'package:flutter/material.dart';
//
// class BookingBottomSheetModel extends StatefulWidget {
//   const BookingBottomSheetModel({super.key});
//
//   @override
//   State<BookingBottomSheetModel> createState() => _BookingBottomSheetModelState();
// }
//
// class _BookingBottomSheetModelState extends State<BookingBottomSheetModel> {
//   TimeOfDay? _timeFrom;
//   TimeOfDay? _timeTo;
//
//   Future<void> _selectTime(BuildContext context, bool isFrom) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//
//     if (picked != null) {
//       setState(() {
//         if (isFrom) {
//           _timeFrom = picked;
//         } else {
//           _timeTo = picked;
//         }
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }
// }
