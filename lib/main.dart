import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'routes.dart';

void main()async{
  //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChatApp());}


class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MaterialApp(
      routes: routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: Colors.black,
              elevation: 0.0,
        )
      ),
      ///// HomeScreen(),
    );
  }
}
