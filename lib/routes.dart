
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/home/headlines_details.dart';
import 'screens/home/main_screen.dart';
import 'screens/home/newsettings.dart';
import 'screens/home/search_screen.dart';
import 'screens/splash_screen.dart';

late final User? user;

class AppRoutes {
  final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    MainScreen.mainscreen: (BuildContext context) => MainScreen(),
    HeadlinesDetails.headlinesDetails: (BuildContext context) =>
        const HeadlinesDetails(),
    SearchScreen.searchscreen: (BuildContext context) => const SearchScreen(),
    NewsSettings.newsSettings: (BuildContext context) => NewsSettings(
          user: user!,
        ),
    SplashScreen.splashscreen: (BuildContext context) => const SplashScreen(),
  };
}
