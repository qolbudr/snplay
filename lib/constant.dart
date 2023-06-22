import 'package:flutter/material.dart';

const primaryColor = Color(0xFFECAC07);
const secondaryColor = Color(0xFF3F3F3F);
const h1 = TextStyle(fontSize: 35);
const h2 = TextStyle(fontSize: 25);
const h3 = TextStyle(fontSize: 18);
const h4 = TextStyle(fontSize: 16);
const h5 = TextStyle(fontSize: 14);
const smallText = TextStyle(fontSize: 10);
ButtonStyle defaultButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15, horizontal: 15)),
  textStyle: MaterialStateProperty.all(h4.copyWith(fontWeight: FontWeight.w600)),
  foregroundColor: MaterialStateProperty.all(Colors.black),
  backgroundColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.disabled)) {
      return primaryColor.withOpacity(0.5);
    } else {
      return primaryColor;
    }
  }),
  elevation: MaterialStateProperty.all(0),
  shape: MaterialStateProperty.all(
    const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  ),
);
