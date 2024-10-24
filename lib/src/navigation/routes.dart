import 'package:digitalworld/src/screens/home_page.dart';
import 'package:digitalworld/src/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import '../screens/login_page.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    '/': (context) => const SplashScreen(),
    '/login': (context) => const LoginPage(),
    '/home_page':(context) => const HomePage(),
  };
}