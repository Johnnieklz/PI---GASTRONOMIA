import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';

class CriarFichaLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const CriarFichaLayout({
    super.key,
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isTablet = width >= 600 && width < 1024;
    final isDesktop = width >= 1024;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: appBar,

      body: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.65,
              child: Image.asset(
                'assets/imagens/senac_fundo.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),

            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop
                      ? 1000
                      : isTablet
                          ? 800
                          : double.infinity,
                ),

                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}