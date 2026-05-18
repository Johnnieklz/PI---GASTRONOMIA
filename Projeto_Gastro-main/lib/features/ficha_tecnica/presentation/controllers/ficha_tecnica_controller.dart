import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../domain/entities/ingrediente_entity.dart';
import '../../domain/services/ficha_financeira_service.dart';
import '../../data/dto/criar_ficha_tecnica_dto.dart';
import '../../data/repositories/ficha_tecnica_repository.dart';

class FichaTecnicaController extends ChangeNotifier {

  final _repository =
      FichaTecnicaRepository();

  final ImagePicker _picker =
      ImagePicker();

  bool isLoading = false;

  String nivelSelecionado = "";

  String? categoriaSelecionada;

  File? imagemReceita;

  final List<IngredienteEntity>
      ingredientes = [];

  final nomeController =
      TextEditingController();

  final tempoController =
      TextEditingController();

  final porcoesController =
      TextEditingController();

  final modoPreparoController =
      TextEditingController();

  final lucroController =
      TextEditingController(
    text: "35.0",
  );

  FichaTecnicaController() {
    init();
  }

  void init() {

    lucroController.addListener(
      _onFormChanged,
    );

    porcoesController.addListener(
      _onFormChanged,
    );

    tempoController.addListener(
      _onFormChanged,
    );

    nomeController.addListener(
      _onFormChanged,
    );

    modoPreparoController.addListener(
      _onFormChanged,
    );
  }

  void _onFormChanged() {
    notifyListeners();
  }

  // -------------------------
  // CÁLCULOS
  // -------------------------

  double get custoTotal =>
      FichaFinanceiraService
          .calcularCustoTotal(
        ingredientes,
      );

  double get custoPorPorcao {

    final porcoes =
        int.tryParse(
              porcoesController.text,
            ) ??
            0;

    return FichaFinanceiraService
        .calcularCustoPorPorcao(
      custoTotal: custoTotal,
      porcoes: porcoes,
    );
  }

  double get precoSugerido {

    final lucro =
        double.tryParse(
              lucroController.text,
            ) ??
            0;

    return FichaFinanceiraService
        .calcularPrecoSugerido(
      custoTotal: custoTotal,
      margemLucro: lucro,
    );
  }

  double get foodCost {

    return FichaFinanceiraService
        .calcularFoodCost(
      custoTotal: custoTotal,
      precoVenda: precoSugerido,
    );
  }

  // -------------------------
  // AÇÕES
  // -------------------------

  void addIngrediente(
    IngredienteEntity item,
  ) {

    ingredientes.add(item);

    notifyListeners();
  }

  void removeIngrediente(
    IngredienteEntity  item,
  ){

    ingredientes.remove(item);

    notifyListeners();
  }

  void setNivel(String nivel) {

    nivelSelecionado = nivel;

    notifyListeners();
  }

  void setCategoria(
    String? categoria,
  ) {

    categoriaSelecionada =
        categoria;

    notifyListeners();
  }

  void setImagem(File file) {

    imagemReceita = file;

    notifyListeners();
  }

  Future<void> selecionarImagem() async {

    final XFile? imagem =
        await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imagem == null) {
      return;
    }

    imagemReceita =
        File(imagem.path);

    notifyListeners();
  }

  void setLoading(bool value) {

    isLoading = value;

    notifyListeners();
  }

  // -------------------------
  // SUBMIT
  // -------------------------

  Future<void> submit() async {

    setLoading(true);

    try {

      final dto =
          CriarFichaTecnicaDTO(

        nome:
            nomeController.text.trim(),

        categoria:
            categoriaSelecionada ?? "",

        tempoPreparoMin:
            int.tryParse(
                  tempoController.text,
                ) ??
                0,

        porcoes:
            int.tryParse(
                  porcoesController.text,
                ) ??
                0,

        modoPreparo:
            modoPreparoController
                .text
                .trim(),

        nivelDificuldade:
            nivelSelecionado,

        ingredientes:
            ingredientes,

        custoTotal:
            custoTotal,

        custoPorPorcao:
            custoPorPorcao,

        precoSugerido:
            precoSugerido,

        foodCost:
            foodCost,
      );

      await _repository
          .criarFicha(dto);

    } finally {

      setLoading(false);
    }
  }

  // -------------------------
  // LIMPEZA
  // -------------------------

  @override
  void dispose() {

    nomeController.dispose();

    tempoController.dispose();

    porcoesController.dispose();

    modoPreparoController.dispose();

    lucroController.dispose();

    super.dispose();
  }
}