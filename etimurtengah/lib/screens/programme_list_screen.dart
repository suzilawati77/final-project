// lib/screens/programme_list_screen.dart
import 'package:flutter/material.dart';

import '../data/sample_programmes.dart';
import '../widgets/programme_card.dart';

class ProgrammeListScreen extends StatelessWidget {
  const ProgrammeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
            // EKSPERIMEN sementara — GANTI itemCount & indeks data untuk uji 1000 item
      itemCount: 20,
      itemBuilder: (context, index) {
        final p = sampleProgrammes[index % sampleProgrammes.length];
        print('Kad dibina untuk indeks: $index');
        return ProgrammeCard(programme: p);
      },
    );
  }
}