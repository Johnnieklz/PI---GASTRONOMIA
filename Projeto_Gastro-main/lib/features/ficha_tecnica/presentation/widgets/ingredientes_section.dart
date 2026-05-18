import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/ingrediente_entity.dart';
import '../controllers/ficha_tecnica_controller.dart';
import 'dialogs/ingrediente_dialog.dart';

class IngredientesSection extends StatelessWidget {
  const IngredientesSection({super.key});

  void _addIngrediente(BuildContext context) {
    final controller = context.read<FichaTecnicaController>();
    showDialog(
      context: context,
      builder: (_) => IngredienteDialog(
        onAdd: (IngredienteEntity ingrediente) {
          controller.addIngrediente(ingrediente);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FichaTecnicaController>();
    final List<IngredienteEntity> ingredientes = controller.ingredientes;

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => _addIngrediente(context),
          icon: const Icon(Icons.add),
          label: const Text("Adicionar Ingrediente"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        if (ingredientes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Nenhum ingrediente adicionado",
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          )
        else
          ...ingredientes.map(
            (IngredienteEntity item) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.nome,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${item.quantidade} ${item.unidade} | FC: ${item.fatorCorrecao}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'R\$ ${item.custoTotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: () => controller.removeIngrediente(item),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}