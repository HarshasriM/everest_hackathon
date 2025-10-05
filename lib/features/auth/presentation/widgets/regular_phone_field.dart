import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegularPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final String label;
  final bool enabled;

  const RegularPhoneField({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.label = 'Enter phone number',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.telephoneNumber],
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: '9999999999',
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.phone_outlined, size: 24),
              const SizedBox(width: 8),
              Text(
                '+91',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
      validator: validator,
      onChanged: (value) {
        if (value.length > 10) {
          final last10Digits = value.substring(value.length - 10);
          controller.text = last10Digits;
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: last10Digits.length),
          );
          return;
        }
        onChanged?.call(value);
      },
      onFieldSubmitted: (_) {
        if (controller.text.length == 10) {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}
