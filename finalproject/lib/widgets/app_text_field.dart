import 'package:flutter/material.dart';

/// Medan borang dengan label dan paparan ralat merah di bawahnya.
class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? errorText;
  final TextInputType keyboardType;
  final int? maxLength;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint = '',
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            decoration: InputDecoration(
              hintText: hint,
              counterText: '',
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }
}
