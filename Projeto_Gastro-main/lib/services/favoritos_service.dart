import 'package:flutter/foundation.dart';

/// Serviço global para gerenciar receitas favoritas.
class FavoritosService extends ChangeNotifier {
  static final FavoritosService _instance = FavoritosService._();
  static FavoritosService get instance => _instance;

  FavoritosService._();

  final Set<String> _ids = {};

  Set<String> get ids => Set.unmodifiable(_ids);

  bool isFavorito(String titulo) => _ids.contains(titulo);

  void toggleFavorito(String titulo) {
    if (_ids.contains(titulo)) {
      _ids.remove(titulo);
    } else {
      _ids.add(titulo);
    }
    notifyListeners();
  }

  void addFavorito(String titulo) {
    _ids.add(titulo);
    notifyListeners();
  }

  void removeFavorito(String titulo) {
    _ids.remove(titulo);
    notifyListeners();
  }
}
