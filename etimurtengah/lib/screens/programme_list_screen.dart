// lib/screens/programme_list_screen.dart
import 'package:flutter/material.dart';

import '../data/sample_programmes.dart';
import '../widgets/programme_card.dart';
import 'programme_detail_screen.dart';

class ProgrammeListScreen extends StatelessWidget {
  final String? countryFilter;
  const ProgrammeListScreen({super.key, this.countryFilter});

  @override
  Widget build(BuildContext context) {
    final items = countryFilter == null
        ? sampleProgrammes
        : sampleProgrammes.where((p) => p.country == countryFilter).toList();

    if (items.isEmpty) {
      return const Center(child: Text('Tiada tawaran untuk negara ini.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final p = items[index];
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
