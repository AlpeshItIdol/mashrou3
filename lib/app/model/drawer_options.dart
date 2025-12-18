import 'dart:ui';

class DrawerOption {
  final String icon;
  final String title;
  final VoidCallback onTap;

  DrawerOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}