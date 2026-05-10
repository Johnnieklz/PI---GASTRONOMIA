import 'dart:io';

import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../models/ingrediente.dart';

import 'ficha_input.dart';
import 'ingredientes_section.dart';
import 'nivel_dificuldade_selector.dart';
import 'receita_foto_picker.dart';
import 'resumo_financeiro.dart';
import 'section_title.dart';

class FichaFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final File? imagemReceita;
  final VoidCallback onSelecionarImagem;

  final TextEditingController nomeController;
  final TextEditingController categoriaController;
  final TextEditingController tempoController;
  final TextEditingController porcoesController;
  final TextEditingController modoPreparoController;
  final TextEditingController lucroController;

  final String nivelSelecionado;
  final Function(String) onNivelChanged;

  final double custoTotal;
  final double custoPorPorcao;
  final double precoSugerido;
  final double foodCost;

  final List<Ingrediente> ingredientes;

  final VoidCallback onAddIngrediente;
  final Function(Ingrediente) onRemoveIngrediente;

  final Widget button;

  const FichaFormCard({
    super.key,
    required this.formKey,

    required this.imagemReceita,
    required this.onSelecionarImagem,

    required this.nomeController,
    required this.categoriaController,
    required this.tempoController,
    required this.porcoesController,
    required this.modoPreparoController,
    required this.lucroController,

    required this.nivelSelecionado,
    required this.onNivelChanged,

    required this.custoTotal,
    required this.custoPorPorcao,
    required this.precoSugerido,
    required this.foodCost,

    required this.ingredientes,

    required this.onAddIngrediente,
    required this.onRemoveIngrediente,

    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: AppColors.borderLight,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Form(
        key: formKey,

        child: Column(
          children: [
            ReceitaFotoPicker(
              imagemReceita: imagemReceita,
              onTap: onSelecionarImagem,
            ),

            const SizedBox(height: 20),

            FichaInput(
              label: "Nome",
              controller: nomeController,
            ),

            FichaInput(
              label: "Categoria",
              controller: categoriaController,
            ),

            FichaInput(
              label: "Tempo (min)",
              controller: tempoController,
              isNumber: true,
            ),

            FichaInput(
              label: "Porções",
              controller: porcoesController,
              isNumber: true,
            ),

            NivelDificuldadeSelector(
              nivelSelecionado: nivelSelecionado,
              onChanged: onNivelChanged,
            ),

            FichaInput(
              label: "Margem de lucro (%)",
              controller: lucroController,
              isNumber: true,
            ),

            ResumoFinanceiro(
              custoTotal: custoTotal,
              custoPorPorcao: custoPorPorcao,
              precoSugerido: precoSugerido,
              foodCost: foodCost,
              ingredientesCount: ingredientes.length,
              nivelSelecionado: nivelSelecionado,
            ),

            const SectionTitle(
              title: "Ingredientes",
            ),

            IngredientesSection(
              ingredientes: ingredientes,
              onAdd: onAddIngrediente,
              onRemove: onRemoveIngrediente,
            ),

            const SectionTitle(
              title: "Modo de preparo",
            ),

            FichaInput(
              label: "Descreva...",
              controller: modoPreparoController,
              maxLines: 4,
            ),

            const SizedBox(height: 20),

            button,
          ],
        ),
      ),
    );
  }
}