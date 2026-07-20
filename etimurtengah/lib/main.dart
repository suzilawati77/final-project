import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Sistem eTimurTengah', style: TextStyle(
      fontWeight: FontWeight.bold,
    ),), centerTitle: true,),
        body: Container(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    color: const Color(0xFF1A2B5C),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: const Color.fromARGB(255, 56, 6, 236)),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text(
        '🇪🇬  Universiti Al-Azhar',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A2B5C)),
      ),
      SizedBox(height: 4),
      Text('Kaherah (Cairo), Mesir', style: TextStyle(color: Colors.yellow)),
      SizedBox(height: 12),
      Text('Bidang: Perubatan (Medicine)', style: TextStyle(color: Colors.white)),
      SizedBox(height: 4),
      Text('Anggaran yuran: RM23,000/tahun (ilustrasi)', style: TextStyle(color: Colors.white)),
      SizedBox(height: 4),
      Text('Kuota (ilustrasi): 40 tempat · Pengambilan: September', style: TextStyle(color: Colors.white)),
    ],
  ),
)
      ),
    );
  }
}