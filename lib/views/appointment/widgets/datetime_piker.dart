import 'package:flutter/material.dart';
import 'package:freshmeals/theme/colors.dart';
import 'package:intl/intl.dart';


class CustomDatePickerField extends StatefulWidget {
  final DateTime? initialDate;
  final String hint;
  final Function(DateTime) onDateSelected;

  const CustomDatePickerField({
    Key? key,
    required this.hint,
    required this.onDateSelected,
    this.initialDate,
  }) : super(key: key);

  @override
  _CustomDatePickerFieldState createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
    // _controller.text = _formatDate(selectedDate!);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        _controller.text = _formatDate(selectedDate!);
        widget.onDateSelected(selectedDate!);
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date); // Only formats the date
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: _controller,
        readOnly: true, // Makes the field non-editable
        decoration: InputDecoration(
          filled: true,
          fillColor: scaffold,
          hintText: widget.hint,
          prefixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
        onTap: () => _selectDate(context),
      ),
    );
  }
}
