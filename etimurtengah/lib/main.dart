// lib/main.dart — STATUS AKHIR HARI 1 (titik permulaan Hari 2)
import 'package:flutter/material.dart';
import 'models/programme.dart';
import 'data/sample_programmes.dart';
import '../widgets/programme_banner.dart';
import '../screens/layout_playground_screen.dart';
import 'theme.dart';
import 'widgets/programme_card.dart'; // guna semula CategoryPill
import 'screens/home_screen.dart';
import 'screens/programme_grid_screen.dart';

void main() {
  runApp(const LabHari1App());
}

class LabHari1App extends StatelessWidget {
  const LabHari1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab Hari 1-2',
      debugShowCheckedModeBanner: false,
      theme: KptTheme.light,      // tema navy + emas
      //home: const ProgrammeGridScreen()
      home: const HomeScreen()
         // skrin kekal aplikasi
    );
  }
}

// ── ProgrammeInfoCard & SavedProgrammeCounter (Hari 1) ──────────
// ... (kekalkan kedua-dua class ini di bawah sekali fail, tidak
//      diubah hari ini — kita akan TUKAR body: di atas beberapa
//      kali sepanjang lab ini, tetapi class-class ini kekal wujud
//      sebagai rujukan/ujian).
// ── 4.5 — Kad sebagai widget sendiri ──────────────────
class ProgrammeInfoCard extends StatelessWidget {
  const ProgrammeInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🇪🇬  Universiti Al-Azhar',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A2B5C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Kaherah (Cairo), Mesir',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          const Text('Bidang: Perubatan (Medicine)'),
          const SizedBox(height: 4),
          const Text('Anggaran yuran: RM23,000/tahun'),
          const SizedBox(height: 4),
          const Text('Kuota: 40 tempat  ·  Pengambilan: September'),
        ],
      ),
    );
  }
}
// ── 5.1 — Rangka StatefulWidget ───────────────────────
class SavedProgrammeCounter extends StatefulWidget {
  const SavedProgrammeCounter({super.key});

  @override
  State<SavedProgrammeCounter> createState() => _SavedProgrammeCounterState();
}

class _SavedProgrammeCounterState extends State<SavedProgrammeCounter> {
  // ╔══════════════════════════════════════════════════╗
  // ║  5.2 — State (data yang berubah) masuk DI SINI   ║
  // ╚══════════════════════════════════════════════════╝

  // ╔══════════════════════════════════════════════════╗
  // ║  5.3 — Kaedah pengubah state masuk DI SINI       ║
  // ╚══════════════════════════════════════════════════╝

  @override
  Widget build(BuildContext context) {
    // 👈 5.4 — Ganti baris di bawah dengan UI sebenar
    return const SizedBox.shrink();
  }
}

class ProgrammeSummaryRow extends StatelessWidget {
  const ProgrammeSummaryRow({super.key, required this.programme});

  final Programme programme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
            child: Row(
        children: [
          Expanded(
            child: Text(
              programme.universityName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(' — ${programme.city}, ${programme.countryLabel}'),
        ],
      ),
    );
  }
}
