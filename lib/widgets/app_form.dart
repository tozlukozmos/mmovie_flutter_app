import 'package:flutter/material.dart';

import '../utils/form_validation.dart';

class AppForm {
  static Widget appTextFormField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return label.toLowerCase() + " is required";
        } else if (isEmail) {
          FormValidation.validateEmail(value);
        } else if (isPassword) {
          FormValidation.validatePassword(value);
        } else {
          return null;
        }
      },
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      obscureText: isPassword,
      decoration: InputDecoration(labelText: label),
    );
  }

  static Widget appSearchField({
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      onChanged: (value) => {onChanged(value)},
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeData.dark().primaryColor,
            width: 2
          ),
        ),
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.search_rounded),
        hintText: hint,
      ),
    );
  }
}
