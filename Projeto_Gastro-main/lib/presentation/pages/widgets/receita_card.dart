import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/favoritos_service.dart';

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

// ---------------------------------------------------------------------------
// Layout vertical — GridView
// ---------------------------------------------------------------------------
class _GridCard extends StatelessWidget {
  final ReceitaCard card;
  const _GridCard({required this.card});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Material(
          borderRadius: BorderRadius.circular(18),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.08),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: card.onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔥 IMAGEM COM OVERLAY
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      _ReceitaImage(imagem: card.imagem),

                      // Gradiente (melhora leitura)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.15),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // ❤️ botão favorito flutuante
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: _FavoriteButton(
                            titulo: card.titulo,
                            onFavorite: card.onFavorite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔥 CONTEÚDO
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card.titulo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              card.subtitulo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        // ⭐ rating
                        _RatingStars(rating: card.rating),
                      ],
                    ),
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

// ---------------------------------------------------------------------------
// Layout horizontal — ListView
// ---------------------------------------------------------------------------
class _ListCard extends StatelessWidget {
  final ReceitaCard card;
  const _ListCard({required this.card});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: InkWell(
          onTap: card.onTap,
          child: SizedBox(
            height: 100,
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: _ReceitaImage(imagem: card.imagem),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    // ✅ mainAxisAlignment.spaceBetween sem Spacer
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          card.titulo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          card.subtitulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        _RatingStars(rating: card.rating),
                      ],
                    ),
                  ),
                ),
                _FavoriteButton(
                  titulo: card.titulo,
                  onFavorite: card.onFavorite,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets compartilhados
// ---------------------------------------------------------------------------

class _ReceitaImage extends StatelessWidget {
  final String imagem;
  const _ReceitaImage({required this.imagem});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagem,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => ColoredBox(
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.restaurant_menu, size: 36, color: Colors.grey),
        ),
      ),
    );
  }
}

class _RatingStars extends StatelessWidget {
  final int rating;
  const _RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 14,
          color: i < rating ? const Color(0xFFFFC107) : Colors.grey[400],
        );
      }),
    );
  }
}

/// Lê estado do Provider diretamente — não depende do pai para saber se
/// está favoritado. context.select reconstrói apenas este widget.
class _FavoriteButton extends StatelessWidget {
  final String titulo;
  final VoidCallback onFavorite;

  const _FavoriteButton({required this.titulo, required this.onFavorite});

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<FavoritosService, bool>(
      (svc) => svc.isFavorito(titulo),
    );

    return IconButton(
      tooltip: isFav ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
      iconSize: 22,
      splashRadius: 20,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(isFav),
          color: isFav ? Colors.red : Colors.grey,
        ),
      ),
      onPressed: onFavorite,
    );
  }
}