// lib/screens/layout_playground_screen.dart
import 'package:flutter/material.dart';

import '../../data/sample_programmes.dart';
import '../../widgets/programme_banner.dart';

class LayoutPlaygroundScreen extends StatelessWidget {
  const LayoutPlaygroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playground Layout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          
          //          // ── 3.2 — Satu ProgrammeBanner bagi setiap program ──
          for (final p in sampleProgrammes)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ProgrammeBanner(programme: p),
            ),
            //║  3.2 — Senarai banner masuk DI SINI           ║
          // ╚═══════════════════════════════════════════════╝
        ],
      ),
    );
  }
}