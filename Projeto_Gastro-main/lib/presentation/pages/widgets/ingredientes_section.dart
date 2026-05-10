import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../models/ingrediente.dart';

class IngredientesSection extends StatelessWidget {
  final List<Ingrediente> ingredientes;
  final VoidCallback onAdd;
  final Function(Ingrediente item) onRemove;

  const IngredientesSection({
    super.key,
    required this.ingredientes,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text("Adicionar Ingrediente"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
          ),
        ),

        const SizedBox(height: 10),

        ...ingredientes.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
              ),
            ),

            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "${item.quantidade} ${item.unidade} | FC: ${item.fatorCorrecao}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  "R\$ ${item.custoTotal.toStringAsFixed(2)}",
                ),

                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 18,
                    color: Colors.red,
                  ),
                  onPressed: () => onRemove(item),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}