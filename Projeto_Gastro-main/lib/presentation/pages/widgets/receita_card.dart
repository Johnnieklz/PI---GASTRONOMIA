import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/favoritos_service.dart';

String extrairCategoria(String subtitulo) {
  return subtitulo.split('•').first.trim();
}

String extrairTempo(String subtitulo) {
  final partes = subtitulo.split('•');
  return partes.length > 1 ? partes.last.trim() : '';
}

class ReceitaCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String imagem;
  final int rating;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool isGridMode;

  const ReceitaCard({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.imagem,
    required this.rating,
    required this.onTap,
    required this.onFavorite,
    this.isGridMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return isGridMode ? _GridCard(card: this) : _ListCard(card: this);
  }
}

//
// 🔥 BADGE COM FUNDO BRANCO + COR
//
class _CategoryBadge extends StatelessWidget {
  final String categoria;

  const _CategoryBadge({required this.categoria});

  (Color, IconData) _getStyle() {
    switch (categoria.toLowerCase()) {
      case 'fitness':
        return (Colors.green, Icons.fitness_center);
      case 'jantar':
        return (Colors.purple, Icons.restaurant);
      case 'almoço':
        return (Colors.blue, Icons.lunch_dining);
      case 'forno':
        return (Colors.orange, Icons.local_fire_department);
      case 'cozinha':
        return (Colors.deepPurple, Icons.kitchen);
      default:
        return (Colors.grey, Icons.restaurant_menu);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _getStyle();

    return Container(
      padding: const EdgeInsets.all(3), // 🔥 FUNDO BRANCO EXTERNO
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              categoria,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// 🔥 GRID CARD (FINAL PERFEITO)
//
class _GridCard extends StatelessWidget {
  final ReceitaCard card;
  const _GridCard({required this.card});

  @override
  Widget build(BuildContext context) {
    final categoria = extrairCategoria(card.subtitulo);
    final tempo = extrairTempo(card.subtitulo);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.08),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: card.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔥 IMAGEM MAIOR
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.asset(
                          card.imagem,
                          height: 200, // 👈 AUMENTADO
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // 🔥 CONTEÚDO
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12, 26, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card.titulo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 14, color: Colors.grey[600]),
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

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                _RatingStars(rating: card.rating),
                                const SizedBox(width: 6),
                                Text(
                                  "${card.rating.toDouble()}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ❤️ FAVORITO
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: _FavoriteButton(
                        titulo: card.titulo,
                        onFavorite: card.onFavorite,
                      ),
                    ),
                  ),

                  // 🔥 BADGE AJUSTADA
                  Positioned(
                    left: 15,
                    top: 167, // 👈 AJUSTADO PRA NOVA ALTURA
                    child: Transform.translate(
                      offset: const Offset(0, 12),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _CategoryBadge(categoria: categoria),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// 🔥 LIST CARD
//
class _ListCard extends StatelessWidget {
  final ReceitaCard card;
  const _ListCard({required this.card});

  @override
  Widget build(BuildContext context) {
    final categoria = extrairCategoria(card.subtitulo);
    final tempo = extrairTempo(card.subtitulo);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: card.onTap,
          child: SizedBox(
            height: 120,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20),
                  ),
                  child: Image.asset(
                    card.imagem,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CategoryBadge(categoria: categoria),
                        const SizedBox(height: 6),
                        Text(
                          card.titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(tempo),
                        const Spacer(),
                        _RatingStars(rating: card.rating),
                      ],
                    ),
                  ),
                ),

                _FavoriteButton(
                  titulo: card.titulo,
                  onFavorite: card.onFavorite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// ⭐ RATING
//
class _RatingStars extends StatelessWidget {
  final int rating;
  const _RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star : Icons.star_border,
          size: 16,
          color: Colors.orange,
        );
      }),
    );
  }
}

//
// ❤️ FAVORITO
//
class _FavoriteButton extends StatelessWidget {
  final String titulo;
  final VoidCallback onFavorite;

  const _FavoriteButton({
    required this.titulo,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<FavoritosService, bool>(
      (svc) => svc.isFavorito(titulo),
    );

    return IconButton(
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? Colors.red : Colors.grey,
      ),
      onPressed: onFavorite,
    );
  }
}