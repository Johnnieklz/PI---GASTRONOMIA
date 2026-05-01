import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/favoritos_service.dart';
import '../../../data/receitas_data.dart';
import 'detalheFicha.dart';
import '../widgets/receita_card.dart';

class InicialPage extends StatefulWidget {
  const InicialPage({super.key});

  @override
  State<InicialPage> createState() => _InicialPageState();
}

class _InicialPageState extends State<InicialPage> {
  final List<Map<String, dynamic>> receitas = ReceitasData.receitas;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> get receitasFiltradas {
    return receitas.where((r) {
      final titulo = r['titulo']?.toString().toLowerCase() ?? '';
      return _searchQuery.isEmpty ||
          titulo.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Busca por nome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: Consumer<FavoritosService>(
              builder: (context, favoritos, _) {
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 90),
                  itemCount: receitasFiltradas.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final receita = receitasFiltradas[index];
                    final titulo = receita['titulo'] as String;

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
                        favoritos.toggleFavorito(titulo);
                      },
                      showActions: true,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
    );  
  
  }
}
