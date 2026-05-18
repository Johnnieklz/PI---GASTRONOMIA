import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../controllers/ficha_tecnica_controller.dart';

import '../receita_foto_picker.dart';
import 'resumo_financeiro.dart';
import '../ingredientes_section.dart';
import '../section_title.dart';
import '../sections/informacoes_basicas_section.dart';
import '../sections/modo_preparo_section.dart';

class FichaFormCard extends StatefulWidget {
  const FichaFormCard({super.key});

  @override
  State<FichaFormCard> createState() => _FichaFormCardState();
}

class _FichaFormCardState extends State<FichaFormCard> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    final controller = context.read<FichaTecnicaController>();
    
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (controller.nivelSelecionado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione o nível de dificuldade")),
      );
      return;
    }

    try {
      await controller.submit();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Salvo com sucesso")),
      );
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao salvar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FichaTecnicaController>();
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: isWide ? _buildWideLayout(controller) : _buildMobileLayout(controller),
      ),
    );
  }

  Widget _buildMobileLayout(FichaTecnicaController controller) {
    return Column(
      children: [
        ReceitaFotoPicker(
          imagemReceita: controller.imagemReceita,
          onTap: controller.selecionarImagem,
        ),
        const SizedBox(height: 20),
        const InformacoesBasicasSection(),
        ResumoFinanceiro(
          custoTotal: controller.custoTotal,
          custoPorPorcao: controller.custoPorPorcao,
          precoSugerido: controller.precoSugerido,
          foodCost: controller.foodCost,
          ingredientesCount: controller.ingredientes.length,
          nivelSelecionado: controller.nivelSelecionado,
        ),
        const SectionTitle(title: "Ingredientes"),
        const IngredientesSection(),
        const ModoPreparoSection(),
        const SizedBox(height: 32),
        _buildSubmitButton(controller),
      ],
    );
  }

  Widget _buildWideLayout(FichaTecnicaController controller) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Basic Info & Photo
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  ReceitaFotoPicker(
                    imagemReceita: controller.imagemReceita,
                    onTap: controller.selecionarImagem,
                  ),
                  const SizedBox(height: 20),
                  const InformacoesBasicasSection(),
                ],
              ),
            ),
            const SizedBox(width: 40),
            // Right Column: Ingredients & Financial
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResumoFinanceiro(
                    custoTotal: controller.custoTotal,
                    custoPorPorcao: controller.custoPorPorcao,
                    precoSugerido: controller.precoSugerido,
                    foodCost: controller.foodCost,
                    ingredientesCount: controller.ingredientes.length,
                    nivelSelecionado: controller.nivelSelecionado,
                  ),
                  const SectionTitle(title: "Ingredientes"),
                  const IngredientesSection(),
                  const ModoPreparoSection(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSubmitButton(controller),
      ],
    );
  }

  Widget _buildSubmitButton(FichaTecnicaController controller) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: controller.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
              )
            : const Text(
                "Salvar Receita",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
      ),
    );
  }
}