import 'package:jobish_task/style/string.dart';
import 'package:jobish_task/utils/helper.dart';

class ValidationUtils {
  /*---- Other Validation -------------------------------------------------------------*/

  static bool isEmailValid(final String email) {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      showMessage(message: strErrorEmailEmpty);
      return false;
    } else if (!_regExpEmail.hasMatch(trimmedEmail)) {
      showMessage(message: strErrorEmailInvalid);
      return false;
    }
    return true;
  }

  static bool isPasswordValid(final String password) =>
      _validatePassword(password, strErrorPasswordEmpty);

  static const _minPasswordLength = 8;
  static const _maxPasswordLength = 15;

  static final RegExp _regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  static bool _checkPasswordComplexity(final String password) =>
      password.contains(RegExp(r'[A-Z]')) &&
      password.contains(RegExp(r'[a-z]')) &&
      password.contains(RegExp(r'[0-9!@#$%^&*()_+\-=\[\]{};:",.<>?\\|`~]'));

  static bool _isLengthValid(
    final String input, {
    final int min = _minPasswordLength,
    final int max = _maxPasswordLength,
  }) => input.length >= min && input.length <= max;

  static bool _validatePassword(final String password, final String emptyMsg) {
    final trimmedPassword = password.trim();
    if (trimmedPassword.isEmpty) {
      showMessage(message: emptyMsg);
      return false;
    } else if (!_isLengthValid(trimmedPassword)) {
      showMessage(message: strErrorPasswordLength);
      return false;
    } else if (!_checkPasswordComplexity(trimmedPassword)) {
      showMessage(message: strErrorPasswordComplexity);
      return false;
    }
    return true;
  }
}
