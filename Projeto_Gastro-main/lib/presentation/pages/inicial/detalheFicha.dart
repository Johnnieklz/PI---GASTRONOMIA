import 'package:flutter/material.dart';

class VisualizarFichaTecnica extends StatelessWidget {
  final Map<String, dynamic>? receita;
  const VisualizarFichaTecnica({super.key, this.receita});

  @override
  Widget build(BuildContext context) {
    // Se a receita for nula, usamos valores padrão (fallback)
    final String titulo = receita?['titulo'] ?? 'Bolo de Chocolate Belga 70%';
    final String imagem =
        receita?['imagem'] ?? 'assets/imagens/arroz_branco.jpg.png';
    final String categoria = receita?['subtitulo'] ?? 'Confeitaria Fina';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com imagem
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      imagem,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Conteúdo principal
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Categoria e Dificuldade
                    Row(
                      children: [
                        Text(
                          categoria,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Avançado',
                            style: TextStyle(
                              color: Color(0xFF6C2998),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Cards de informações
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _InfoCard(
                          icon: Icons.access_time,
                          label: 'Tempo',
                          value: '60 min',
                        ),
                        _InfoCard(
                          icon: Icons.people,
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
                    const SizedBox(height: 16),

                    // Técnicas Aplicadas
                    const Text(
                      'Técnicas Aplicadas',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TecnicaChip('Emulsificação'),
                        _TecnicaChip('Roux'),
                        _TecnicaChip('Bain-marie'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Ficha Técnica - Ingredientes
                    const Text(
                      'Ficha Técnica - Ingredientes',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _IngredienteItem(
                            numero: '1',
                            nome: 'Farinha de trigo T55',
                            quantidade: '200 g',
                            preco: 'R\$ 3,50',
                          ),
                          const Divider(height: 1),
                          _IngredienteItem(
                            numero: '2',
                            nome: 'Chocolate Callebaut 70%',
                            quantidade: '150 g',
                            preco: 'R\$ 18,00',
                          ),
                          const Divider(height: 1),
                          _IngredienteItem(
                            numero: '3',
                            nome: 'Ovos orgânicos',
                            quantidade: '4 unidades',
                            preco: 'R\$ 3,20',
                          ),
                          const Divider(height: 1),
                          _IngredienteItem(
                            numero: '4',
                            nome: 'Açúcar refinado',
                            quantidade: '180 g',
                            preco: 'R\$ 1,80',
                          ),
                          const Divider(height: 1),
                          _IngredienteItem(
                            numero: '5',
                            nome: 'Manteiga sem sal',
                            quantidade: '150 g',
                            preco: 'R\$ 7,20',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Custos
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F6FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Custo Total:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const Text(
                                'R\$ 33,70',
                                style: TextStyle(
                                  color: Color(0xFF6C2998),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Custo por Porção:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const Text(
                                'R\$ 3,37',
                                style: TextStyle(
                                  color: Color(0xFF6C2998),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Modo de Preparo
                    const Text(
                      'Modo de Preparo',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Bata o Roux. Incorpore o chocolate em três tempos. Asse em forno estático a 170°C por 45 minutos. Deixe esfriar antes de desenformar.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Armazenamento e Validade
                    const Text(
                      'Armazenamento e Validade',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '3 dias refrigerado (3°C), 60 dias congelado.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sugestões de Apresentação
                    const Text(
                      'Sugestões de Apresentação',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Finalizar com pó de ouro e flores comestíveis.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Botões de ação - APENAS EDITAR E EXCLUIR
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFF6C2998),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              // TODO: Implementar edição
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFF6C2998),
                            ),
                            label: const Text(
                              'Editar',
                              style: TextStyle(
                                color: Color(0xFF6C2998),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B6B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Excluir Receita'),
                                  content: const Text(
                                    'Tem certeza que deseja excluir esta ficha técnica?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFFF6B6B,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Ficha técnica excluída com sucesso!',
                                            ),
                                            backgroundColor: Color(0xFFFF6B6B),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Excluir',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.white),
                            label: const Text(
                              'Excluir',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para os cards de informação (Tempo, Porções, Custo)
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
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF6C2998), size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Widget para os chips de técnicas
class _TecnicaChip extends StatelessWidget {
  final String texto;

  const _TecnicaChip(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF6C2998), width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Color(0xFF6C2998),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}

// Widget para cada item de ingrediente
class _IngredienteItem extends StatelessWidget {
  final String numero;
  final String nome;
  final String quantidade;
  final String preco;

  const _IngredienteItem({
    required this.numero,
    required this.nome,
    required this.quantidade,
    required this.preco,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$numero. $nome',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  quantidade,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            preco,
            style: const TextStyle(
              color: Color(0xFF6C2998),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
