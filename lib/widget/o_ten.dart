import 'package:flutter/material.dart';

/// Ô tên Telex: TextField + controller. Cấm formatter, cấm đụng composing.
class OTen extends StatelessWidget {
  OTen({
    Key? key,
    required this.controller,
    this.hint,
    this.autofocus = false,
    this.minLines,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
  })  : _fieldKey = key,
        super(key: null);

  final Key? _fieldKey;
  final TextEditingController controller;
  final String? hint;
  final bool autofocus;
  final int? minLines;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    final nhieu = maxLines > 1 || (minLines != null && minLines! > 1);
    return TextField(
      key: _fieldKey,
      controller: controller,
      autofocus: autofocus,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: nhieu ? TextInputType.multiline : TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      enableIMEPersonalizedLearning: true,
      autocorrect: false,
      enableSuggestions: false,
      spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(hintText: hint),
    );
  }
}
