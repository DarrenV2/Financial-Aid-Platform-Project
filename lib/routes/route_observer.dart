/*
 * This file is currently not in use but contains a template for route observation
 * that might be implemented in the future. The commented code below shows
 * an example of how to implement route observation with GetX.
 * 
 * When needed, uncomment and implement the necessary classes and methods.
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_aid_project/features/administration/controllers/sidebar_controller.dart';
import 'package:financial_aid_project/features/student/controllers/user_dashboard_controller.dart';
import 'routes.dart';

class RouteObservers extends GetObserver {
  // List of admin dashboard routes to listen for
  final List<String> adminRoutes = [
    TRoutes.adminOverview,
    TRoutes.adminScholarships,
    TRoutes.adminManagement,
    TRoutes.adminWebScraper,
  ];

  // Map routes to sidebar item IDs
  final Map<String, String> routeToSidebarId = {
    TRoutes.adminOverview: 'overview',
    TRoutes.adminScholarships: 'scholarships',
    TRoutes.adminManagement: 'admin-management',
    TRoutes.adminWebScraper: 'web-scraper',
  };

  // List of user dashboard routes to listen for
  final List<String> userRoutes = [
    TRoutes.userScholarships,
    TRoutes.userApplications,
    TRoutes.userProfile,
  ];

  // Map routes to user tab IDs
  final Map<String, String> routeToUserTabId = {
    TRoutes.userScholarships: 'scholarships',
    TRoutes.userApplications: 'applications',
    TRoutes.userProfile: 'profile',
  };

  /// Called when a route is popped from the navigation stack.
  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    _updateActiveItemFromRoute(previousRoute);

    // Call super with non-null routes
    if (route != null && previousRoute != null) {
      super.didPop(route, previousRoute);
    }
  }

  /// Called when a route is pushed onto the navigation stack.
  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    _updateActiveItemFromRoute(route);

    // Call super with non-null routes
    if (route != null && previousRoute != null) {
      super.didPush(route, previousRoute);
    } else if (route != null) {
      super.didPush(route, null);
    }
  }

  /// Called when a route is replaced in the navigation stack.
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _updateActiveItemFromRoute(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  /// Helper method to update the active item in the sidebar or user tabs based on the current route
  void _updateActiveItemFromRoute(Route<dynamic>? route) {
    if (route != null && route.settings.name != null) {
      final routeName = route.settings.name!;

      // Check if this is one of our admin dashboard routes
      for (final adminRoute in adminRoutes) {
        if (routeName == adminRoute || routeName.startsWith('$adminRoute/')) {
          try {
            final sidebarController = Get.find<SidebarController>();
            final sidebarId = routeToSidebarId[adminRoute];
            if (sidebarId != null) {
              // Update the sidebar directly
              sidebarController.setActiveItem(sidebarId);
              break;
            }
          } catch (e) {
            // SidebarController may not be initialized yet
            debugPrint('Error finding SidebarController: $e');
          }
        }
      }

      // Check if this is one of our user dashboard routes
      for (final userRoute in userRoutes) {
        if (routeName == userRoute || routeName.startsWith('$userRoute/')) {
          try {
            final userDashboardController = Get.find<UserDashboardController>();
            final tabId = routeToUserTabId[userRoute];
            if (tabId != null) {
              // Update the user dashboard tabs
              userDashboardController.setActiveTab(tabId);
              break;
            }
          } catch (e) {
            // UserDashboardController may not be initialized yet
            debugPrint('Error finding UserDashboardController: $e');
          }
        }
      }
    }
  }
}

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sidebar_controller.dart'; // Adjust path as necessary

class RouteObservers extends GetObserver {
  /// Called when a route is popped from the navigation stack.
  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final sidebarController = Get.put(SidebarController());
    if (previousRoute != null) {
      // Check the route name and update the active item in the sidebar accordingly
      for (var routeName in routePaths) {
        if (previousRoute.settings.name == routeName) {
          sidebarController.activeItem.value = routeName;
          break; // Found the matching route, break out of the loop
        }
      }
    }
  }

  /// Called when a route is pushed onto the navigation stack.
  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final sidebarController = Get.put(SidebarController());
    if (route != null) {
      // Check the route name and update the active item in the sidebar accordingly
      for (var routeName in routePaths) {
        if (route.settings.name == routeName) {
          sidebarController.activeItem.value = routeName;
          break; // Found the matching route, break out of the loop
        }
      }
    }
  }
}
*/
