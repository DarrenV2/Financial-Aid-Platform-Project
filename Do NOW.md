
## Student Dashboard Restructuring Plan

### 1. Folder Structure

```
lib/
  ├── features/
  │   ├── student/ (new folder)
  │   │   ├── controllers/
  │   │   │   └── user_dashboard_controller.dart
  │   │   ├── views/
  │   │   │   ├── user_dashboard_screen.dart (main container)
  │   │   │   └── tabs/
  │   │   │       ├── scholarships_tab.dart
  │   │   │       ├── applications_tab.dart
  │   │   │       ├── profile_tab.dart
  │   │   │       └── notifications_tab.dart
  │   │   └── models/
  │   │       └── dashboard_item.dart
```

### 2. Implementation Strategy

#### Step 1: Create a DashboardController

```dart
// lib/features/student/controllers/user_dashboard_controller.dart
import 'package:get/get.dart';

class UserDashboardController extends GetxController {
  final RxString activeTab = 'scholarships'.obs;

  void setActiveTab(String tab) {
    activeTab.value = tab;
  }
}
```

#### Step 2: Create Tab Components

```dart
// lib/features/student/views/tabs/scholarships_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_aid_project/routes/routes.dart';

class ScholarshipsTab extends StatelessWidget {
  const ScholarshipsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Scholarships',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Scholarship list content here
            ElevatedButton(
              onPressed: () => Get.toNamed(TRoutes.scholarshipList),
              child: const Text('Browse All Scholarships'),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Step 3: Update Routes

```dart
// lib/routes/routes.dart - Add new routes
class TRoutes {
  // Existing routes...

  // User dashboard routes
  static const userDashboard = '/user-dashboard';
  static const userScholarships = '/user-dashboard/scholarships';
  static const userApplications = '/user-dashboard/applications';
  static const userProfile = '/user-dashboard/profile';
  static const userNotifications = '/user-dashboard/notifications';
}
```

#### Step 4: Update Main Dashboard Screen

```dart
// lib/features/student/views/user_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_dashboard_controller.dart';
import 'tabs/scholarships_tab.dart';
import 'tabs/applications_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/notifications_tab.dart';
import 'package:financial_aid_project/data/repositories/authentication/authentication_repository.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(UserDashboardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthenticationRepository.instance.logout(),
          ),
        ],
      ),
      body: Obx(() {
        // Return the active tab
        switch (dashboardController.activeTab.value) {
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
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: _getNavIndex(dashboardController.activeTab.value),
          onTap: (index) => _updateActiveTab(dashboardController, index),
          type: BottomNavigationBarType.fixed,
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
          ],
        );
      }),
    );
  }

  int _getNavIndex(String activeTab) {
    switch (activeTab) {
      case 'scholarships': return 0;
      case 'applications': return 1;
      case 'profile': return 2;
      case 'notifications': return 3;
      default: return 0;
    }
  }

  void _updateActiveTab(UserDashboardController controller, int index) {
    switch (index) {
      case 0: controller.setActiveTab('scholarships'); break;
      case 1: controller.setActiveTab('applications'); break;
      case 2: controller.setActiveTab('profile'); break;
      case 3: controller.setActiveTab('notifications'); break;
    }
  }
}
```

### 3. Benefits

1. **Modularity**: Each section is in its own file
2. **Maintainability**: Easier to modify individual sections
3. **Better UX**: Tab-based navigation instead of grid cards
4. **State Management**: Proper GetX architecture for state management
5. **Scalability**: Easy to add more tabs or features

### 4. Implementation Steps

1. Create the folder structure
2. Implement the controller
3. Create separate tab components
4. Update routes
5. Implement the main dashboard screen with bottom navigation
6. Wire everything together with GetX
