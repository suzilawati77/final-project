// lib/screens/lab_hari4_screen.dart  —  FAIL PERMULAAN LATIHAN 5
import 'package:flutter/material.dart';

import '../models/application.dart';
import '../models/programme.dart';
import '../services/programme_service.dart';
import '../widgets/programme_card.dart';
import 'programme_detail_screen.dart';

enum LoadState { idle, loading, loaded, error }

class LabHari4Screen extends StatefulWidget {
  const LabHari4Screen({super.key});

  @override
  State<LabHari4Screen> createState() => _LabHari4ScreenState();
}

class _LabHari4ScreenState extends State<LabHari4Screen> {
  final _service = ProgrammeService();

  LoadState _state = LoadState.idle;
  List<Programme> _programmes = [];

  Future<void> _load() async {
    setState(() => _state = LoadState.loading);
    try {
      final data = await _service.fetchProgrammes();
      setState(() {
        _programmes = data;
        _state = LoadState.loaded;
      });
    } catch (_) {
      setState(() => _state = LoadState.error);
    }
  }

  Future<void> _hantarContohPermohonan() async {
    final contoh = Application(
      id: 'LAB-${DateTime.now().millisecondsSinceEpoch}',
      fullName: 'Pelajar Contoh',
      icNumber: '000000-00-0000',
      email: 'pelajar@example.com',
      phoneNumber: '0123456789',
      academicCategory: EntryCategory.spm,
      academicSummary: 'SPM 2025 — 8A',
      country: 'Egypt',
      fieldOfStudy: 'Perubatan (Medicine)',
      universityChoiceIds: const ['ETT-001'],
    );
    
    final berjaya = await _service.submitApplication(contoh);
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          berjaya
              ? 'Permohonan contoh berjaya dihantar'
              : 'Gagal hantar permohonan contoh',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Lab Hari 4 — Tawaran eTT (API)'),
        actions: [
          IconButton(
            onPressed: _hantarContohPermohonan,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case LoadState.idle:
      case LoadState.loading:
        return const Center(child: CircularProgressIndicator());
      case LoadState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              const Text('Gagal memuat data program.'),
              const SizedBox(height: 12),
              FilledButton(onPressed: _load, child: const Text('Cuba Lagi')),
            ],
          ),
        );
      case LoadState.loaded:
        return RefreshIndicator(
          onRefresh: _load,
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: _programmes.length,
            itemBuilder: (context, index) {
              final p = _programmes[index];
              return ProgrammeCard(
                programme: p,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProgrammeDetailScreen(programme: p),
                  ),
                ),
              );
            },
          ),
        );
    }
  }
}