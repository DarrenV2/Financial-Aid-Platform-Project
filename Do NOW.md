Search files...

Ran tool

Ran tool

Read file: lib/features/authentication/views/admin_dashboard_screen.dart

Ran tool

Let me create a plan to restructure the admin dashboard for better modularity. Based on your files and structure, here's how we can improve it:

## 1. Folder Structure

Create a dedicated folder for the admin dashboard components:

```
lib/
  ├── features/
  │   ├── administration/  (new folder)
  │   │   ├── controllers/
  │   │   │   ├── sidebar_controller.dart
  │   │   │   └── admin_dashboard_controller.dart
  │   │   ├── views/
  │   │   │   ├── admin_dashboard_screen.dart (main container)
  │   │   │   └── tabs/
  │   │   │       ├── overview_tab.dart
  │   │   │       ├── scholarship_management_tab.dart
  │   │   │       ├── admin_management_tab.dart
  │   │   │       └── web_scraper_tab.dart
  │   │   └── models/
  │   │       └── sidebar_item.dart
  │   ├── authentication/
  │   └── scholarship/
```

## 2. Implementation Strategy

### Step 1: Create a SidebarController

```dart
// lib/features/administration/controllers/sidebar_controller.dart
import 'package:get/get.dart';

class SidebarController extends GetxController {
  final RxString activeItem = 'overview'.obs;

  void setActiveItem(String item) {
    activeItem.value = item;
  }
}
```

### Step 2: Update Routes to Support Admin Dashboard Navigation

```dart
// lib/routes/routes.dart - Add nested routes
class TRoutes {
  // Existing routes...

  // Admin dashboard routes
  static const adminDashboard = '/admin-dashboard';
  static const adminOverview = '/admin-dashboard/overview';
  static const adminScholarships = '/admin-dashboard/scholarships';
  static const adminManagement = '/admin-dashboard/admin-management';
  static const adminWebScraper = '/admin-dashboard/web-scraper';
}
```

### Step 3: Create Tab Components

Each tab should be moved to its own file, for example:

```dart
// lib/features/administration/views/tabs/overview_tab.dart
import 'package:flutter/material.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content from AdminDashboardOverview
          ],
        ),
      ),
    );
  }
}
```

### Step 4: Update the Main Dashboard Screen

```dart
// lib/features/administration/views/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sidebar_controller.dart';
import 'tabs/overview_tab.dart';
import 'tabs/scholarship_management_tab.dart';
import 'tabs/admin_management_tab.dart';
import 'tabs/web_scraper_tab.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.put(SidebarController());

    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(sidebarController),
          _buildContent(sidebarController),
        ],
      ),
    );
  }

  Widget _buildContent(SidebarController controller) {
    return Expanded(
      child: Obx(() {
        switch (controller.activeItem.value) {
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
      }),
    );
  }

  Widget _buildSidebar(SidebarController controller) {
    // Sidebar implementation
  }
}
```

### Step 5: Route Observer and Navigation

Enable GetX to observe and respond to route changes by updating the route observer and adding it to your application setup.

## 3. Benefits of This Approach:

1. **Modularity**: Each tab is in its own file, making it easier to maintain
2. **Scalability**: New tabs can be added without modifying existing code
3. **Navigation**: GetX routing allows for deep linking and better state management
4. **Organization**: Clear folder structure makes it obvious where admin-related code lives
5. **Maintainability**: Smaller, focused files are easier to understand and modify

## 4. Implementation Steps:

1. Create the new folder structure
2. Create the sidebar controller
3. Split each tab into its own file
4. Update the main admin dashboard to use GetX for navigation
5. Update the routes to support the new structure
6. Implement the route observer to track navigation
7. Update the app initialization to use the route observer

Would you like me to help you implement this restructuring? I can start by creating any specific component you want to focus on first.
