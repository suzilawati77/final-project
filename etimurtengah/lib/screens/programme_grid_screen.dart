// lib/screens/programme_grid_screen.dart
import 'package:flutter/material.dart';

import '../data/sample_programmes.dart';
import '../theme.dart';

class ProgrammeGridScreen extends StatelessWidget {
  const ProgrammeGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tawaran Pengajian eTT')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.95,
        ),
        itemCount: sampleProgrammes.length,
        itemBuilder: (context, index) {
          final p = sampleProgrammes[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.flagEmoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 4),
                  Text(
                    p.universityName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    p.fieldOfStudy,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    '${p.quotaSeats} tempat',
                    style: const TextStyle(color: KptTheme.navy, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}