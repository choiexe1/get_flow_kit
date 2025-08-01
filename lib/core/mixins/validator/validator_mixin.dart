import 'package:get_flow_kit/core/mixins/validator/types/password_valid_type.dart';

mixin ValidatorMixin {
  bool isValidCreditCardNumber(String creditCardNumber) {
    final regExp = RegExp(r'^\d{4}-\d{4}-\d{4}-\d{4}$');

    return regExp.hasMatch(creditCardNumber);
  }

  bool isValidDriverLicenseNumber(String value) {
    final regExp = RegExp(r'^[가-힣]{2}\d{2}[가-힣]{1}\d{6}$');

    return regExp.hasMatch(value);
  }

  bool isValidBusinessRegistrationNumber(String value) {
    final regExp = RegExp(r'^\d{3}-\d{2}-\d{5}$');

    return regExp.hasMatch(value);
  }

  bool isValidJumin(String jumin) {
    if (!RegExp(r'^\d{13}$').hasMatch(jumin)) return false;
    int year = int.parse(jumin.substring(0, 2));
    final month = int.parse(jumin.substring(2, 4));
    final day = int.parse(jumin.substring(4, 6));
    final centuryCode = int.parse(jumin[6]);

    if (centuryCode == 1 || centuryCode == 2) {
      year += 1900;
    } else if (centuryCode == 3 || centuryCode == 4) {
      year += 2000;
    } else {
      return false;
    }

    try {
      final dob = DateTime(year, month, day);
      if (dob.year != year || dob.month != month || dob.day != day) {
        return false;
      }
    } catch (e) {
      return false;
    }

    List<int> weights = [2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5];
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      sum += int.parse(jumin[i]) * weights[i];
    }
    int checkDigit = (11 - (sum % 11)) % 10;

    return checkDigit == int.parse(jumin[12]);
  }

  bool isValidPassword(
    String password, {
    PasswordValidType type = PasswordValidType.englishAndDigits,
  }) {
    RegExp regExp;

    switch (type) {
      case PasswordValidType.onlyEnglish:
        regExp = RegExp(r'^[a-zA-Z]{8,20}$');
        break;
      case PasswordValidType.englishAndDigits:
        regExp = RegExp(r'^[a-zA-Z0-9]{8,20}$');
        break;
      case PasswordValidType.lowercaseEnglishAndDigits:
        regExp = RegExp(r'^[a-z0-9]{8,20}$', caseSensitive: true);
        break;
      case PasswordValidType.uppercaseEnglishAndDigits:
        regExp = RegExp(r'^[A-Z0-9]{8,20}$');
        break;
      case PasswordValidType.englishAndDigitsAndSpecials:
        regExp = RegExp(
          r'^[a-zA-Z0-9!@#$%^&*()_+|~=`{}\[\]:";\<>?,.\/]{8,20}$',
        );
        break;
    }

    return regExp.hasMatch(password);
  }
}
