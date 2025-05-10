import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_dashboard_controller.dart';
import '../controllers/profile_controller.dart';
import 'tabs/scholarships_tab.dart';
import 'tabs/applications_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/notifications_tab.dart';
import 'package:financial_aid_project/routes/routes.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  late final UserDashboardController _dashboardController;
  late final ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _dashboardController = Get.put(UserDashboardController());
    _profileController = Get.put(ProfileController());
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

    // Map routes to tab IDs
    final Map<String, String> routeToTabId = {
      TRoutes.userScholarships: 'scholarships',
      TRoutes.userApplications: 'applications',
      TRoutes.userProfile: 'profile',
      TRoutes.userNotifications: 'notifications',
    };

    // Find matching tab ID for current route
    String? activeId;
    for (final entry in routeToTabId.entries) {
      if (currentRoute == entry.key) {
        activeId = entry.value;
        break;
      }
    }

    // If a matching tab ID is found and it's different from current,
    // update the active tab
    if (activeId != null && activeId != _dashboardController.activeTab.value) {
      _dashboardController.setActiveTab(activeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // Return the active tab
        switch (_dashboardController.activeTab.value) {
          case 'scholarships':
            return const ScholarshipsTab();
          case 'applications':
            return const ApplicationsTab();
          case 'profile':
            return const ProfileTab();
          case 'notifications':
            return const NotificationsTab();
          default:
            return const ScholarshipsTab();
        }
      }),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Obx(() {
          return BottomNavigationBar(
            currentIndex: _getNavIndex(_dashboardController.activeTab.value),
            onTap: (index) => _updateActiveTab(index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: TColors.primary,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            elevation: 8,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Scholarships',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: 'Applications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Logout',
              ),
            ],
          );
        }),
      ),
    );
  }

  int _getNavIndex(String activeTab) {
    switch (activeTab) {
      case 'scholarships':
        return 0;
      case 'applications':
        return 1;
      case 'profile':
        return 2;
      case 'notifications':
        return 3;
      default:
        return 0;
    }
  }

  void _updateActiveTab(int index) {
    // If logout button is pressed
    if (index == 4) {
      _showLogoutConfirmation();
      return;
    }

    String tabId;
    String route;

    switch (index) {
      case 0:
        tabId = 'scholarships';
        route = TRoutes.userScholarships;
        break;
      case 1:
        tabId = 'applications';
        route = TRoutes.userApplications;
        break;
      case 2:
        tabId = 'profile';
        route = TRoutes.userProfile;
        break;
      case 3:
        tabId = 'notifications';
        route = TRoutes.userNotifications;
        break;
      default:
        tabId = 'scholarships';
        route = TRoutes.userScholarships;
    }

    // Set the active tab in UI
    _dashboardController.setActiveTab(tabId);

    // Navigate if route is different from current
    if (Get.currentRoute != route) {
      Get.toNamed(route);
    }
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _profileController.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
