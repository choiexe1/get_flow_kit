enum PasswordValidType {
  /// 영문 대소문자 8 ~ 20자
  onlyEnglish,

  /// 영문 대소문자, 숫자 포함 8 ~ 20자
  englishAndDigits,

  /// 영문 대소문자, 숫자, 특수기호 포함 8 ~ 20자
  englishAndDigitsAndSpecials,

  /// 오직 영문 소문자와 숫자 포함 8 ~ 20자
  lowercaseEnglishAndDigits,

  /// 오직 영문 대문자와 숫자 포함 8 ~ 20자
  uppercaseEnglishAndDigits,
}
