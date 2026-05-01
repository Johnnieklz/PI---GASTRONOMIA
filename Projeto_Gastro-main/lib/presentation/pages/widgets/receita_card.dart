import 'package:flutter/material.dart';

class ReceitaCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String imagem;
  final int rating;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool showActions;

  const ReceitaCard({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.imagem,
    required this.rating,
    required this.onTap,
    required this.onFavorite,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.asset(
                  imagem,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 40),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtitulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (showActions)
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: onFavorite,
                ),
            ],
          ),
        ),
      ),
    );
  }
}