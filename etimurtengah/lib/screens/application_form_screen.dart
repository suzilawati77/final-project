// lib/screens/application_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/application.dart';
import '../models/programme.dart';
import '../utils/validators.dart';
import '../data/document_checklist.dart';
import '../data/sample_programmes.dart';

class ApplicationFormScreen extends StatefulWidget {
  const ApplicationFormScreen({super.key, required this.programme});

  final Programme programme;

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  // ── 4.1 — Kunci borang ────────────────────────────
  final _formKey = GlobalKey<FormState>();

  // ── 4.2 — Input Controller ─────────────────────────
  final _nameCtrl = TextEditingController();
  final _icCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _academicCtrl = TextEditingController();

  final Map<String, bool> _documents = {};

  EntryCategory? _academicCategory;
  late String _country; // 1 negara — peraturan eTT
  late String _fieldOfStudy; // 1 bidang — peraturan eTT
  String? _choice1;
  String? _choice2;
  String? _choice3;

  @override
  void initState() {
    super.initState(); // WAJIB baris PERTAMA
    // ── 4.7 — Nilai awal daripada tawaran yang dipilih ─
    _country = widget.programme.country;
    _fieldOfStudy = widget.programme.fieldOfStudy;
    _choice1 = widget.programme.id;
    for (final doc in ettDocumentChecklist) {
      _documents[doc] = false;
    }
  }

  List<String> get _countries =>
      {for (final p in sampleProgrammes) p.country}.toList();

  String _countryLabel(String country) => switch (country) {
    'Egypt' => '🇪🇬 Mesir',
    'Morocco' => '🇲🇦 Maghribi',
    _ => country,
  };

  List<String> get _fields => {
    for (final p in sampleProgrammes)
      if (p.country == _country) p.fieldOfStudy,
  }.toList();

  List<Programme> get _choiceProgrammes => sampleProgrammes
      .where((p) => p.country == _country && p.fieldOfStudy == _fieldOfStudy)
      .toList();

  void _onCountryChanged(String? value) {
    if (value == null) return;
    setState(() {
      _country = value;
      final fields = _fields;
      _fieldOfStudy = fields.isNotEmpty ? fields.first : '';
      _resetChoices(); // pilihan universiti lama tidak lagi sah
    });
  }

  void _onFieldChanged(String? value) {
    if (value == null) return;
    setState(() {
      _fieldOfStudy = value;
      _resetChoices();
    });
  }

  void _resetChoices() {
    final programmes = _choiceProgrammes;
    _choice1 = programmes.isNotEmpty ? programmes.first.id : null;
    _choice2 = null;
    _choice3 = null;
  }

  @override
  void dispose() {
    // ── 4.3 — Bersihkan setiap Controller ─────────────
    _nameCtrl.dispose();
    _icCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _academicCtrl.dispose();
    super.dispose(); // WAJIB baris TERAKHIR
  }

