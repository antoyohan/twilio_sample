import 'package:flutter/material.dart';
import 'package:twilio_sample/screens/chat/chat_page.dart';
import 'package:twilio_sample/screens/login/login_page.dart';
import 'package:twilio_sample/ui/chat_cards.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
