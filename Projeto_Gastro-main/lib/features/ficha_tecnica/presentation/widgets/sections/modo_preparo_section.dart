import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../section_title.dart';
import '../inputs/ficha_input.dart';
import '../../controllers/ficha_tecnica_controller.dart';

class ModoPreparoSection extends StatelessWidget {
  const ModoPreparoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<FichaTecnicaController>();

    return Column(
      children: [
        const SectionTitle(
          title: "Modo de preparo",
        ),
        FichaInput(
          label: "Descreva...",
          controller: controller.modoPreparoController,
          maxLines: 6,
        ),
      ],
    );
  }
}