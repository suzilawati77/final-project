import 'package:flutter/material.dart';

import 'screens/registration_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const KptBookLoanApp());
}

class KptBookLoanApp extends StatelessWidget {
  const KptBookLoanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Pinjaman Buku KPT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: const RegistrationScreen(),
    );
  }
}
