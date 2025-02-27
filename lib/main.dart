import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snplay/constant.dart';
import 'package:snplay/view/pages/auth/login_page.dart';
import 'package:snplay/view/pages/auth/login_selection_page.dart';
import 'package:snplay/view/pages/auth/register_page.dart';
import 'package:snplay/view/pages/auth/register_selection_page.dart';
import 'package:snplay/view/pages/genre_screen_page.dart';
import 'package:snplay/view/pages/midtrans_pay_page.dart';
import 'package:snplay/view/pages/movie_detail_screen_page.dart';
import 'package:snplay/view/pages/player_screen_page.dart';
import 'package:snplay/view/pages/player_series_screen_page.dart';
import 'package:snplay/view/pages/root_screen_page.dart';
import 'package:snplay/view/pages/search_screen_page.dart';
import 'package:snplay/view/pages/series_detail_screen_page.dart';
import 'package:snplay/view/pages/splash_screen_page.dart';
import 'package:snplay/view/pages/subscription_screen_page.dart';
import 'package:snplay/view/pages/success_screen_page.dart';
import 'package:snplay/view/pages/welcome_screen_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      title: 'SnPlay',
      theme: ThemeData.dark().copyWith(
        splashColor: primaryColor,
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
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: primaryColor,
        ),
      ),
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/welcome', page: () => const WelcomeScreen(), transition: Transition.cupertino),
        GetPage(name: '/subscription', page: () => SubscriptionScreen(), transition: Transition.cupertino),
        GetPage(name: '/login/selection', page: () => LoginSelection(), transition: Transition.cupertino),
        GetPage(name: '/register/selection', page: () => RegisterSelection(), transition: Transition.cupertino),
        GetPage(name: '/login', page: () => Login(), transition: Transition.cupertino),
        GetPage(name: '/register', page: () => Register(), transition: Transition.cupertino),
        GetPage(name: '/root', page: () => Root(), transition: Transition.cupertino),
        GetPage(name: '/movie', page: () => const MovieDetailScreen(), transition: Transition.cupertino),
        GetPage(name: '/series', page: () => const SeriesDetailScreen(), transition: Transition.cupertino),
        GetPage(name: '/player', page: () => Player(), transition: Transition.cupertino),
        GetPage(name: '/player/series', page: () => const PlayerSeries(), transition: Transition.cupertino),
        GetPage(name: '/search', page: () => Search(), transition: Transition.cupertino),
        GetPage(name: '/genre', page: () => GenreScreen(), transition: Transition.cupertino),
        GetPage(name: '/midtrans-pay', page: () => const MidtransPay(), transition: Transition.cupertino),
        GetPage(name: '/success', page: () => Success(), transition: Transition.cupertino),
      ],
    );
  }
}
