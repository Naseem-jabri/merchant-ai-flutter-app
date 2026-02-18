import 'package:flutter/material.dart';
import 'home_page.dart';
import '../../services/api_service.dart';
import '../../global_data.dart'; // ضروري جداً لتحديث الأسماء

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // دالة تسجيل الدخول والربط مع السيرفر
  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final response = await ApiService().login(_emailController.text, _passwordController.text);
      
      if (response.containsKey('name')) {
        // --- الربط النهائي الذي سألتِ عنه هنا ---
        setState(() {
          currentUserName = response['name'];   // حفظ الاسم القادم من الداتاسيت
          currentUserEmail = response['email']; // حفظ الإيميل القادم من الداتاسيت
        });

        // الانتقال لصفحة الهوم
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const HomePage())
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid Email or Password"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Python Server is not running")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5D6DA0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Icon(Icons.lock_person, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text("Login", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _buildTextField(_emailController, "Email", Icons.email, false),
            const SizedBox(height: 20),
            _buildTextField(_passwordController, "Password", Icons.lock, true),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9E8F5),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator() 
                : const Text("Login", style: TextStyle(color: Color(0xFF5D6DA0), fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => _showSignUpDialog(context),
              child: const Text("Don't have an account? Sign Up", style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
            ),
          ],
        ),
      ),
    );
  }

  // تحسين شكل خانات الإدخال
  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, bool isPass) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF5D6DA0)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  // نافذة تسجيل حساب جديد (Sign Up)
  void _showSignUpDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Create New Account", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name", icon: Icon(Icons.person))),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email", icon: Icon(Icons.email))),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: "Password", icon: Icon(Icons.lock)), obscureText: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty && emailCtrl.text.isNotEmpty) {
                await ApiService().signUp(nameCtrl.text, emailCtrl.text, passCtrl.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account Created! You can login now.")));
              }
            }, 
            child: const Text("Register")
          ),
        ],
      ),
    );
  }
}