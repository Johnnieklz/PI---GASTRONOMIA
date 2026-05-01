import 'dart:ui';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _buildBar(),
        _buildCenterButton(),
      ],
    );
  }

  // 🔷 NAVBAR PRINCIPAL COM EFEITO GLASS
  Widget _buildBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // efeito vidro
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85), // transparência leve
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, -5), // sombra pra cima (flutuando)
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, 0),
              _navItem(Icons.favorite, 1),
              const SizedBox(width: 60),
              _navItem(Icons.person, 3),
              _navItem(Icons.settings, 4),
            ],
          ),
        ),
      ),
    );
  }

  // 🔷 ITEM COM ANIMAÇÃO
  Widget _navItem(IconData icon, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF004C94).withOpacity(0.1)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: 26,
                color:
                    isSelected ? const Color(0xFF004C94) : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 4,
              width: isSelected ? 16 : 0,
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

  // 🔷 BOTÃO CENTRAL COM ANIMAÇÃO
  Widget _buildCenterButton() {
    return Positioned(
      bottom: 25,
      child: GestureDetector(
        onTap: () => onTap(2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF004C94),
                Color(0xFF0066CC),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF004C94).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}