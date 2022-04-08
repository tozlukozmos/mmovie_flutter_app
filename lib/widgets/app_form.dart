import 'package:flutter/material.dart';

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
          RegExp regex = RegExp(r'\w+@\w+\.\w+');
          if (!regex.hasMatch(value)) {
            return "please check your email format";
          } else {
            return null;
          }
        } else if (isPassword) {
          if (value.length < 6) {
            return "password must be at least 6 char";
          } else {
            return null;
          }
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "please type something";
        } else {
          return null;
        }
      },
      onChanged: (value) => {
        onChanged(value),
      },
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeData.dark().primaryColor,
            width: 2,
          ),
        ),
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.search_rounded),
        hintText: hint,
      ),
    );
  }
}
