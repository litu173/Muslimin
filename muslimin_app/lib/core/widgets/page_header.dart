import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import 'islamic_pattern.dart';

/// The one search field used everywhere: white pill, search icon, clear
/// button.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Radii.pill),
      borderSide: BorderSide(color: AppColors.divider),
    );
    return TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: autofocus,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: TextInputAction.search,
      style: AppText.body.copyWith(color: AppColors.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppText.body.copyWith(color: AppColors.muted),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        prefixIcon: Icon(Icons.search_rounded, color: AppColors.muted),
        suffixIcon: ValueListenableBuilder(
          valueListenable: controller,
          builder: (_, v, _) => v.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: MaterialLocalizations.of(context)
                      .deleteButtonTooltip,
                  icon: Icon(Icons.close_rounded, color: AppColors.muted),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
        filled: true,
        fillColor: AppColors.field,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: AppColors.gold, width: 1.4),
        ),
      ),
    );
  }
}

/// Patterned top-of-page header (behind the status bar): optional back
/// button, title, subtitle, and anything below (search field, chips…).
/// [sky] swaps the pattern for a sky gradient (Dua parts); [lightSky] then
/// switches to dark text.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.back = false,
    this.trailing,
    this.bottom,
    this.sky,
    this.lightSky = false,
  });

  final String title;
  final String? subtitle;
  final bool back;
  final Widget? trailing;
  final Widget? bottom;
  final List<Color>? sky;
  final bool lightSky;

  @override
  Widget build(BuildContext context) {
    final fg = lightSky ? const Color(0xFF0B2A33) : AppColors.onHeader;
    final content = Padding(
      padding: EdgeInsets.fromLTRB(
        back ? Gap.xs : Gap.l,
        MediaQuery.of(context).padding.top + (back ? 0 : Gap.s),
        Gap.l,
        Gap.l,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (back) BackButton(color: fg),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.headline.copyWith(color: fg),
                ),
              ),
              ?trailing,
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: EdgeInsets.only(left: back ? Gap.m : 0, top: 2),
              child: Text(
                subtitle!,
                style: AppText.caption.copyWith(
                  color: fg.withValues(alpha: 0.85),
                ),
              ),
            ),
          if (bottom != null)
            Padding(
              padding: EdgeInsets.only(left: back ? Gap.m : 0, top: Gap.m),
              child: bottom,
            ),
        ],
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: lightSky ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: sky == null
          ? IslamicPattern(child: content)
          : DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [sky![0], sky![1]],
                ),
              ),
              child: content,
            ),
    );
  }
}

/// App bar for the simpler pages – same pattern, colours and title style as
/// [PageHeader], so every screen's top bar looks the same.
class PatternAppBar extends AppBar {
  PatternAppBar({
    super.key,
    super.title,
    super.actions,
    super.bottom,
    super.toolbarHeight,
  }) : super(flexibleSpace: const IslamicPattern(), centerTitle: false);
}
