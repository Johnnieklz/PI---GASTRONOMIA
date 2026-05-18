import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/constants/ficha_categoria_constants.dart';
import '../../../domain/validators/ficha_tecnica_validator.dart';
import '../../controllers/ficha_tecnica_controller.dart';

import '../inputs/ficha_input.dart';
import '../nivel_dificuldade_selector.dart';

class InformacoesBasicasSection extends StatelessWidget {
  const InformacoesBasicasSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FichaTecnicaController>();

    return Column(
      children: [
        FichaInput(
          label: "Nome",
          controller: controller.nomeController,
          validator: FichaTecnicaValidator.validarNome,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            menuMaxHeight: 300,
            value: controller.categoriaSelecionada,
            validator: FichaTecnicaValidator.validarCategoria,
            decoration: const InputDecoration(
              hintText: "Categoria",
            ),
            items: FichaCategoriaConstants.categorias.map((categoria) {
              return DropdownMenuItem(
                value: categoria.value,
                child: Text(categoria.label),
              );
            }).toList(),
            onChanged: controller.setCategoria,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: FichaInput(
                label: "Tempo (min)",
                controller: controller.tempoController,
                isNumber: true,
                validator: FichaTecnicaValidator.validarTempo,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FichaInput(
                label: "Porções",
                controller: controller.porcoesController,
                isNumber: true,
                validator: FichaTecnicaValidator.validarPorcoes,
              ),
            ),
          ],
        ),
        NivelDificuldadeSelector(
          nivelSelecionado: controller.nivelSelecionado,
          onChanged: controller.setNivel,
        ),
        FichaInput(
          label: "Margem de lucro (%)",
          controller: controller.lucroController,
          isNumber: true,
          validator: FichaTecnicaValidator.validarLucro,
        ),
      ],
    );
  }
}