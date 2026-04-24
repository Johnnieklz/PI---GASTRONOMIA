import 'package:flutter/material.dart';

class CriarFichaTecnica extends StatefulWidget {
  const CriarFichaTecnica({super.key});

  @override
  State<CriarFichaTecnica> createState() => _CriarFichaTecnicaState();
}

class _CriarFichaTecnicaState extends State<CriarFichaTecnica> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _tempoController = TextEditingController();
  final _porcoesController = TextEditingController();
  final _modoPreparo = TextEditingController();
  final _armazenamento = TextEditingController();
  final _apresentacao = TextEditingController();

  String nivelDificuldade = 'Fácil';
  final List<String> niveisDisponiveis = ['Fácil', 'Médio', 'Avançado', 'Expert'];

  List<Map<String, dynamic>> ingredientes = [];
  List<String> tecnicasAplicadas = [];

  void _adicionarIngrediente() {
    showDialog(
      context: context,
      builder: (context) {
        final nomeCtrl = TextEditingController();
        final qtdCtrl = TextEditingController();
        final precoCtrl = TextEditingController();

        return AlertDialog(
          title: const Text('Adicionar Ingrediente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nome do ingrediente',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qtdCtrl,
                decoration: const InputDecoration(
                  labelText: 'Quantidade (ex: 200 g)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: precoCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Preço (R\$)',
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ ',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C2998),
              ),
              onPressed: () {
                if (nomeCtrl.text.isNotEmpty && 
                    qtdCtrl.text.isNotEmpty && 
                    precoCtrl.text.isNotEmpty) {
                  setState(() {
                    ingredientes.add({
                      'nome': nomeCtrl.text,
                      'quantidade': qtdCtrl.text,
                      'preco': double.tryParse(precoCtrl.text) ?? 0.0,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Adicionar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _adicionarTecnica() {
    showDialog(
      context: context,
      builder: (context) {
        final tecnicaCtrl = TextEditingController();
        return AlertDialog(
          title: const Text('Adicionar Técnica'),
          content: TextField(
            controller: tecnicaCtrl,
            decoration: const InputDecoration(
              labelText: 'Nome da técnica',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C2998),
              ),
              onPressed: () {
                if (tecnicaCtrl.text.isNotEmpty) {
                  setState(() {
                    tecnicasAplicadas.add(tecnicaCtrl.text);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Adicionar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  double get custoTotal {
    return ingredientes.fold(0.0, (sum, item) => sum + (item['preco'] as double));
  }

  double get custoPorPorcao {
    final porcoes = int.tryParse(_porcoesController.text) ?? 1;
    return custoTotal / porcoes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: const Color(0xFF6C2998),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Criar Ficha Técnica',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagem
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Implementar seleção de imagem
                          },
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFB47AFF), width: 2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey[400]),
                                const SizedBox(height: 8),
                                Text('Adicionar foto', style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Nome da Receita
                      TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome da Receita',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF6C2998), width: 2),
                          ),
                        ),
                        validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 16),

                      // Categoria
                      TextFormField(
                        controller: _categoriaController,
                        decoration: InputDecoration(
                          labelText: 'Categoria (ex: Confeitaria Fina)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF6C2998), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nível de Dificuldade
                      const Text('Nível de Dificuldade', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: niveisDisponiveis.map((nivel) {
                          return ChoiceChip(
                            label: Text(nivel),
                            selected: nivelDificuldade == nivel,
                            onSelected: (selected) {
                              setState(() {
                                nivelDificuldade = nivel;
                              });
                            },
                            selectedColor: const Color(0xFFB47AFF),
                            labelStyle: TextStyle(
                              color: nivelDificuldade == nivel ? Colors.white : Colors.black,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Tempo e Porções
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _tempoController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Tempo (min)',
                                prefixIcon: const Icon(Icons.access_time, color: Color(0xFFB47AFF)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF6C2998), width: 2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _porcoesController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Porções',
                                prefixIcon: const Icon(Icons.people, color: Color(0xFFB47AFF)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF6C2998), width: 2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Técnicas Aplicadas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Técnicas Aplicadas', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          IconButton(
                            onPressed: _adicionarTecnica,
                            icon: const Icon(Icons.add_circle, color: Color(0xFF6C2998)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (tecnicasAplicadas.isEmpty)
                        const Text('Nenhuma técnica adicionada', style: TextStyle(color: Colors.grey))
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tecnicasAplicadas.map((tecnica) {
                            return Chip(
                              label: Text(tecnica),
                              backgroundColor: const Color(0xFFF8F6FA),
                              side: const BorderSide(color: Color(0xFFB47AFF)),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setState(() {
                                  tecnicasAplicadas.remove(tecnica);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 20),

                      // Ingredientes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ingredientes', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          IconButton(
                            onPressed: _adicionarIngrediente,
                            icon: const Icon(Icons.add_circle, color: Color(0xFF6C2998)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (ingredientes.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFB47AFF)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Nenhum ingrediente adicionado',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFB47AFF)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              ...ingredientes.asMap().entries.map((entry) {
                                final index = entry.key;
                                final ingrediente = entry.value;
                                return ListTile(
                                  title: Text('${index + 1}. ${ingrediente['nome']}'),
                                  subtitle: Text(ingrediente['quantidade']),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'R\$ ${ingrediente['preco'].toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Color(0xFFB47AFF),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            ingredientes.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      if (ingredientes.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Custo Total:', style: TextStyle(fontWeight: FontWeight.w600)),
                            Text(
                              'R\$ ${custoTotal.toStringAsFixed(2)}',
                              style: const TextStyle(color: Color(0xFFB47AFF), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Custo por Porção:', style: TextStyle(fontWeight: FontWeight.w600)),
                            Text(
                              'R\$ ${custoPorPorcao.toStringAsFixed(2)}',
                              style: const TextStyle(color: Color(0xFFB47AFF), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Modo de Preparo
                      const Text('Modo de Preparo', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _modoPreparo,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Descreva o modo de preparo...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFB47AFF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF6C2998), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Armazenamento
                      const Text('Armazenamento e Validade', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _armazenamento,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Ex: 3 dias refrigerado, 60 dias congelado',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFB47AFF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF6C2998), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Apresentação
                      const Text('Sugestões de Apresentação', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _apresentacao,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Ex: Finalizar com pó de ouro e flores comestíveis',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFB47AFF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF6C2998), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Botão Salvar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C2998),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // TODO: Salvar ficha técnica
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ficha técnica salva com sucesso!'),
                                  backgroundColor: Color(0xFF6C2998),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Salvar Ficha Técnica',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _categoriaController.dispose();
    _tempoController.dispose();
    _porcoesController.dispose();
    _modoPreparo.dispose();
    _armazenamento.dispose();
    _apresentacao.dispose();
    super.dispose();
  }
}