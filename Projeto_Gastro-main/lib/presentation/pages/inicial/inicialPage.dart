import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/favoritos_service.dart';
import '../../../data/receitas_data.dart';
import '../widgets/receita_card.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/receita_filtro_modal.dart';
import '../widgets/saudacao_header.dart';
import '../widgets/hero_carrossel.dart';
import '../widgets/categoria_chips.dart';
import '../widgets/em_alta_row.dart';
import 'detalheFicha.dart';

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

  final List<String> _emAlta = [
    'Arroz Integral',
    'Strogonoff',
    'Pão Caseiro',
    'Bowl Fitness',
    'Risoto',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _isFiltrando =>
      _searchQuery.isNotEmpty || _categoriaSelecionada != 'Todos';

  List<Map<String, dynamic>> get _receitasFiltradas {
    return ReceitasData.receitas.where((r) {
      final titulo = (r['titulo'] as String).toLowerCase();
      final subtitulo = (r['subtitulo'] as String).toLowerCase();

      final combinaBusca = titulo.contains(_searchQuery.toLowerCase());

      final combinaCategoria =
          _categoriaSelecionada == 'Todos' ||
              subtitulo.contains(_categoriaSelecionada.toLowerCase());

      return combinaBusca && combinaCategoria;
    }).toList();
  }

  void _navegarParaReceita(Map<String, dynamic> receita) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VisualizarFichaTecnica(receita: receita),
      ),
    );
  }

  void _abrirFiltros() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (modalContext) {
        return ReceitaFiltroModal(
          categorias: categorias,
          categoriaSelecionada: _categoriaSelecionada,
          onCategoriaSelecionada: (categoria) {
            setState(() => _categoriaSelecionada = categoria);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Saudação + Busca ──────────────────────────────
            SaudacaoHeader(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              onFilterTap: _abrirFiltros,
            ),

            const SizedBox(height: 4),

            // ── Conteúdo scrollável ───────────────────────────
            Expanded(
              child: Consumer<FavoritosService>(
                builder: (context, favoritos, _) {
                  final receitas = _receitasFiltradas;

                  return CustomScrollView(
                    slivers: [

                      // ── Seções visíveis só na tela inicial ──
                      if (!_isFiltrando) ...[
                        SliverToBoxAdapter(
                          child: HeroCarousel(
                            receitas: ReceitasData.receitas,
                            onTap: _navegarParaReceita,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: CategoriaChips(
                              categorias: categorias,
                              categoriaSelecionada: _categoriaSelecionada,
                              onSelecionada: (cat) =>
                                  setState(() => _categoriaSelecionada = cat),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: EmAltaRow(itens: _emAlta),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 14, 16, 4),
                            child: Text(
                              'Populares hoje',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                        ),
                      ],

                      // ── Chips visíveis durante busca/filtro ──
                      if (_isFiltrando)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: CategoriaChips(
                              categorias: categorias,
                              categoriaSelecionada: _categoriaSelecionada,
                              onSelecionada: (cat) =>
                                  setState(() => _categoriaSelecionada = cat),
                            ),
                          ),
                        ),

                      // ── Grid de receitas ou estado vazio ─────
                      receitas.isEmpty
                          ? const SliverFillRemaining(
                              hasScrollBody: false,
                              child: _EmptyState(
                                mensagem: 'Nenhuma receita encontrada',
                              ),
                            )
                          : SliverPadding(
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom:
                                    CustomBottomNavBar.navBarHeight + 16,
                              ),
                              sliver: SliverGrid(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final receita = receitas[index];
                                    return ReceitaCard(
                                      titulo:
                                          receita['titulo'] as String,
                                      subtitulo:
                                          receita['subtitulo'] as String,
                                      imagem: receita['imagem'] as String,
                                      rating:
                                          (receita['rating'] as int?) ?? 4,
                                      isGridMode: true,
                                      onTap: () =>
                                          _navegarParaReceita(receita),
                                      onFavorite: () =>
                                          favoritos.toggleFavorito(
                                        receita['titulo'] as String,
                                      ),
                                    );
                                  },
                                  childCount: receitas.length,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.72,
                                ),
                              ),
                            ),
                    ],
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

// ── Estado vazio ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String mensagem;

  const _EmptyState({required this.mensagem});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            mensagem,
            style: TextStyle(color: Colors.grey[500], fontSize: 15),
          ),
        ],
      ),
    );
  }
}