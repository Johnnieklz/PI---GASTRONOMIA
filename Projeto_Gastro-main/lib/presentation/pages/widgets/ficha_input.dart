import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class FichaInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isNumber;
  final int maxLines;

  const FichaInput({
    super.key,
    required this.label,
    required this.controller,
    this.isNumber = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,

        keyboardType:
            isNumber ? TextInputType.number : TextInputType.text,

        maxLines: maxLines,

        validator: (v) {
          if (v == null || v.isEmpty) {
            return "Obrigatório";
          }
          return null;
        },

        decoration: InputDecoration(
          labelText: label,

          filled: true,
          fillColor: const Color(0xFFF9FAFB),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}