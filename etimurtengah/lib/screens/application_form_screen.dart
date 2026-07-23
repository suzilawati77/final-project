import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/document_checklist.dart';
import '../data/sample_programmes.dart';
import '../models/application.dart';
import '../models/programme.dart';
import '../utils/validators.dart';

class ApplicationFormScreen extends StatefulWidget {
  const ApplicationFormScreen({super.key, required this.programme});

  final Programme programme;

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _icCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _academicCtrl = TextEditingController();

  final Map<String, bool> _documents = {};

  EntryCategory? _academicCategory;
  late String _country;
  late String _fieldOfStudy;
  String? _choice1;
  String? _choice2;
  String? _choice3;

  @override
  void initState() {
    super.initState();
    _country = widget.programme.country;
    _fieldOfStudy = widget.programme.fieldOfStudy;
    _choice1 = widget.programme.id;
    for (final doc in ettDocumentChecklist) {
      _documents[doc] = false;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _icCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _academicCtrl.dispose();
    super.dispose();
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
      _resetChoices();
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_academicCategory == null) {
      _snack('Sila pilih kategori sijil (SPM atau STAM).');
      return;
    }
    if (_choice1 == null) {
      _snack('Sila pilih sekurang-kurangnya satu universiti (Pilihan 1).');
      return;
    }

    final choices = <String>[];
    for (final id in [_choice1, _choice2, _choice3]) {
      if (id != null && !choices.contains(id)) choices.add(id);
    }

    final application = Application(
      id: 'ETT-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch}',
      fullName: _nameCtrl.text.trim(),
      icNumber: _icCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
      academicCategory: _academicCategory!,
      academicSummary: _academicCtrl.text.trim(),
      country: _country,
      fieldOfStudy: _fieldOfStudy,
      universityChoiceIds: choices,
      uploadedDocuments: _documents.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList(),
      status: ApplicationStatus.submitted,
      submittedAt: DateTime.now(),
    );

    _snack('Permohonan ${application.id} berjaya dihantar!');
    Navigator.of(context).pop(application);
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final choiceProgrammes = _choiceProgrammes;

    return Scaffold(
      appBar: AppBar(title: const Text('Borang Permohonan eTT')),
      body: Form(
        key: _formKey,
        // PENTING: guna SingleChildScrollView + Column, BUKAN ListView.
        // ListView bersifat "malas" — medan yang ditatal keluar skrin akan
        // dilupuskan dan TERKELUAR daftar Form, menyebabkan validate()
        // melangkau medan itu (borang kosong boleh "lulus" validation).
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
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nama Penuh'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nama diperlukan' : null,
              ),
              const SizedBox(height: 14),
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
                validator: validateAcademicSummary,
              ),
              const SizedBox(height: 24),
              const Text(
                'Kelayakan & Pilihan Pengajian',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
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
              for (final doc in ettDocumentChecklist)
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(doc),
                  value: _documents[doc],
                  onChanged: (v) =>
                      setState(() => _documents[doc] = v ?? false),
                ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send),
                label: const Text('Hantar Permohonan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
