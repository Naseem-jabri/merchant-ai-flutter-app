import 'package:flutter/material.dart';
import 'package:flutter_application/global_data.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    int total = analysisHistory.length;
    int positiveCount = analysisHistory.where((item) => item['label']!.contains("Positive")).length;
    int negativeCount = analysisHistory.where((item) => item['label']!.contains("Negative")).length;

    return Scaffold(
      backgroundColor: const Color(0xFF5D6DA0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Smart alerts and reports", 
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),

            _buildAlertBox(
              negativeCount >= 1 ? "Attention: $negativeCount Negative feedback detected" : "No major complaints currently", 
              negativeCount >= 1 ? Colors.red : Colors.orange,
              Icons.warning_amber_rounded
            ),

            _buildAlertBox(
              positiveCount >= 1 ? "Great job! $positiveCount Satisfied customers" : "Keep analyzing to see results", 
              positiveCount >= 1 ? Colors.green : Colors.blue,
              Icons.stars_rounded
            ),

            _buildAlertBox("Total Analyses performed: $total", Colors.grey, Icons.analytics_outlined),
            
            const SizedBox(height: 35),
            const Text("Record previous analyses", 
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: analysisHistory.isEmpty 
                ? const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(child: Text("No records yet", style: TextStyle(color: Colors.grey))),
                  )
                : DataTable(
                    columnSpacing: 20,
                    columns: const [
                      DataColumn(label: Text('Text', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Label', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('%', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: analysisHistory.map((item) {
                      return DataRow(cells: [
                        DataCell(SizedBox(width: 80, child: Text(item['text']!, overflow: TextOverflow.ellipsis))),
                        DataCell(Text(item['label']!, style: TextStyle(color: item['label']!.contains('Positive') ? Colors.green : Colors.red))),
                        DataCell(Text(item['percent']!)),
                      ]);
                    }).toList(),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertBox(String text, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 15),
          Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
        ],
      ),
    );
  }
}