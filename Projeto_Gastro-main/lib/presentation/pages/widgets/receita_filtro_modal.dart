import 'package:flutter/material.dart';

class ReceitaFiltroModal extends StatefulWidget {
  final List<String> categorias;
  final String categoriaSelecionada;
  final ValueChanged<String> onCategoriaSelecionada;

  const ReceitaFiltroModal({
    super.key,
    required this.categorias,
    required this.categoriaSelecionada,
    required this.onCategoriaSelecionada,
  });

  @override
  State<ReceitaFiltroModal> createState() =>
      _ReceitaFiltroModalState();
}

class _ReceitaFiltroModalState
    extends State<ReceitaFiltroModal> {

  late String categoriaSelecionada;

  @override
  void initState() {
    super.initState();

    categoriaSelecionada =
        widget.categoriaSelecionada;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(24),
      height: 420,

      decoration: const BoxDecoration(
        color: Color(0xFFF8F8FA),

        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // 🔥 HEADER
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                'Filtros',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                children: [
                  // 🔥 BOTÃO LIMPAR
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF004C94),
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                    ),

                    onPressed: () {
                      setState(() {
                        categoriaSelecionada =
                            'Todos';
                      });

                      widget.onCategoriaSelecionada(
                        'Todos',
                      );

                      Navigator.pop(context);
                    },

                    child: const Text(
                      'Limpar',
                      style: TextStyle(
                        color: Color(0xFF004C94),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // 🔥 BOTÃO SALVAR
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF004C94),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                    ),

                    onPressed: () {
                      widget.onCategoriaSelecionada(
                        categoriaSelecionada,
                      );

                      Navigator.pop(context);
                    },

                    child: const Text(
                      'Salvar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            'Categorias',

            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          Wrap(
            spacing: 10,
            runSpacing: 12,

            children:
                widget.categorias.map((categoria) {

              final isSelected =
                  categoriaSelecionada ==
                      categoria;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    categoriaSelecionada =
                        categoria;
                  });
                },

                child: AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds: 200,
                  ),

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),

                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(
                            0xFF004C94)
                        : Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.04),

                        blurRadius: 6,
                      ),
                    ],
                  ),

                  child: Text(
                    categoria,

                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.black87,

                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}