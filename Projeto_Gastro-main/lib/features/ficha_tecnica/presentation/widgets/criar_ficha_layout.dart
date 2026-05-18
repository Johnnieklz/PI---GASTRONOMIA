import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

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
    final isDesktop = width >= 1024;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
            bottom: -50,
            right: -50,
            child: Opacity(
              opacity: 0.1, 
              child: Image.asset(
                'assets/imagens/senac_fundo.png',
                width: 400,
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? width * 0.1 : 20,
                vertical: 30,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1200 : 800,
                  ),
                  child: Column(
                    children: [
                      // Breadcrumbs or Title could go here if needed
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}