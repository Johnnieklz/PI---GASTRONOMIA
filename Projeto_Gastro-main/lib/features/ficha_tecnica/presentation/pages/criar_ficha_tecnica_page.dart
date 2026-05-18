import 'package:flutter/material.dart';

import '../widgets/criar_ficha_appbar.dart';
import '../widgets/criar_ficha_layout.dart';
import '../widgets/cards/ficha_form_card.dart';

class CriarFichaTecnica extends StatelessWidget {
  const CriarFichaTecnica({super.key});

  @override
  Widget build(BuildContext context) {
    return const CriarFichaLayout(
      appBar: CriarFichaAppBar(),
      child: FichaFormCard(),
    );
  }
}