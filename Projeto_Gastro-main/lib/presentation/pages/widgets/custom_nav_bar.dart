import 'dart:ui';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Altura total da navbar — usada pelas páginas no padding inferior das listas.
  static const double navBarHeight = 75.0;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ SizedBox declara a altura real ao Scaffold — ele reserva exatamente
    // esse espaço no bottomNavigationBar e avisa o MediaQuery.padding.bottom
    // das páginas filhas. Sem isso o Scaffold não sabe quanto espaço reservar
    // e a navbar pode sobrepor ou sumir.
    return SizedBox(
      height: navBarHeight,
      child: Stack(
        // ✅ clipBehavior: Clip.none permite o FAB "flutuar" acima da barra
        // sem ser cortado pelo SizedBox.
        clipBehavior: Clip.none,
        children: [
          // Barra principal glass ocupa os 75px
          _buildBar(context),
          // FAB centralizado, posicionado 20px acima do topo da barra
          _buildCenterButton(),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: navBarHeight,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false, // já está no bottom — SafeArea protege apenas home indicator
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_rounded,     index: 0, currentIndex: currentIndex, onTap: onTap),
                _NavItem(icon: Icons.favorite_rounded,  index: 1, currentIndex: currentIndex, onTap: onTap),
                const SizedBox(width: 64), // espaço para o FAB central
                _NavItem(icon: Icons.person_rounded,    index: 3, currentIndex: currentIndex, onTap: onTap),
                _NavItem(icon: Icons.settings_rounded,  index: 4, currentIndex: currentIndex, onTap: onTap),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    // ✅ left: 0 + right: 0 + top: -20 = centralizado horizontalmente e
    // 20px acima do topo da barra. Sem left/right, o Positioned poderia
    // não centralizar corretamente dependendo da alignment do Stack.
    return Positioned(
      top: -20,
      left: 0,
      right: 0,
      child: Center(
        child: _CenterFabButton(
          isSelected: currentIndex == 2,
          onTap: () => onTap(2),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets privados
// ---------------------------------------------------------------------------

class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  bool get _isSelected => currentIndex == index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // HitTestBehavior.opaque evita miss-taps em áreas transparentes do widget
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _isSelected
              ? const Color(0xFF004C94).withOpacity(0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: _isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: 26,
                color: _isSelected ? const Color(0xFF004C94) : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: _isSelected ? 16 : 0,
              decoration: BoxDecoration(
                color: const Color(0xFF004C94),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterFabButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _CenterFabButton({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [const Color(0xFF0066CC), const Color(0xFF004C94)]
                : [const Color(0xFF004C94), const Color(0xFF0066CC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF004C94).withOpacity(0.45),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}