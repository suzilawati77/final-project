import 'package:flutter/material.dart';

import '../data/app_repository.dart';
import '../models/user.dart';
import '../widgets/app_text_field.dart';
import 'book_list_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _icController = TextEditingController();
  final _positionController = TextEditingController();
  final _departmentController = TextEditingController();

  String? _nameError;
  String? _icError;
  String? _positionError;
  String? _departmentError;

  @override
  void dispose() {
    _nameController.dispose();
    _icController.dispose();
    _positionController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  String? _validateIc(String value) {
    if (value.isEmpty) return 'Sila isi No. IC';
    if (!RegExp(r'^\d{12}$').hasMatch(value)) return 'No. IC mesti 12 digit angka';
    return null;
  }

  void _submit() {
    final name = _nameController.text.trim();
    final ic = _icController.text.trim();
    final position = _positionController.text.trim();
    final department = _departmentController.text.trim();

    setState(() {
      _nameError = name.isEmpty ? 'Sila isi nama' : null;
      _icError = _validateIc(ic);
      _positionError = position.isEmpty ? 'Sila isi jawatan' : null;
      _departmentError = department.isEmpty ? 'Sila isi bahagian' : null;
    });

    final hasError = _nameError != null ||
        _icError != null ||
        _positionError != null ||
        _departmentError != null;
    if (hasError) return;

    AppRepository.instance.currentUser = User(
      id: ic,
      name: name,
      icNumber: ic,
      position: position,
      department: department,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const BookListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pendaftaran Pengguna')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sistem Pinjaman Buku KPT',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'Sila lengkapkan maklumat anda sebelum meminjam buku.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Nama',
              hint: 'Contoh: Ahmad bin Ali',
              controller: _nameController,
              errorText: _nameError,
            ),
            AppTextField(
              label: 'No. IC',
              hint: '12 digit tanpa tanda sengkang',
              controller: _icController,
              errorText: _icError,
              keyboardType: TextInputType.number,
              maxLength: 12,
            ),
            AppTextField(
              label: 'Jawatan',
              hint: 'Contoh: Penolong Pegawai Teknologi Maklumat',
              controller: _positionController,
              errorText: _positionError,
            ),
            AppTextField(
              label: 'Bahagian',
              hint: 'Contoh: Bahagian Pengurusan Maklumat',
              controller: _departmentController,
              errorText: _departmentError,
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _submit,
              child: const Text('Hantar'),
            ),
          ],
        ),
      ),
    );
  }
}
