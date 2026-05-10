import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import 'finance_card.dart';

class ResumoFinanceiro extends StatelessWidget {
  final double custoTotal;
  final double custoPorPorcao;
  final double precoSugerido;
  final double foodCost;
  final int ingredientesCount;
  final String nivelSelecionado;

  const ResumoFinanceiro({
    super.key,
    required this.custoTotal,
    required this.custoPorPorcao,
    required this.precoSugerido,
    required this.foodCost,
    required this.ingredientesCount,
    required this.nivelSelecionado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),

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

        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Resumo Financeiro",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: FinanceCard(
                  title: "Custo Total",
                  value: "R\$ ${custoTotal.toStringAsFixed(2)}",
                  icon: Icons.attach_money,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: FinanceCard(
                  title: "Por Porção",
                  value: "R\$ ${custoPorPorcao.toStringAsFixed(2)}",
                  icon: Icons.pie_chart,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: FinanceCard(
                  title: "Preço Sugerido",
                  value: "R\$ ${precoSugerido.toStringAsFixed(2)}",
                  icon: Icons.sell_outlined,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: FinanceCard(
                  title: "Food Cost",
                  value: "${foodCost.toStringAsFixed(1)}%",
                  icon: Icons.bar_chart,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: FinanceCard(
                  title: "Ingredientes",
                  value: "$ingredientesCount",
                  icon: Icons.inventory_2_outlined,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: FinanceCard(
                  title: "Nível",
                  value: nivelSelecionado.isEmpty
                      ? "--"
                      : nivelSelecionado,
                  icon: Icons.local_fire_department_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}