import 'package:flutter/material.dart';
import 'alerts_page.dart';
import 'profile_page.dart'; // تأكدي من إنشاء هذا الملف
import '../../services/api_service.dart'; 
import '../../global_data.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _commentController = TextEditingController();
  String _analysisResult = "Analysis results will appear here";
  bool _isLoading = false;

  Future<void> _handleAnalysis() async {
    if (_commentController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _analysisResult = "Analyzing... please wait";
    });

    try {
      // استدعاء السيرفر (بايثون)
      final result = await ApiService().analyzeComment(_commentController.text);
      
      // استخراج النتيجة (إيجابي أو سلبي)
      String label = result['label'] ?? "Unknown";

      setState(() {
        _analysisResult = "Result: $label";
        
        // إضافة للسجل ليظهر في صفحة التنبيهات مع النسبة
        analysisHistory.insert(0, {
          'text': _commentController.text,
          'label': label,
          'percent': "98%", 
        });
        
        _isLoading = false;
        _commentController.clear();
      });
    } catch (e) {
      setState(() {
        _analysisResult = "Error: Python server not responding";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5D6DA0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // أيقونة التنبيهات
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlertsPage()),
            ),
          ),
          // أيقونة الشخص (البروفايل)
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProfilePage()), // تم حذف const من هنا
  );
},
child: CircleAvatar( // تأكدي من عدم وجود const هنا أيضاً
  backgroundColor: Colors.white,
  child: Icon(Icons.person, color: Color(0xFF5D6DA0)),
),


            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Analyze your customers'\ncomments immediately",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Enter customer comment here...",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 150,
              height: 45,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleAnalysis,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD9E8F5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("Analysis", style: TextStyle(color: Color(0xFF5D6DA0), fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              height: 220,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _analysisResult.contains("Positive") ? Icons.sentiment_very_satisfied : 
                    _analysisResult.contains("Negative") ? Icons.sentiment_very_dissatisfied : Icons.analytics_outlined,
                    size: 60,
                    color: _analysisResult.contains("Positive") ? Colors.green : 
                           _analysisResult.contains("Negative") ? Colors.red : Colors.grey,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _analysisResult, 
                    textAlign: TextAlign.center, 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}