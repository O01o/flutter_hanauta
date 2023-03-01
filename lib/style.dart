import 'package:flutter/material.dart';

ButtonStyle styleColorToggle(bool flag) {
  return ButtonStyle(
    backgroundColor: flag
    ? MaterialStateProperty.all(Colors.red)
    : MaterialStateProperty.all(Colors.blue)
  );
}