class ValidationForm {
  static bool isValidEmail(String email) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(email);
  }

  static bool isValidInputString(String userName) {
    final nameRegExp =
        new RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(userName);
  }

  static bool isValidPassword(String password) {
    final passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  static bool isValidPhone(String phoneNumber) {
    final phoneRegExp = RegExp(r"^(?:[+0]8)?[0-9]{11,14}$");
    return phoneRegExp.hasMatch(phoneNumber);
  }

  static bool isValidInputSpecialCharacters(String value) {
    final inputSpecial = RegExp(r'^[a-zA-Z0-9]+$');
    return inputSpecial.hasMatch(value);
  }
}
