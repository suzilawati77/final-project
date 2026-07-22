// lib/screens/programme_list_screen.dart
import 'package:flutter/material.dart';

import '../data/sample_programmes.dart';
import '../widgets/programme_card.dart';
import 'programme_detail_screen.dart';

class ProgrammeListScreen extends StatelessWidget {
  const ProgrammeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: sampleProgrammes.length,
      itemBuilder: (context, index) {
        final p = sampleProgrammes[index];
                      return ProgrammeCard(
                programme: p,
                onTap: index == 0
                    ? () => Navigator.of(context).pushNamed('/detail', arguments: p)
                    : () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProgrammeDetailScreen(programme: p),
                          ),
                        ),
              );
      },
    );
  }
}
