import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/favoritos_service.dart';
import '../../../data/receitas_data.dart';
import 'detalheFicha.dart';
import 'criar_ficha_tecnica.dart';
import 'favoritos_page.dart';

class InicialPage extends StatefulWidget {
  const InicialPage({super.key});

  @override
  State<InicialPage> createState() => _InicialPageState();
}

class _InicialPageState extends State<InicialPage> {
  final List<Map<String, dynamic>> receitas = ReceitasData.receitas;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String filtroTempo = 'Todos';
  String filtroCategoria = 'Todos';

  final List<String> categorias = [
    'Todos',
    'Café da Manhã',
    'Almoço',
    'Jantar',
    'Lanches',
    'Sobremesa',
    'Bebida',
    'Saladas',
    'Sopas',
    'Massas',
    'Carnes',
    'Peixes',
    'Frango',
    'Vegetariano',
    'Vegano',
    'Fitness',
    'Low Carb',
    'Sem Glúten',
    'Sem Lactose',
    'Doces',
    'Bolos',
    'Pães',
    'Petiscos',
    'Grelhados',
    'Fritos',
    'Assados',
    'Comida Brasileira',
    'Comida Italiana',
    'Comida Japonesa',
    'Comida Mexicana',
    'Comida Árabe',
    'Comida Chinesa',
    'Fast Food',
    'Smoothies',
    'Sucos',
    'Cafés',
    'Chás',
  ];

  List<Map<String, dynamic>> get receitasFiltradas {
    return receitas.where((r) {
      final titulo = r['titulo']?.toString().toLowerCase() ?? '';
      final searchOk =
          _searchQuery.isEmpty || titulo.contains(_searchQuery.toLowerCase());

      final tempoOk =
          filtroTempo == 'Todos' ||
          (r['subtitulo']?.contains(filtroTempo) ?? false);
      final categoriaOk =
          filtroCategoria == 'Todos' ||
          (r['subtitulo']?.toLowerCase().contains(
                filtroCategoria.toLowerCase(),
              ) ??
              false);
      return searchOk && tempoOk && categoriaOk;
    }).toList();
  }

  void _abrirFiltro() async {
    String tempTempo = filtroTempo;
    String tempCategoria = filtroCategoria;

    final resultado = await showModalBottomSheet<Map<String, String>?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtrar receitas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tempo',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Todos'),
                        selected: tempTempo == 'Todos',
                        onSelected: (_) {
                          setModalState(() {
                            tempTempo = 'Todos';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('45 min'),
                        selected: tempTempo == '45 min',
                        onSelected: (_) {
                          setModalState(() {
                            tempTempo = '45 min';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('50 min'),
                        selected: tempTempo == '50 min',
                        onSelected: (_) {
                          setModalState(() {
                            tempTempo = '50 min';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('60 min'),
                        selected: tempTempo == '60 min',
                        onSelected: (_) {
                          setModalState(() {
                            tempTempo = '60 min';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('40 min'),
                        selected: tempTempo == '40 min',
                        onSelected: (_) {
                          setModalState(() {
                            tempTempo = '40 min';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Categoria',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categorias
                            .map(
                              (cat) => ChoiceChip(
                                label: Text(cat),
                                selected: tempCategoria == cat,
                                onSelected: (_) {
                                  setModalState(() {
                                    tempCategoria = cat;
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C2998),
                        ),
                        onPressed: () {
                          Navigator.pop(context, {
                            'tempo': tempTempo,
                            'categoria': tempCategoria,
                          });
                        },
                        child: const Text(
                          'Aplicar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (resultado != null) {
      setState(() {
        filtroTempo = resultado['tempo'] ?? 'Todos';
        filtroCategoria = resultado['categoria'] ?? 'Todos';
      });
    }
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
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                        hintText: 'Busca por nome',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBDBD),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBDBD),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF6C2998),
                          ),
                        ),
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C2998),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _abrirFiltro,
                    icon: const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      'Filtro',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GridView.builder(
                  itemCount: receitasFiltradas.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.70,
                  ),
                  itemBuilder: (context, index) {
                    final receita = receitasFiltradas[index];
                    return Consumer<FavoritosService>(
                      builder: (context, favoritos, _) {
                        final titulo = receita['titulo'] as String;
                        final isFav = favoritos.isFavorito(titulo);
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VisualizarFichaTecnica(receita: receita),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              clipBehavior: Clip.antiAlias,
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Stack(
                                    children: [
                                      Image.asset(
                                        receita['imagem'] as String,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  height: 120,
                                                  color: Colors.grey[200],
                                                  child: const Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black26,
                                          radius: 18,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(
                                              isFav
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isFav
                                                  ? const Color(0xFF2E7D32)
                                                  : Colors.white,
                                              size: 20,
                                            ),
                                            onPressed: () => favoritos
                                                .toggleFavorito(titulo),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          receita['titulo'] as String,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          receita['subtitulo'] as String,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        if (receita['descricao'] != null)
                                          Text(
                                            receita['descricao'] as String,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 11,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      bottom: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Color(0xFFB47AFF),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const CriarFichaTecnica(),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color(0xFFFF6B6B),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                  'Excluir Receita',
                                                ),
                                                content: Text(
                                                  'Tem certeza que deseja excluir "${receita['titulo'] as String}"?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text(
                                                      'Cancelar',
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                0xFFFF6B6B,
                                                              ),
                                                        ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            'Receita excluída!',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                      'Excluir',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.purple[200], size: 32),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.purple[200], size: 32),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritosPage(),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.purple[100],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF6C2998), size: 32),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CriarFichaTecnica(),
                    ),
                  );
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.purple[200], size: 32),
              onPressed: () => Navigator.pushNamed(context, '/perfil'),
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.purple[200], size: 32),
              onPressed: () => Navigator.pushNamed(context, '/configuracoes'),
            ),
          ],
        ),
      ),
    );
  }
}
