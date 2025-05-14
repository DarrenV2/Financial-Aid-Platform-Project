import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:financial_aid_project/data/repositories/authentication/authentication_repository.dart';
import '../controllers/sidebar_controller.dart';
import '../controllers/admin_dashboard_controller.dart';
import 'tabs/overview_tab.dart';
import 'tabs/scholarship_management_tab.dart';
import 'tabs/admin_management_tab.dart';
import 'tabs/web_scraper_tab.dart';
import 'package:financial_aid_project/routes/routes.dart';
import '../controllers/theme_controller.dart';
import '../controllers/admin_profile_controller.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late final SidebarController _sidebarController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _sidebarController = Get.put(SidebarController());
    Get.put(AdminDashboardController());
    Get.put(ThemeController());
    Get.put(AdminProfileController());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check current route and set appropriate tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncRouteWithTab();
    });
  }

  void _syncRouteWithTab() {
    final currentRoute = Get.currentRoute;

    // Map routes to sidebar IDs
    final Map<String, String> routeToSidebarId = {
      TRoutes.adminOverview: 'overview',
      TRoutes.adminScholarships: 'scholarships',
      TRoutes.adminManagement: 'admin-management',
      TRoutes.adminWebScraper: 'web-scraper',
    };

    // Find matching sidebar ID for current route
    String? activeId;
    for (final entry in routeToSidebarId.entries) {
      if (currentRoute == entry.key) {
        activeId = entry.value;
        break;
      }
    }

    // If a matching sidebar ID is found and it's different from current,
    // update the active item
    if (activeId != null && activeId != _sidebarController.activeItem.value) {
      _sidebarController.setActiveItem(activeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),

          // Main content
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      color: TColors.primary.withAlpha(15),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // App logo/branding
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ScholarsHub',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TColors.primary,
                      ),
                    ),
                    Text(
                      'Admin Portal',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          // Navigation menu items
          Obx(() {
            return Column(
              children: _sidebarController.items.map((item) {
                final isSelected =
                    _sidebarController.activeItem.value == item.id;
                return _buildNavItem(item.id, item.title, item.outlinedIcon,
                    item.filledIcon, isSelected);
              }).toList(),
            );
          }),

          const Divider(height: 40),

          const Spacer(),

          // Logout button
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: () => AuthenticationRepository.instance.logout(),
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withAlpha(30),
                foregroundColor: Colors.red,
                elevation: 0,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String id, String title, IconData outlinedIcon,
      IconData filledIcon, bool isSelected) {
    return InkWell(
      onTap: () => _sidebarController.navigateToTab(id),
      child: Container(
        height: 54,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color:
              isSelected ? TColors.primary.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected ? TColors.primary : Colors.grey,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? TColors.primary : Colors.grey[700],
              ),
            ),
            if (isSelected) ...[
              const Spacer(),
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: TColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMenuLink(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 54,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final themeController = Get.find<ThemeController>();
    final profileController = Get.find<AdminProfileController>();

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey[900],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.05 * 255).round()),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Page title based on active sidebar item
          Obx(() {
            String title = 'Dashboard';
            switch (_sidebarController.activeItem.value) {
              case 'overview':
                title = 'Dashboard Overview';
                break;
              case 'scholarships':
                title = 'Scholarship Management';
                break;
              case 'admin-management':
                title = 'Admin Management';
                break;
              case 'web-scraper':
                title = 'Web Scraper';
                break;
            }

            return Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            );
          }),

          const Spacer(),

          // Theme toggle button
          Obx(() => IconButton(
                onPressed: () => themeController.toggleTheme(),
                icon: Icon(
                  themeController.isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  color: themeController.isDarkMode
                      ? Colors.amber
                      : Colors.blueGrey,
                ),
                tooltip: themeController.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
              )),

          const SizedBox(width: 20),

          // Admin info display (non-clickable)
          Obx(() {
            return Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: TColors.primary,
                  child: Text(
                    profileController.adminInitials,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileController.admin.value.username.isNotEmpty
                          ? profileController.admin.value.username
                          : 'Admin',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    Text(
                      profileController.admin.value.email.isNotEmpty
                          ? profileController.admin.value.email
                          : 'admin@email.com',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Obx(() {
      switch (_sidebarController.activeItem.value) {
        case 'overview':
          return const OverviewTab();
        case 'scholarships':
          return const ScholarshipManagementTab();
        case 'admin-management':
          return const AdminManagementTab();
        case 'web-scraper':
          return const WebScraperTab();
        default:
          return const OverviewTab();
      }
    });
  }
}
