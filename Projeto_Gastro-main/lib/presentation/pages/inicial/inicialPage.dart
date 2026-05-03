import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/favoritos_service.dart';
import '../../../data/receitas_data.dart';
import '../widgets/receita_card.dart';
import 'detalheFicha.dart';
import '../widgets/custom_nav_bar.dart';

class InicialPage extends StatefulWidget {
  const InicialPage({super.key});

  @override
  State<InicialPage> createState() => _InicialPageState();
}

class _InicialPageState extends State<InicialPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _receitasFiltradas {
    if (_searchQuery.isEmpty) return ReceitasData.receitas;
    final q = _searchQuery.toLowerCase();
    return ReceitasData.receitas
        .where((r) => (r['titulo'] as String).toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FIX "No Material widget found":
    // Mesmo com Scaffold no MainNavigation, páginas dentro de IndexedStack
    // podem perder o contexto Material em certos cenários de rebuild.
    // Material(type: transparency) garante o ancestral necessário sem
    // alterar cor ou visual — é literalmente um wrapper invisível.
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        bottom: false, // Scaffold já aplica padding do bottomNavigationBar
        child: Column(
          children: [
            const SizedBox(height: 16),
            _SearchBar(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<FavoritosService>(
                builder: (context, favoritos, _) {
                  final receitas = _receitasFiltradas;

                  if (receitas.isEmpty) {
                    return const _EmptyState(
                      mensagem: 'Nenhuma receita encontrada',
                    );
                  }

                  return GridView.builder(
                    // padding bottom = altura da navbar + folga extra
                    // garante que o último card nunca fique atrás da navbar
                    padding: const EdgeInsets.only(
                      bottom: CustomBottomNavBar.navBarHeight + 16,
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
                        titulo: receita['titulo'] as String,
                        subtitulo: receita['subtitulo'] as String,
                        imagem: receita['imagem'] as String,
                        rating: (receita['rating'] as int?) ?? 4,
                        isGridMode: true,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                VisualizarFichaTecnica(receita: receita),
                          ),
                        ),
                        onFavorite: () => favoritos.toggleFavorito(
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

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Buscar receita...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
    );
  }
}

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