import 'package:education_institution/generated/theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onMenuPressed; // Callback for 3-dot menu
  final VoidCallback? onBackPressed; // Callback for back button

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true, // By default, show back button unless specified
    this.onMenuPressed,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppThemes.lightTheme.primaryColor, // Constant color for all pages
      title: Text(
        title,
        style: AppThemes.lightTheme.textTheme.headlineLarge, // Text style for the title
      ),
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBackPressed ??
                  () {
                    Navigator.of(context).pop(); // Default back action
                  },
            )
          : IconButton(
              icon: const Icon(Icons.more_vert,
                  color: Colors.white), // 3-dot menu
              onPressed: onMenuPressed ?? () {}, // Custom menu action
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
