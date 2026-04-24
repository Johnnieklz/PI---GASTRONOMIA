import 'package:flutter/material.dart';

class ProdutoDetalhePage extends StatelessWidget {
  const ProdutoDetalhePage({super.key});

  @override
  Widget build(BuildContext context) {
    const roxo = Color(0xFF6A1B9A);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: roxo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            Image.asset(
              'assets/imagens/arroz_branco.jpg.png',
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  const Text(
                    'Bolo de Chocolate Belga 70%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: const [
                      Text('Confeitaria Fina'),
                      SizedBox(width: 12),
                      Text(
                        'Avançado',
                        style: TextStyle(
                          color: roxo,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Cards informativos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _InfoCard(
                        icon: Icons.schedule,
                        label: 'Tempo',
                        value: '60 min',
                      ),
                      _InfoCard(
                        icon: Icons.group,
                        label: 'Porções',
                        value: '10',
                      ),
                      _InfoCard(
                        icon: Icons.attach_money,
                        label: 'Custo Total',
                        value: 'R\$ 80,00',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Técnicas
                  const Text(
                    'Técnicas Aplicadas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: const [
                      _ChipTecnica(label: 'Emulsificação'),
                      _ChipTecnica(label: 'Roux'),
                      _ChipTecnica(label: 'Bain-marie'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Ingredientes
                  const Text(
                    'Ficha Técnica - Ingredientes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  _IngredienteItem(
                    nome: 'Farinha de trigo T55',
                    quantidade: '200 g',
                    preco: 'R\$ 3,50',
                  ),
                  _IngredienteItem(
                    nome: 'Chocolate Callebaut 70%',
                    quantidade: '150 g',
                    preco: 'R\$ 18,00',
                  ),
                  _IngredienteItem(
                    nome: 'Ovos orgânicos',
                    quantidade: '4 unidades',
                    preco: 'R\$ 3,20',
                  ),
                  _IngredienteItem(
                    nome: 'Açúcar refinado',
                    quantidade: '180 g',
                    preco: 'R\$ 1,80',
                  ),
                  _IngredienteItem(
                    nome: 'Manteiga sem sal',
                    quantidade: '150 g',
                    preco: 'R\$ 7,20',
                  ),

                  const Divider(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Custo Total:'),
                      Text(
                        'R\$ 33,70',
                        style: TextStyle(
                          color: roxo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Custo por Porção:'),
                      Text(
                        'R\$ 3,37',
                        style: TextStyle(
                          color: roxo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Modo de preparo
                  const Text(
                    'Modo de Preparo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const _BoxTexto(
                    texto:
                        'Bata o Roux. Incorpore o chocolate em três tempos. '
                        'Asse em forno estático a 170°C por 45 minutos. '
                        'Deixe esfriar antes de desenformar.',
                  ),

                  const SizedBox(height: 16),

                  // Armazenamento
                  const Text(
                    'Armazenamento e Validade',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const _BoxTexto(
                    texto:
                        '3 dias refrigerado (3°C), 60 dias congelado.',
                  ),

                  const SizedBox(height: 16),

                  // Sugestão
                  const Text(
                    'Sugestões de Apresentação',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const _BoxTexto(
                    texto:
                        'Finalizar com pó de ouro e flores comestíveis.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF6A1B9A), size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipTecnica extends StatelessWidget {
  final String label;

  const _ChipTecnica({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF6A1B9A),
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _IngredienteItem extends StatelessWidget {
  final String nome;
  final String quantidade;
  final String preco;

  const _IngredienteItem({
    required this.nome,
    required this.quantidade,
    required this.preco,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  quantidade,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            preco,
            style: const TextStyle(
              color: Color(0xFF6A1B9A),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _BoxTexto extends StatelessWidget {
  final String texto;

  const _BoxTexto({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }
}
