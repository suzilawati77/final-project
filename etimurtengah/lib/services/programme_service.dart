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

  Future<List<Programme>> fetchProgrammes() async {
    try {
      final response = await _client
          .get(Uri.parse(_baseURL))
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

  static const String _baseURL =
      'https://raw.githubusercontent.com/suzilawati77/api-mock-flutter/refs/heads/main/programmes.json';

  Future<bool> submitApplication(Application application) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/applications'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(application.toJson()),
          )
          .timeout(const Duration(seconds: 8));
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  // Future<List<Programme>> _fallback() async {
  //   await Future.delayed(const Duration(milliseconds: 600));
  //   return sampleProgrammes;
  // }

  void dispose() => _client.close();
}
