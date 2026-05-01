import 'package:flutter/material.dart';
import '../inicial/inicialPage.dart';
import '../inicial/favoritos_page.dart';
import '../inicial/criar_ficha_tecnica.dart';
import '../widgets/custom_nav_bar.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pages = const [
    InicialPage(),
    FavoritosPage(),
    CriarFichaTecnica(),
    Center(child: Text("Perfil")),
    Center(child: Text("Configurações")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}