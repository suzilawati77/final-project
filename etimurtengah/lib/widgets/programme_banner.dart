// lib/widgets/programme_banner.dart
import 'package:flutter/material.dart';
import '../models/programme.dart';
import '../theme.dart';
import 'programme_card.dart'; // guna semula CategoryPill
 // guna semula CategoryPill

class ProgrammeBanner extends StatelessWidget {
  const ProgrammeBanner({super.key, required this.programme});

  final Programme programme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── 2.1 — Lapisan bawah: kotak navy + bendera di tengah ──
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: KptTheme.navy,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              programme.flagEmoji,
              style: const TextStyle(fontSize: 56),
            ),
          ),
        ),
        // ── 2.2 — Universiti & bidang, dilabuhkan bawah-kiri ──
        Positioned(
          left: 16,
          bottom: 14,
           right: 90, // elak teks tersorok di bawah pill kategori (2.4b)
          child: Text(
            '${programme.universityName}\n${programme.fieldOfStudy}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        // ╔═══════════════════════════════════════════════════╗
        // ║  2.2 — Positioned nama universiti masuk DI SINI   ║
        // ╚═══════════════════════════════════════════════════╝
        // ── 2.3 — Pill kategori, ditindan di sudut kanan atas ──
        Positioned(
          top: 12,
          right: 12,
          child: CategoryPill(category: programme.category),
        ),
        // ╔═══════════════════════════════════════════════════╗
        // ║  2.3 — Positioned pill kategori masuk DI SINI     ║
        // ╚═══════════════════════════════════════════════════╝
      ],
    );
  }
}