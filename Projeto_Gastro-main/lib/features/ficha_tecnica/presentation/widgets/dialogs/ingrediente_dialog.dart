import 'package:flutter/material.dart';
import '../../../domain/entities/ingrediente_entity.dart';
import '../inputs/ficha_input.dart';
import '../buttons/ficha_button.dart';

class IngredienteDialog extends StatefulWidget {
  final Function(IngredienteEntity) onAdd;

  const IngredienteDialog({super.key, required this.onAdd});

  @override
  State<IngredienteDialog> createState() => _IngredienteDialogState();
}

class _IngredienteDialogState extends State<IngredienteDialog> {
  final _nomeController = TextEditingController();
  final _qtdController = TextEditingController();
  final _precoController = TextEditingController();
  final _fatorController = TextEditingController();
  final _fatorFocus = FocusNode();

  String _unidadeSelecionada = "g";

  @override
  void initState() {
    super.initState();

    _fatorFocus.addListener(() {
      // Quando clicar no campo
      if (_fatorFocus.hasFocus && _fatorController.text == "1.0") {
        _fatorController.clear();
      }

      // Quando sair do campo vazio
      if (!_fatorFocus.hasFocus && _fatorController.text.isEmpty) {
        _fatorController.text = "1.0";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFFF4EC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 500;
          return Container(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 420,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.restaurant_menu, color: Color(0xFFFF7A00)),
                      const SizedBox(width: 10),
                      const Text(
                        "Adicionar Ingrediente",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  FichaInput(
                    label: "Nome",
                    controller: _nomeController,
                  ),
                  const SizedBox(height: 14),

                  LayoutBuilder(
                    builder: (context, constraints) {

                      final isMobile =
                          constraints.maxWidth < 360;

                      if (isMobile) {

                        return Column(
                          children: [

                            FichaInput(
                              label: "Quantidade",
                              controller: _qtdController,
                              isNumber: true,
                            ),

                            const SizedBox(height: 12),

                            DropdownButtonFormField<String>(

                              initialValue:
                                  _unidadeSelecionada,

                              decoration:
                                  const InputDecoration(
                                labelText: "Unidade",
                              ),

                              items: [
                                "g",
                                "kg",
                                "ml",
                                "L",
                                "un",
                              ]
                                  .map(
                                    (e) =>
                                        DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),

                              onChanged: (v) {

                                setState(() {
                                  _unidadeSelecionada = v!;
                                });
                              },
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [

                          Expanded(
                            child: FichaInput(
                              label: "Quantidade",
                              controller:
                                  _qtdController,
                              isNumber: true,
                            ),
                          ),

                          const SizedBox(width: 10),

                          SizedBox(
                            width: 95,

                            child:
                                DropdownButtonFormField<
                                    String>(

                              initialValue:
                                  _unidadeSelecionada,

                              decoration:
                                  const InputDecoration(
                                labelText: "Unidade",
                              ),

                              items: [
                                "g",
                                "kg",
                                "ml",
                                "L",
                                "un",
                              ]
                                  .map(
                                    (e) =>
                                        DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),

                              onChanged: (v) {

                                setState(() {
                                  _unidadeSelecionada = v!;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  FichaInput(
                    label: "Preço Unitário (R\$)",
                    controller: _precoController,
                    isNumber: true,
                  ),
                  const SizedBox(height: 14),

                  FichaInput(
                    label: "Fator de Correção",
                    controller: _fatorController,
                    isNumber: true,
                    hint: "1.0",
                    focusNode: _fatorFocus,
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FichaButton(
                        text: "Adicionar",
                        icon: Icons.check,
                        onPressed: _handleAdd,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleAdd() {
    double qtd =
        double.tryParse(_qtdController.text.replaceAll(',', '.')) ?? 0;
    double preco =
        double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0;
    double fator =
        double.tryParse(_fatorController.text.replaceAll(',', '.')) ?? 1.0;

    if (_nomeController.text.isEmpty || qtd <= 0 || preco <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha os campos corretamente")),
      );
      return;
    }

    final novo = IngredienteEntity(
      nome: _nomeController.text.trim(),
      quantidade: qtd,
      unidade: _unidadeSelecionada,
      precoUnitario: preco,
      fatorCorrecao: fator,
    );

    widget.onAdd(novo);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _qtdController.dispose();
    _precoController.dispose();
    _fatorController.dispose();
    _fatorFocus.dispose();

    super.dispose();
  }
}