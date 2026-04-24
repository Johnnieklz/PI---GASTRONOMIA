import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/favoritos_service.dart';
import '../../../data/receitas_data.dart';
import 'detalheFicha.dart';

String _extrairTempo(String subtitulo) {
  final match = RegExp(r'Tempo (\d+ min)').firstMatch(subtitulo);
  if (match != null) return '${match.group(1)!} - Preparo';
  return subtitulo;
}

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FA),
      body: SafeArea(
        child: Consumer<FavoritosService>(
          builder: (context, favoritos, _) {
            final receitasFavoritas = ReceitasData.receitas
                .where((r) => favoritos.isFavorito(r['titulo'] as String))
                .toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Color(0xFF2E7D32),
                                size: 28,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      _buildPerfilChef(),
                      const SizedBox(height: 24),
                      const Text(
                        'Lista de receitas',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C2998),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                if (receitasFavoritas.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhuma receita favoritada',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Toque no coração nos cards para adicionar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final receita = receitasFavoritas[index];
                        return _ReceitaFavoritaCard(
                          titulo: receita['titulo'] as String,
                          tempo: _extrairTempo(receita['subtitulo'] as String),
                          imagem: receita['imagem'] as String,
                          rating: receita['rating'] as int? ?? 4,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VisualizarFichaTecnica(receita: receita),
                              ),
                            );
                          },
                          onRemoveFavorito: () {
                            favoritos.removeFavorito(
                              receita['titulo'] as String,
                            );
                          },
                        );
                      }, childCount: receitasFavoritas.length),
                    ),
                  ),
                if (receitasFavoritas.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'Mostrar mais...',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF6C2998),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home_rounded,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            IconButton(
              icon: const Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => Navigator.pushNamed(context, '/perfil'),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 28),
              onPressed: () => Navigator.pushNamed(context, '/configuracoes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerfilChef() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF3EFFF),
            border: Border.all(
              color: const Color(0xFF6C2998).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/imagens/arroz_branco.jpg.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.person, size: 60, color: Color(0xFF6C2998)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Luciana Martins',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Green Moon',
          style: TextStyle(fontSize: 14, color: Color(0xFF66BB6A)),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            return Icon(
              i < 4 ? Icons.star : Icons.star_half,
              color: const Color(0xFFFFB300),
              size: 20,
            );
          }),
        ),
      ],
    );
  }
}

class _ReceitaFavoritaCard extends StatelessWidget {
  final String titulo;
  final String tempo;
  final String imagem;
  final int rating;
  final VoidCallback onTap;
  final VoidCallback onRemoveFavorito;

  const _ReceitaFavoritaCard({
    required this.titulo,
    required this.tempo,
    required this.imagem,
    required this.rating,
    required this.onTap,
    required this.onRemoveFavorito,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagem,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[200],
                      child: const Icon(Icons.restaurant, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            tempo,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < rating ? Icons.star : Icons.star_border,
                            color: const Color(0xFFFFB300),
                            size: 16,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: const Color(0xFF2E7D32).withOpacity(0.15),
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Color(0xFF2E7D32),
                      size: 24,
                    ),
                    onPressed: onRemoveFavorito,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
