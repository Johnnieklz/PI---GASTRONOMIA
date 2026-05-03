import 'package:flutter/material.dart';
import 'package:projeto_gastronomia_ficha/presentation/pages/configuracoes/configuracoesPage.dart';
import 'package:projeto_gastronomia_ficha/presentation/pages/inicial/criar_ficha_tecnica.dart';
import 'package:projeto_gastronomia_ficha/presentation/pages/inicial/favoritos_page.dart';
import 'package:projeto_gastronomia_ficha/presentation/pages/perfil/perfilPage.dart';
import '../widgets/custom_nav_bar.dart';
import '../inicial/inicialPage.dart';

/// Ponto de entrada da navegação principal.
///
/// REGRA DE OURO: este é o ÚNICO widget que tem [Scaffold].
/// Todas as páginas filhas retornam apenas seus conteúdos (Column, ListView,
/// etc.), sem Scaffold próprio. Isso evita conflitos de Material/Scaffold
/// e garante que a navbar apareça em todas as telas.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // IndexedStack mantém o estado das páginas já visitadas (scroll, dados, etc.)
  // sem rebuildar o widget ao trocar de aba.
  static const _pages = <Widget>[
    InicialPage(),       // index 0 — Home
    FavoritosPage(),     // index 1 — Favoritos
    CriarFichaTecnica(), // index 2 — Adicionar (botão central)
    PerfilPage(),        // index 3 — Perfil
    ConfiguracoesPage(), // index 4 — Configurações
  ];

  void _onTabTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true faz o conteúdo das páginas passar por baixo da
      // navbar (necessário para o efeito glassmorphism funcionar de verdade).
      extendBody: true,
      backgroundColor: Colors.white,

      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // bottomNavigationBar é o lugar certo para a navbar —
      // o Scaffold cuida do sizing, SafeArea e MediaQuery automaticamente.
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
      ),
    );
  }
}