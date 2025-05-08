import 'package:financial_aid_project/features/administration/views/admin_dashboard_screen.dart';
import 'package:financial_aid_project/features/administration/views/tabs/overview_tab.dart';
import 'package:financial_aid_project/features/administration/views/tabs/scholarship_management_tab.dart';
import 'package:financial_aid_project/features/administration/views/tabs/admin_management_tab.dart';
import 'package:financial_aid_project/features/administration/views/tabs/web_scraper_tab.dart';
import 'package:financial_aid_project/features/authentication/views/dashboard_screen.dart';
import 'package:financial_aid_project/features/authentication/views/forget_password_screen.dart';
import 'package:financial_aid_project/features/authentication/views/home_screen.dart';
import 'package:financial_aid_project/features/authentication/views/login_screen.dart';
import 'package:financial_aid_project/features/authentication/views/signup.screen.dart';
import 'package:financial_aid_project/features/scholarship/views/scholarship_list.dart';
import 'package:financial_aid_project/routes/routes_middleware.dart';
import 'package:financial_aid_project/routes/routes.dart';
import 'package:get/get.dart';

class TAppRoute {
  static final pages = [
    GetPage(
        name: TRoutes.home,
        page: () => const HomeScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.login,
        page: () => const LoginScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.signup,
        page: () => const SignupScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.forgetPassword,
        page: () => const ForgetPasswordScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.userDashboard,
        page: () => const UserDashboardScreen(),
        middlewares: [TRouteMiddleware()]),

    // Admin dashboard main route
    GetPage(
        name: TRoutes.adminDashboard,
        page: () => const AdminDashboardScreen(),
        middlewares: [TRouteMiddleware()]),

    // Admin dashboard tab routes as separate pages
    GetPage(
        name: TRoutes.adminOverview,
        page: () => const AdminDashboardScreen(),
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: TRoutes.adminScholarships,
        page: () => const AdminDashboardScreen(),
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: TRoutes.adminManagement,
        page: () => const AdminDashboardScreen(),
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: TRoutes.adminWebScraper,
        page: () => const AdminDashboardScreen(),
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: TRoutes.scholarshipList,
        page: () => const ScholarshipList(),
        middlewares: [TRouteMiddleware()]),
    // Note: ScholarshipDetails requires a scholarship parameter, so it can't be
    // directly added as a route. It will be navigated to from ScholarshipList
    // using Navigator.push() with arguments.
  ];
}
