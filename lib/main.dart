import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/view/pages/auth/login_page.dart';
import 'package:snplay/view/pages/auth/login_selection_page.dart';
import 'package:snplay/view/pages/home_screen_page.dart';
import 'package:snplay/view/pages/splash_screen_page.dart';
import 'package:snplay/view/pages/welcome_screen_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      title: 'SnPlay',
      theme: ThemeData.dark().copyWith(
        primaryColor: primaryColor,
        textSelectionTheme: const TextSelectionThemeData(cursorColor: primaryColor),
        inputDecorationTheme: const InputDecorationTheme().copyWith(
          floatingLabelStyle: const TextStyle(inherit: true, color: primaryColor),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: h3.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const SplashScreen(),
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/welcome', page: () => const WelcomeScreen(), transition: Transition.cupertino),
        GetPage(name: '/login/selection', page: () => const LoginSelection(), transition: Transition.cupertino),
        GetPage(name: '/login', page: () => Login(), transition: Transition.cupertino),
        GetPage(name: '/home', page: () => const Home(), transition: Transition.cupertino),
      ],
    );
  }
}
