import 'package:flutter/material.dart';

Color hexToColor(String code) {
  if (code.startsWith('#')) {
    code = code.substring(1);
  }
  return Color(int.parse(code, radix: 16) + 0xFF000000);
}