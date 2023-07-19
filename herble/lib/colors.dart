import 'package:flutter/material.dart';

const MaterialColor mainpallete =
    MaterialColor(_mainpalletePrimaryValue, <int, Color>{
  50: Color(0xFFE4E8E7),
  100: Color(0xFFBDC6C3),
  200: Color(0xFF91A09B),
  300: Color(0xFF647A72),
  400: Color(0xFF435E54),
  500: Color(_mainpalletePrimaryValue),
  600: Color(0xFF1E3B30),
  700: Color(0xFF193229),
  800: Color(0xFF142A22),
  900: Color(0xFF0C1C16),
});
const int _mainpalletePrimaryValue = 0xFF224136;

const MaterialColor mainpalleteAccent =
    MaterialColor(_mainpalleteAccentValue, <int, Color>{
  100: Color(0xFF5DFFBC),
  200: Color(_mainpalleteAccentValue),
  400: Color(0xFF00F690),
  700: Color(0xFF00DD81),
});
const int _mainpalleteAccentValue = 0xFF2AFFA6;
