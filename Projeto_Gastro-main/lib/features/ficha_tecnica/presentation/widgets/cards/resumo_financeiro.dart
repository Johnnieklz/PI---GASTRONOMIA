import 'package:flutter/material.dart';
import '../../../../../config/theme/app_colors.dart';
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

          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    value: ingredientesCount == 0
                        ? "--"
                        : "R\$ ${custoPorPorcao.toStringAsFixed(2)}",
                    icon: Icons.pie_chart,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF005CA9),
                          Color(0xFF007BFF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.sell_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "VENDA",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "Preço Sugerido",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ingredientesCount == 0
                              ? "--"
                              : "R\$ ${precoSugerido.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FinanceCard(
                    title: "Custos (%)",
                    value: ingredientesCount == 0
                        ? "--"
                        : "${foodCost.toStringAsFixed(1)}%",
                    icon: Icons.bar_chart,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    value: nivelSelecionado.isEmpty ? "--" : nivelSelecionado,
                    icon: Icons.local_fire_department_outlined,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}