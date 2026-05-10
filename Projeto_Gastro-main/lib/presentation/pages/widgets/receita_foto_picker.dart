import 'dart:io';

import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';

class ReceitaFotoPicker extends StatelessWidget {
  final File? imagemReceita;
  final VoidCallback onTap;

  const ReceitaFotoPicker({
    super.key,
    required this.imagemReceita,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.border,
          ),
          image: imagemReceita != null
              ? DecorationImage(
                  image: FileImage(imagemReceita!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imagemReceita == null
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.08),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 42,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Adicionar foto da receita",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Clique para selecionar uma imagem",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}