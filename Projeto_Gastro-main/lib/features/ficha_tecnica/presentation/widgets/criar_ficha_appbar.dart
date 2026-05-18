import 'package:flutter/material.dart';

class CriarFichaAppBar extends StatelessWidget
    implements PreferredSizeWidget {
 

  const CriarFichaAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {

    return PreferredSize(

      preferredSize: preferredSize,

      child: Stack(
        fit: StackFit.expand,

        children: [

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF005CA9),
                  Color(0xFF007BFF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            bottom: false,

            child: SizedBox(
              height: preferredSize.height,

              child: Stack(
                children: [

                  Align(
                    alignment: Alignment.centerLeft,

                    child: IconButton(
                      onPressed: () => Navigator.pop(context),

                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const Center(
                    child: Text(
                      "Nova Receita",

                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}