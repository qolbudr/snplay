import 'package:flutter/material.dart';

const apiKey = 'jBybHUSehsW4oRzC';
const baseURL = 'https://api.snplay.co/android';
const tmdbBaseURL = 'https://api.themoviedb.org/3';
const tmdbApiKey = 'cad7722e1ca44bd5f1ea46b59c8d54c8';
const Map<String, dynamic> midtransConfig = {
  'clientKey': 'SB-Mid-client-57yQ1MZNJIdEmX2M',
  'serverKey': 'SB-Mid-server-_uIYFZ5_zg_LAEcSDjB63KNS',
  'url': 'https://app.sandbox.midtrans.com/snap/snap.js',
};

const vercelURL = 'http://10.0.2.2:5000';

const primaryColor = Color(0xFFECAC07);
const secondaryColor = Color(0xFF3F3F3F);
const h1 = TextStyle(fontSize: 35);
const h2 = TextStyle(fontSize: 25);
const h3 = TextStyle(fontSize: 18);
const h4 = TextStyle(fontSize: 16);
const h5 = TextStyle(fontSize: 14);
const rowSpacer = TableRow(
  children: [
    SizedBox(
      height: 8,
    ),
    SizedBox(
      height: 8,
    )
  ],
);

enum Status { loading, error, success, empty }

String getError(e) => e.toString().replaceAll('Exception: ', '');
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
