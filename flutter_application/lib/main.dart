import 'package:flutter/material.dart';
import 'presentation/pages/welcome_page.dart';

void main() {
  runApp(const MerchantAI());
}

class MerchantAI extends StatelessWidget {
  const MerchantAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MerchantAI',
      theme: ThemeData(

        primaryColor: const Color(0xFF5D6DA0),
        scaffoldBackgroundColor: const Color(0xFF5D6DA0),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
      ),
      home: const WelcomePage(),
    );
  }
}