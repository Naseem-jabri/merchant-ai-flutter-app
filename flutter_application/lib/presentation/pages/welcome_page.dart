import 'package:flutter/material.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to", style: TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 10),
            const Text("MerchantAI", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'Serif')),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage())),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9E8F5), 
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Start", style: TextStyle(color: Color(0xFF5D6DA0), fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}