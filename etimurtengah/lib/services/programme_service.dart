// lib/services/programme_service.dart
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/programme.dart';
import '../data/sample_programmes.dart';
import '../models/application.dart';

class ProgrammeService {
  ProgrammeService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  // PEMBETULAN 1: Seragamkan ejaan (gunakan 'u' kecil)
  static const String _baseUrl =
      'https://raw.githubusercontent.com/suzilawati77/api-mock-flutter/refs/heads/main/programmes.json';

  Future<List<Programme>> fetchProgrammes() async {
    try {
      final response = await _client
          // Guna _baseUrl yang telah dibetulkan
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((e) => Programme.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return _fallback();
    } catch (_) {
      return _fallback();
    }
  }

  Future<bool> submitApplication(Application application) async {
    try {
      final response = await _client
          .post(
            Uri.parse(
              '$_baseUrl/applications',
            ), // Sekarang padan dengan yang di atas
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(application.toJson()),
          )
          .timeout(const Duration(seconds: 8));
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  // PEMBETULAN 2: Buang komen (uncomment) fungsi ini
  Future<List<Programme>> _fallback() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return sampleProgrammes;
  }

  void dispose() => _client.close();
}
