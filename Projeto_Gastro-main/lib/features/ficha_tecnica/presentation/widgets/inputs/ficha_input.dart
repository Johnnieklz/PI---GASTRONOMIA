import 'package:flutter/material.dart';


class FichaInput extends StatelessWidget {

  final String label;

  final String? hint;

  final TextEditingController controller;

  final bool isNumber;

  final TextInputType? keyboardType;

  final ValueChanged<String>? onChanged;

  final FocusNode? focusNode;

  final TextInputAction? textInputAction;

  final int maxLines;

  final String? Function(String?)? validator;

  const FichaInput({
    super.key,
    required this.label,
    required this.controller,

    this.hint,

    this.isNumber = false,

    this.maxLines = 1,

    this.validator,

    this.keyboardType,

    this.onChanged,

    this.focusNode,

    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.only(
        bottom: 16,
      ),

      child: TextFormField(

        onChanged: onChanged,

        focusNode: focusNode,

        textInputAction:
            textInputAction ??
            TextInputAction.next,

        controller: controller,

        keyboardType:
            keyboardType ??
            (isNumber
                ? const TextInputType.numberWithOptions(
                    decimal: true,
                  )
                : TextInputType.text),

        maxLines: maxLines,

        validator: validator,

        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
}