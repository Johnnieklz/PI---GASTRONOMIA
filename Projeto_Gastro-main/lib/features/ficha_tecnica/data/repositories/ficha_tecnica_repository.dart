import '../../../../services/api_service.dart';

import '../dto/criar_ficha_tecnica_dto.dart';

class FichaTecnicaRepository {

  Future<void> criarFicha(
    CriarFichaTecnicaDTO dto,
  ) async {

    await ApiService.post(

      "/api/v1/fichas-tecnicas",

      body: dto.toJson(),
    );
  }
}