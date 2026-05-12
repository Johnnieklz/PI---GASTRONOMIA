import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/favoritos_service.dart';
import '../../../data/receitas_data.dart';
import '../widgets/receita_card.dart';
import '../widgets/custom_nav_bar.dart';
import 'detalheFicha.dart';

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ FIX "No Material widget found" — mesmo motivo da InicialPage
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        bottom: false,
        child: Consumer<FavoritosService>(
          builder: (context, favoritos, _) {
            final receitasFavoritas = ReceitasData.receitas
                .where((r) => favoritos.isFavorito(r['titulo'] as String))
                .toList();

            if (receitasFavoritas.isEmpty) {
              return const _EmptyFavoritos();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Text(
                    'Favoritos (${receitasFavoritas.length})',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: CustomBottomNavBar.navBarHeight + 16,
                    ),
                    itemCount: receitasFavoritas.length,
                    itemBuilder: (context, index) {
                      final receita = receitasFavoritas[index];
                      return ReceitaCard(
                        titulo: receita['titulo'] as String,
                        subtitulo: receita['subtitulo'] as String,
                        imagem: receita['imagem'] as String,
                        rating: (receita['rating'] as int?) ?? 4,
                        isGridMode: false,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                VisualizarFichaTecnica(receita: receita),
                          ),
                        ),
                        onFavorite: () => favoritos.removeFavorito(
                          receita['titulo'] as String,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptyFavoritos extends StatelessWidget {
  const _EmptyFavoritos();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border_rounded, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Nenhum favorito ainda',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          SizedBox(height: 6),
          Text(
            'Toque no ♥ de uma receita para salvá-la aqui.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}