import 'package:flutter/material.dart';

/// Widget demo — bukan sebahagian aliran permohonan sebenar.
/// Tujuannya SEMATA-MATA menunjukkan susunan initState -> build -> dispose.
class LifecycleDemo extends StatefulWidget {
  const LifecycleDemo({super.key});

  @override
  State<LifecycleDemo> createState() => _LifecycleDemoState();
}

class _LifecycleDemoState extends State<LifecycleDemo> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    debugPrint('[LifecycleDemo] initState() — dipanggil SEKALI sahaja');
  }

  void _increment() => setState(() => _count++);
  void _reset() => setState(() => _count = 0);

  @override
  Widget build(BuildContext context) {
    debugPrint('[LifecycleDemo] build() — _count = $_count');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Kiraan: $_count', style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _increment,
          onLongPress: _reset,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.blue.shade100,
            child: const Text('Tekan (+1) · Tekan Lama (reset)'),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _increment,
          child: const Text('Tambah (Button)'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    debugPrint(
      '[LifecycleDemo] dispose() — dipanggil SEKALI sahaja, skrin ditutup',
    );
    super.dispose();
  }
}
