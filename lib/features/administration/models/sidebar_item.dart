import 'package:flutter/material.dart';

class SidebarItem {
  final String id;
  final String title;
  final IconData outlinedIcon;
  final IconData filledIcon;

  SidebarItem({
    required this.id,
    required this.title,
    required this.outlinedIcon,
    required this.filledIcon,
  });
}
