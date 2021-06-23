import 'package:flutter_day5/screens/search_screen.dart';

import 'screens/authenticaion_wrapper.dart'  as h;

import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';

import 'screens/chat_screen.dart';
import 'screens/home_screen.dart';

const String ChatRoute = "/chatroute";
const String HomeRoute = "/home";
const String SignInRoute = "/signin";
const String SignUpRoute = "/signup";
const String AuthWrapper = "/";
const String SearchRoute = "/search";

final routes = {
  AuthWrapper:(context) => h.AuthWrapper(),
  ChatRoute: (context) => ChatScreen(),
  HomeRoute: (context) => HomeScreen(),
  SignInRoute: (context) => SignInScreen(),
  SignUpRoute: (context) => SignUpScreen(),
  SearchRoute : (context) => SearchScreen(),
};