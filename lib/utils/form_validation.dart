class FormValidation {
  static String? validateEmail(String? value) {
    RegExp regex = RegExp(r'\w+@\w+\.\w+');
    if (value == null || value.isEmpty) {
      return "email is required";
    } else if (!regex.hasMatch(value)) {
      return "please check your email format";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "password is required";
    } else if (value.length < 6) {
      return "password should be at least 6 char";
    }
    return null;
  }
}
