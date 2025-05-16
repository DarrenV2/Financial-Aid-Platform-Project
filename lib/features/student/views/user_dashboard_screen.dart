import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_dashboard_controller.dart';
import '../controllers/profile_controller.dart';
import 'tabs/scholarships_tab.dart';
import 'tabs/applications_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/coaching_tab.dart';
import 'package:financial_aid_project/routes/routes.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:financial_aid_project/shared_components/gemini_chatbot.dart';

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
    _profileController = Get.put(ProfileController(), tag: 'student');
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
      TRoutes.userCoaching: 'coaching',
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
    return DefaultTabController(
      length: 4,
      initialIndex: _getNavIndex(_dashboardController.activeTab.value),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Student Dashboard',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E56FB), // Darker blue
                  TColors.primary,
                  Color(0xFF4E7DFF), // Lighter blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: TColors.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          elevation: 8,
          shadowColor: TColors.primary.withValues(alpha: 0.5),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () => _showLogoutConfirmation(),
                tooltip: 'Logout',
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(68),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: TabBar(
                onTap: (index) => _updateActiveTab(index),
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.5),
                      Colors.white.withValues(alpha: 0.3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: TColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                splashBorderRadius: BorderRadius.circular(25),
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                ),
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(vertical: 2),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.school, size: 22),
                    text: 'Scholarships',
                  ),
                  Tab(
                    icon: Icon(Icons.description, size: 22),
                    text: 'Applications',
                  ),
                  Tab(
                    icon: Icon(Icons.psychology, size: 22),
                    text: 'Coaching',
                  ),
                  Tab(
                    icon: Icon(Icons.person, size: 22),
                    text: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Obx(() {
              // Return the active tab
              switch (_dashboardController.activeTab.value) {
                case 'scholarships':
                  return const ScholarshipsTab();
                case 'applications':
                  return const ApplicationsTab();
                case 'profile':
                  return const ProfileTab();
                case 'coaching':
                  return const CoachingTab();
                default:
                  return const ScholarshipsTab();
              }
            }),
            // Add the chatbot overlay
            const GeminiChatbot(),
          ],
        ),
      ),
    );
  }

  int _getNavIndex(String activeTab) {
    switch (activeTab) {
      case 'scholarships':
        return 0;
      case 'applications':
        return 1;
      case 'coaching':
        return 2;
      case 'profile':
        return 3;
      default:
        return 0;
    }
  }

  void _updateActiveTab(int index) {
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
        tabId = 'coaching';
        route = TRoutes.userCoaching;
        break;
      case 3:
        tabId = 'profile';
        route = TRoutes.userProfile;
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
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
