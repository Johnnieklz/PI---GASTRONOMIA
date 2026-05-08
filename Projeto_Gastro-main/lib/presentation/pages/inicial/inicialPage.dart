import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/favoritos_service.dart';
import '../../../data/receitas_data.dart';
import '../widgets/receita_card.dart';
import 'detalheFicha.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/receita_filtro_modal.dart';

class InicialPage extends StatefulWidget {
  const InicialPage({super.key});

  @override
  State<InicialPage> createState() => _InicialPageState();
}

class _InicialPageState extends State<InicialPage> {
  final _searchController = TextEditingController();

  String _searchQuery = '';
  String _categoriaSelecionada = 'Todos';

  final List<String> categorias = [
    'Todos',
    'Fitness',
    'Jantar',
    'Forno',
    'Cozinha',
    'Almoço',
    'Sobremesa',
    'Bebida',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _receitasFiltradas {
    return ReceitasData.receitas.where((r) {
      final titulo = (r['titulo'] as String).toLowerCase();
      final subtitulo = (r['subtitulo'] as String).toLowerCase();

      final combinaBusca =
          titulo.contains(_searchQuery.toLowerCase());

      final combinaCategoria =
          _categoriaSelecionada == 'Todos' ||
              subtitulo.contains(
                _categoriaSelecionada.toLowerCase(),
              );

      return combinaBusca && combinaCategoria;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 16),

            _SearchBar(
              controller: _searchController,

              onChanged: (v) {
                setState(() {
                  _searchQuery = v;
                });
              },

              onFilterTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (modalContext) {
                    return ReceitaFiltroModal(
                      categorias: categorias,
                      categoriaSelecionada:
                          _categoriaSelecionada,

                      onCategoriaSelecionada: (categoria) {
                        setState(() {
                          _categoriaSelecionada = categoria;
                        });

                      },
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Consumer<FavoritosService>(
                builder: (context, favoritos, _) {
                  final receitas = _receitasFiltradas;

                  if (receitas.isEmpty) {
                    return const _EmptyState(
                      mensagem:
                          'Nenhuma receita encontrada',
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.only(
                      bottom:
                          CustomBottomNavBar.navBarHeight +
                              16,
                    ),

                    itemCount: receitas.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                    ),

                    itemBuilder: (context, index) {
                      final receita = receitas[index];

                      return ReceitaCard(
                        titulo:
                            receita['titulo'] as String,

                        subtitulo:
                            receita['subtitulo'] as String,

                        imagem:
                            receita['imagem'] as String,

                        rating:
                            (receita['rating'] as int?) ??
                                4,

                        isGridMode: true,

                        onTap: () =>
                            Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                VisualizarFichaTecnica(
                              receita: receita,
                            ),
                          ),
                        ),

                        onFavorite: () =>
                            favoritos.toggleFavorito(
                          receita['titulo'] as String,
                        ),
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

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16),

      child: Row(
        children: [
          // 🔍 CAMPO DE BUSCA
          Expanded(
            child: Container(
              height: 62,

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(22),

                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(0.06),

                    blurRadius: 14,

                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: TextField(
                controller: controller,
                onChanged: onChanged,

                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),

                decoration: InputDecoration(
                  hintText: 'Buscar receita...',

                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),

                  prefixIcon: Padding(
                    padding:
                        const EdgeInsets.only(
                      left: 14,
                      right: 8,
                    ),

                    child: Icon(
                      Icons.search_rounded,
                      size: 32,
                      color: Colors.grey[700],
                    ),
                  ),

                  prefixIconConstraints:
                      const BoxConstraints(
                    minWidth: 60,
                  ),

                  border: InputBorder.none,

                  contentPadding:
                      const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // ⚙️ BOTÃO FILTRO
          Container(
            height: 62,
            width: 62,

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(22),

              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(0.06),

                  blurRadius: 14,

                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: IconButton(
              onPressed: onFilterTap,

              icon: const Icon(
                Icons.tune_rounded,
                color: Color(0xFF8B5CF6),
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String mensagem;

  const _EmptyState({
    required this.mensagem,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.grey[300],
          ),

          const SizedBox(height: 12),

          Text(
            mensagem,

            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}