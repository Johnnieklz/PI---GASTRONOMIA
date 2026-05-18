import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class NivelDificuldadeSelector extends StatelessWidget {
  final String nivelSelecionado;
  final ValueChanged<String> onChanged;

  const NivelDificuldadeSelector({
    super.key,
    required this.nivelSelecionado,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final niveis = ["Fácil", "Médio", "Difícil"];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nível de dificuldade",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: niveis.map((nivel) {
              final selected = nivelSelecionado == nivel;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(nivel),

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 16),

                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : const Color(0xFFF4F6F8),

                      borderRadius: BorderRadius.circular(14),

                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.border,
                        width: 1.5,
                      ),

                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.20),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),

                    child: Center(
                      child: Text(
                        nivel,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          if (nivelSelecionado.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8, left: 4),
              child: Text(
                "Selecione um nível",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}