import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../models/ingrediente.dart';
import '../widgets/ingrediente_dialog.dart';
import '../../../services/api_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../widgets/criar_ficha_appbar.dart';
import '../widgets/criar_ficha_layout.dart';
import '../widgets/ficha_form_card.dart';

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
  final _modoPreparoController = TextEditingController();
  final _lucroController = TextEditingController(
    text: "300",
  );

  String nivelSelecionado = "";
  bool isLoading = false;

  File? imagemReceita;
  final ImagePicker _picker = ImagePicker();

  List<Ingrediente> ingredientes = [];

  //  SANITIZAÇÃO
  String sanitize(String input) {
    return input
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s@.,\-]'), '');
  }

  double parseDouble(String input) {
    return double.tryParse(input.replaceAll(',', '.')) ?? 0;
  }

  int parseInt(String input) {
    return int.tryParse(input) ?? 0;
  }

  double get custoTotal => ingredientes.fold(0.0, (sum, item) => sum + item.custoTotal);

  double get custoPorPorcao {
    
    final p = parseInt(_porcoesController.text);
    if (p == 0) return 0;
    return custoTotal / p;
  }

  double get margemLucro {
    return parseDouble(_lucroController.text);
  }

  double get precoSugerido {
    return custoTotal * (1 + (margemLucro / 100));
  }

  double get foodCost {
    if (precoSugerido == 0) return 0;

    return (custoTotal / precoSugerido) * 100;
  }

  void _addIngrediente() {
    showDialog(
      context: context,
      builder: (_) => IngredienteDialog(
        onAdd: (novoIngrediente) {
          setState(() {
            ingredientes.add(novoIngrediente);
          });
        },
      ),
    );
  }

  Future<void> _selecionarImagem() async {
    final XFile? imagem =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imagem == null) return;

    setState(() {
      imagemReceita = File(imagem.path);
    });
  }

  Future<void> _submit() async {
    if (isLoading) return;

    if (!_formKey.currentState!.validate()) return;

    if (nivelSelecionado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecione o nível de dificuldade"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final payload = {
      "nome": sanitize(_nomeController.text),
      "categoria": sanitize(_categoriaController.text),
      "tempo_preparo_min": parseInt(_tempoController.text),
      "porcoes": parseInt(_porcoesController.text),
      "modo_preparo": sanitize(_modoPreparoController.text),
      "nivel_dificuldade": nivelSelecionado,

      "ingredientes": ingredientes.map((i) => i.toJson()).toList(),

      "custo_total": double.parse(custoTotal.toStringAsFixed(2)),
      "custo_por_porcao":
          double.parse(custoPorPorcao.toStringAsFixed(2)),
    };

    try {

      await ApiService.post(
        "/api/v1/fichas-tecnicas",
        body: payload,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Salvo com sucesso 🚀"),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao salvar"),
        ),
      );

    } finally {

      // desativa loading SEMPRE
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CriarFichaLayout(
      appBar: CriarFichaAppBar(
        isLoading: isLoading,
        onSubmit: _submit,
      ),

      child: FichaFormCard(
        formKey: _formKey,

        imagemReceita: imagemReceita,
        onSelecionarImagem: _selecionarImagem,

        nomeController: _nomeController,
        categoriaController: _categoriaController,
        tempoController: _tempoController,
        porcoesController: _porcoesController,
        modoPreparoController: _modoPreparoController,
        lucroController: _lucroController,

        nivelSelecionado: nivelSelecionado,

        onNivelChanged: (nivel) {
          setState(() {
            nivelSelecionado = nivel;
          });
        },

        custoTotal: custoTotal,
        custoPorPorcao: custoPorPorcao,
        precoSugerido: precoSugerido,
        foodCost: foodCost,

        ingredientes: ingredientes,

        onAddIngrediente: _addIngrediente,

        onRemoveIngrediente: (item) {
          setState(() {
            ingredientes.remove(item);
          });
        },

        button: _button(),
      ),
    );
  }

  Widget _button() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submit,

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor:
              AppColors.primary.withValues(alpha: 0.7),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : const Text(
                "Salvar Receita",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}