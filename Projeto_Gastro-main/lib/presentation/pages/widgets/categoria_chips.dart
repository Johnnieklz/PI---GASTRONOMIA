import 'package:flutter/material.dart';

class CategoriaChips extends StatelessWidget {
  final List<String> categorias;
  final String categoriaSelecionada;
  final ValueChanged<String> onSelecionada;

  const CategoriaChips({
    super.key,
    required this.categorias,
    required this.categoriaSelecionada,
    required this.onSelecionada,
  });

  IconData _iconePara(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'todos':
        return Icons.category_rounded;
      case 'fitness':
        return Icons.monitor_heart_rounded;
      case 'jantar':
        return Icons.dinner_dining_rounded;
      case 'forno':
        return Icons.local_fire_department_rounded;
      case 'cozinha':
        return Icons.soup_kitchen_rounded;
      case 'almoço':
        return Icons.rice_bowl_rounded;
      case 'sobremesa':
        return Icons.cake_rounded;
      case 'bebida':
        return Icons.local_cafe_rounded;
      default:
        return Icons.restaurant_menu_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categorias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categorias[index];
          final isSelected = cat == categoriaSelecionada;

          return GestureDetector(
            onTap: () => onSelecionada(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF004C94)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF004C94)
                      : Colors.grey.shade200,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color:
                              const Color(0xFF004C94).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconePara(cat),
                    size: 15,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                  const SizedBox(width: 5),
                  Text(
                    cat,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}