  @override
  Widget build(BuildContext context) {
    // SAYA TELAH UNCOMMENT BARIS INI SUPAYA PILIHAN 1, 2, 3 BERFUNGSI
    final choiceProgrammes = _choiceProgrammes;

    return Scaffold(
      appBar: AppBar(title: const Text('Borang Permohonan eTT')),
      body: Form(
        key: _formKey,
        // PENTING: SingleChildScrollView + Column, BUKAN ListView.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Maklumat Pemohon',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // ── 4.4 — Nama Penuh ──────────────────────
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nama Penuh'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nama diperlukan' : null,
              ),
              const SizedBox(height: 14),

              // ── 4.5 — No. Kad Pengenalan ──────────────
              TextFormField(
                controller: _icCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'No. Kad Pengenalan',
                  hintText: '051231-14-5678',
                ),
                validator: validateIcNumber,
              ),
              const SizedBox(height: 14),

              // ── 4.6 — Emel, Telefon, Ringkasan Keputusan ──
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Emel'),
                validator: validateEmail,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'No. Telefon',
                  hintText: '0123456789',
                ),
                validator: validatePhoneNumber,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _academicCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ringkasan Keputusan',
                  hintText: 'Cth: SPM 2025 — 9A',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ringkasan keputusan diperlukan'
                    : null,
              ),
              const SizedBox(height: 24),

              const Text(
                'Kelayakan & Pilihan Pengajian',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // ── 4.8 — Kategori Sijil ───────────────────
              DropdownButtonFormField<EntryCategory>(
                initialValue: _academicCategory,
                decoration: const InputDecoration(labelText: 'Kategori Sijil'),
                items: const [
                  DropdownMenuItem(
                    value: EntryCategory.spm,
                    child: Text('SPM'),
                  ),
                  DropdownMenuItem(
                    value: EntryCategory.stam,
                    child: Text('STAM'),
                  ),
                ],
                onChanged: (v) => setState(() => _academicCategory = v),
                validator: (v) =>
                    v == null ? 'Sila pilih kategori sijil' : null,
              ),
              const SizedBox(height: 14),

              Text(
                'Peraturan eTT: 1 negara + 1 bidang setiap permohonan. Anda '
                'boleh menyusun sehingga 3 pilihan universiti dalam bidang itu.',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),

              // ── 4.10 — Negara & Bidang (saling bergantung) ─
              DropdownButtonFormField<String>(
                initialValue: _country,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Negara (satu sahaja)',
                ),
                items: [
                  for (final c in _countries)
                    DropdownMenuItem(value: c, child: Text(_countryLabel(c))),
                ],
                onChanged: _onCountryChanged,
                validator: (v) => v == null ? 'Sila pilih negara' : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _fields.contains(_fieldOfStudy)
                    ? _fieldOfStudy
                    : null,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Bidang (satu sahaja)',
                ),
                items: [
                  for (final f in _fields)
                    DropdownMenuItem(
                      value: f,
                      child: Text(f, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: _onFieldChanged,
                validator: (v) => v == null ? 'Sila pilih bidang' : null,
              ),





              const SizedBox(height: 14),

              // ── 4.12 — Pilihan Universiti 1–3 ──────────
              _ChoiceDropdown(
                label: 'Pilihan 1 (wajib)',
                value: _choice1,
                programmes: choiceProgrammes,
                onChanged: (v) => setState(() => _choice1 = v),
                validator: (v) => v == null ? 'Pilihan 1 diperlukan' : null,
              ),
              const SizedBox(height: 14),
              _ChoiceDropdown(
                label: 'Pilihan 2 (pilihan)',
                value: _choice2,
                programmes: choiceProgrammes,
                includeNone: true,
                onChanged: (v) => setState(() => _choice2 = v),
              ),
              const SizedBox(height: 14),
              _ChoiceDropdown(
                label: 'Pilihan 3 (pilihan)',
                value: _choice3,
                programmes: choiceProgrammes,
                includeNone: true,
                onChanged: (v) => setState(() => _choice3 = v),
              ),

              // 👈 4.14 — TAMBAH senarai semak dokumen SELEPAS BARIS INI

                          const SizedBox(height: 24),
            const Text(
              'Senarai Semak Dokumen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Dalam sistem sebenar, dokumen dimuat naik selepas status LAYAK.',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),

            // ── 4.13 — Senarai semak dokumen ───────────
            for (final doc in ettDocumentChecklist)
              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(doc),
                value: _documents[doc],
                onChanged: (v) => setState(() => _documents[doc] = v ?? false),
              ),

            // 👈 4.15 — TAMBAH butang Hantar SELEPAS BARIS INI
            ],
          ),
        ),
      ),
    );
  }
} // PENUTUP KELAS _ApplicationFormScreenState

// ── 4.11 — Dropdown pilihan universiti (boleh guna semula) ─
// KELAS INI MESTI BERADA DI LUAR (DI BAWAH SEKALI)
class _ChoiceDropdown extends StatelessWidget {
  const _ChoiceDropdown({
    required this.label,
    required this.value,
    required this.programmes,
    required this.onChanged,
    this.validator,
    this.includeNone = false,
  });

  final String label;
  final String? value;
  final List<Programme> programmes;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  /// Jika benar, tambah item "Tiada" bernilai null (untuk pilihan opsional).
  final bool includeNone;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        if (includeNone)
          const DropdownMenuItem<String>(value: null, child: Text('Tiada')),
        for (final p in programmes)
          DropdownMenuItem(
            value: p.id,
            child: Text(
              '${p.universityName} (${p.city})',
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: onChanged,
      validator: validator,
    );
  }
}
