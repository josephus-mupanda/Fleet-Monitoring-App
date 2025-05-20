import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final double? height;
  final String? topLabel;
  final bool? obscureText;
  final int? minLines;
  final int? maxLines;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final Key? kKey;
  final TextEditingController? kController;
  final String? kInitialValue;
  final bool kReadOnly;
  const SearchWidget({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.height = 36.0,
    this.topLabel = "",
    this.minLines,
    this.maxLines,
    this.obscureText = false,
    this.onSaved,
    this.keyboardType,
    this.errorText,
    this.onChanged,
    this.validator,
    this.kKey,
    this.kController,
    this.kInitialValue,
    this.kReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle hintStyle = theme.inputDecorationTheme.hintStyle ??
        TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          fontWeight: FontWeight.normal,
          fontSize: 12,
        );
    final TextStyle errorStyle = theme.inputDecorationTheme.errorStyle ??
        TextStyle(
          fontSize: 12,
          height: 1,
          color: theme.colorScheme.error,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,//theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: TextFormField(
            initialValue: kInitialValue,
            controller: kController,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            minLines: minLines,
            maxLines: maxLines,
            keyboardType: keyboardType,
            onSaved: onSaved,
            onChanged: onChanged,
            validator: validator,
            obscureText: obscureText ?? false,
            readOnly: kReadOnly,
            decoration: InputDecoration(
              prefixIcon: prefixIcon != null
                  ? Icon(
                prefixIcon,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              )
                  : null,
              suffixIcon: suffixIcon,

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.dividerColor.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                ),
              ),
              errorStyle: errorStyle,
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                ),
              ),
              hintText: hintText,
              hintStyle: hintStyle,
              errorText: errorText,
            ),
          ),
        ),
      ],
    );
  }
}
