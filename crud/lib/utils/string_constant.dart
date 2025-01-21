import 'package:flutter/foundation.dart';

const String NAME = 'Name';
const String AGE = 'Age';
const String EMAIL = 'Email';
const String PHONE = 'Phone';
const String CITY = 'City';
const String LOGIN_TEXT = 'LOGIN';
const String REGISTER_TEXT = 'REGISTER';

void printWarning(String text) {
  if (kDebugMode) {
    print('\x1B[33m$text\x1B[0m');
  }
}

void printResultText(String text) {
  if (kDebugMode) {
    print('\x1B[31m$text\x1B[0m');
  }
}