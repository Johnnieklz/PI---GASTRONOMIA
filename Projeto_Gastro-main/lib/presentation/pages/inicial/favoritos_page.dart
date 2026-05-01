import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/favoritos_service.dart';
import '../../../data/receitas_data.dart';
import 'detalheFicha.dart';
import '../widgets/receita_card.dart';

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<FavoritosService>(
          builder: (context, favoritos, _) {
            final receitasFavoritas = ReceitasData.receitas
                .where((r) => favoritos.isFavorito(r['titulo']))
                .toList();

            if (receitasFavoritas.isEmpty) {
              return const Center(
                child: Text("Nenhum favorito ainda"),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              itemCount: receitasFavoritas.length,
              itemBuilder: (context, index) {
                final receita = receitasFavoritas[index];

                return ReceitaCard(
                  titulo: receita['titulo'],
                  subtitulo: receita['subtitulo'],
                  imagem: receita['imagem'],
                  rating: receita['rating'] ?? 4,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VisualizarFichaTecnica(receita: receita),
                      ),
                    );
                  },
                  onFavorite: () {
                    favoritos.removeFavorito(receita['titulo']);
                  },
                  showActions: true,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
