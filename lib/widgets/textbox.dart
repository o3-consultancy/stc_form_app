import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomInputBox extends StatelessWidget {
  final String labelText;
  final TextInputType inputType;
  final TextEditingController controller;

  const CustomInputBox({
    super.key,
    required this.labelText,
    this.inputType = TextInputType.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        readOnly: inputType == TextInputType.datetime,
        keyboardType: inputType,
        onTap: () {
          if (inputType == TextInputType.datetime) {
            _selectDate(context);
          }
        },
        decoration: InputDecoration(
          hintText: labelText, // Use hintText instead of labelText
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }
}
