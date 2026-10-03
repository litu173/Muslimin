import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// Label above a white field – the form pattern used throughout the Figma.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Gap.s, top: Gap.l),
    child: Text(text, style: AppText.label.copyWith(letterSpacing: 0.25)),
  );
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.inputFormatters,
    this.enabled = true,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FieldLabel(label),
      TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        textInputAction:
            textInputAction ??
            (maxLines > 1 ? TextInputAction.newline : TextInputAction.next),
        style: AppText.label,
        decoration: InputDecoration(hintText: hint),
      ),
    ],
  );
}

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.validator,
    this.hint,
  });

  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final String? hint;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FieldLabel(label),
      DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        validator: validator,
        menuMaxHeight: 360,
        borderRadius: BorderRadius.circular(Radii.field),
        dropdownColor: AppColors.card,
        icon: const Icon(
          Icons.arrow_drop_down_rounded,
          color: AppColors.ink,
          size: 28,
        ),
        hint: hint == null
            ? null
            : Text(
                hint!,
                style: AppText.label.copyWith(color: AppColors.muted),
              ),
        style: AppText.label.copyWith(
          fontFamily: DefaultTextStyle.of(context).style.fontFamily,
        ),
        items: [
          for (final i in items)
            DropdownMenuItem(
              value: i,
              child: Text(itemLabel(i), overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: onChanged,
      ),
    ],
  );
}

/// Read-only field that opens a picker (date / time) – "Select ▢".
class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.icon,
    required this.onTap,
    this.error,
  });

  final String label;
  final String? value;
  final String placeholder;
  final IconData icon;
  final VoidCallback onTap;
  final String? error;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FieldLabel(label),
      Material(
        color: AppColors.field,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.field),
          side: error == null
              ? BorderSide.none
              : const BorderSide(color: AppColors.danger),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.field),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? placeholder,
                    style: AppText.label.copyWith(
                      color: value == null ? AppColors.ink : AppColors.ink,
                    ),
                  ),
                ),
                Icon(icon, color: AppColors.ink, size: 24),
              ],
            ),
          ),
        ),
      ),
      if (error != null)
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 12),
          child: Text(
            error!,
            style: AppText.caption.copyWith(color: AppColors.danger),
          ),
        ),
    ],
  );
}

/// Round check used in agreement lists (Figma "Tick Circle").
class TickCircle extends StatelessWidget {
  const TickCircle({super.key, required this.checked, this.size = 24});

  final bool checked;
  final double size;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 180),
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: checked ? AppColors.gold : Colors.transparent,
      border: Border.all(color: AppColors.gold, width: 1.5),
    ),
    child: checked
        ? Icon(Icons.check_rounded, size: size * 0.66, color: Colors.white)
        : null,
  );
}
