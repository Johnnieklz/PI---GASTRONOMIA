import 'package:flutter/material.dart';

import '../../../../../config/theme/app_colors.dart';

class FichaButton extends StatelessWidget {

  final String text;

  final VoidCallback? onPressed;

  final IconData? icon;

  final bool loading;

  const FichaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 52,

      child: ElevatedButton.icon(

        onPressed:
            loading
                ? null
                : onPressed,

        icon:
            loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Icon(icon),

        label: Text(text),

        style: ElevatedButton.styleFrom(
          backgroundColor:
              AppColors.primary,

          foregroundColor:
              Colors.white,

          elevation: 0,

          padding:
              const EdgeInsets.symmetric(
            horizontal: 20,
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}