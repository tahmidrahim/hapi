// lib/widgets/common/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? leading;
  final double elevation;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.leading,
    this.elevation = 0,
    this.backgroundColor,
    this.titleColor,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: titleColor ?? Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      centerTitle: centerTitle,
      leading: showBackButton
          ? (leading ??
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                ))
          : null,
      actions: actions,
      elevation: elevation,
      backgroundColor:
          backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor:
          titleColor ?? Theme.of(context).appBarTheme.foregroundColor,
    );
  }
}

// Search App Bar
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onCancel;
  final String hintText;

  const SearchAppBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onCancel,
    this.hintText = 'Search...',
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
        ),
        style: GoogleFonts.poppins(fontSize: 16),
        autofocus: true,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onCancel ?? () => Navigator.pop(context),
      ),
      actions: [
        if (controller.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.clear();
              onChanged('');
            },
          ),
      ],
    );
  }
}
