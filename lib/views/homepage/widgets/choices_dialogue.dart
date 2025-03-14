import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ChoiceDialog extends StatefulWidget {
  @override
  _ChoiceDialogState createState() => _ChoiceDialogState();
}

class _ChoiceDialogState extends State<ChoiceDialog> {
  String _selectedChoice = 'In Person';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select   consultation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text('In Person'),
            value: 'In Person',
            groupValue: _selectedChoice,
            onChanged: (value) {
              setState(() {
                _selectedChoice = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Online'),
            value: 'Online',
            groupValue: _selectedChoice,
            onChanged: (value) {
              setState(() {
                _selectedChoice = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_selectedChoice == "In Person") {
              context.pop();
              context.push('/booking');
            } else {
              context.pop();
              launchUrl(Uri.parse("https://freshmeals.rw/app/questionnaire"));
            }
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
