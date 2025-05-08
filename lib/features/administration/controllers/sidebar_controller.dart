import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/sidebar_item.dart';
import 'package:financial_aid_project/routes/routes.dart';

class SidebarController extends GetxController {
  // Current active item ID
  final RxString activeItem = 'overview'.obs;

  // List of sidebar items
  final RxList<SidebarItem> items = <SidebarItem>[
    SidebarItem(
      id: 'overview',
      title: 'Dashboard',
      outlinedIcon: Icons.dashboard_outlined,
      filledIcon: Icons.dashboard,
    ),
    SidebarItem(
      id: 'scholarships',
      title: 'Scholarships',
      outlinedIcon: Icons.school_outlined,
      filledIcon: Icons.school,
    ),
    SidebarItem(
      id: 'admin-management',
      title: 'Admin Management',
      outlinedIcon: Icons.admin_panel_settings_outlined,
      filledIcon: Icons.admin_panel_settings,
    ),
    SidebarItem(
      id: 'web-scraper',
      title: 'Web Scraper',
      outlinedIcon: Icons.web_outlined,
      filledIcon: Icons.web,
    ),
  ].obs;

  // Map sidebar item IDs to routes
  final Map<String, String> itemIdToRoute = {
    'overview': TRoutes.adminOverview,
    'scholarships': TRoutes.adminScholarships,
    'admin-management': TRoutes.adminManagement,
    'web-scraper': TRoutes.adminWebScraper,
  };

  // Set active item
  void setActiveItem(String id) {
    activeItem.value = id;
  }

  // Navigate to the selected tab
  void navigateToTab(String id) {
    // Set the active item in UI
    setActiveItem(id);

    // Get the route for this item
    final route = itemIdToRoute[id];

    // Navigate if route exists and is different from current
    if (route != null && Get.currentRoute != route) {
      Get.toNamed(route);
    }
  }
}
