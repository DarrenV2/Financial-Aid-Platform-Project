import 'package:financial_aid_project/features/administration/views/admin_dashboard_screen.dart';
import 'package:financial_aid_project/features/student/views/user_dashboard_screen.dart';
import 'package:financial_aid_project/features/authentication/views/forget_password_screen.dart';
import 'package:financial_aid_project/features/authentication/views/home_screen.dart';
import 'package:financial_aid_project/features/authentication/views/login_screen.dart';
import 'package:financial_aid_project/features/authentication/views/signup.screen.dart';
import 'package:financial_aid_project/features/scholarship/views/scholarship_list.dart';
import 'package:financial_aid_project/features/scholarship/views/saved_scholarships_screen.dart';
import 'package:financial_aid_project/features/coaching/views/screens/coaching_main_screen.dart';
import 'package:financial_aid_project/features/coaching/views/screens/assessment_screen.dart';
import 'package:financial_aid_project/features/coaching/views/screens/assessment_result_screen.dart';
import 'package:financial_aid_project/features/coaching/views/screens/learning_plan_screen.dart';
import 'package:financial_aid_project/features/coaching/views/screens/module_detail_screen.dart';
import 'package:financial_aid_project/features/coaching/views/screens/recommendation_detail_screen.dart';
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

    // User dashboard tab routes as separate pages
    GetPage(
        name: TRoutes.userScholarships,
        page: () => const UserDashboardScreen(),
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: TRoutes.userApplications,
        page: () => const UserDashboardScreen(),
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: TRoutes.userProfile,
        page: () => const UserDashboardScreen(),
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: TRoutes.userCoaching,
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

    GetPage(
        name: TRoutes.savedScholarships,
        page: () => const SavedScholarshipsScreen(),
        middlewares: [TRouteMiddleware()]),

    // Coaching routes
    GetPage(
        name: TRoutes.coaching,
        page: () => const CoachingMainScreen(),
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: TRoutes.coachingAssessment,
        page: () {
          final args = Get.arguments as Map<String, dynamic>;
          final isPreAssessment = args['isPreAssessment'] as bool;
          return AssessmentScreen(isPreAssessment: isPreAssessment);
        },
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: TRoutes.coachingResults,
        page: () {
          final args = Get.arguments as Map<String, dynamic>;
          final result = args['result'];
          final isPostAssessment = args['isPostAssessment'] as bool? ?? false;
          return AssessmentResultScreen(
            result: result,
            isPostAssessment: isPostAssessment,
          );
        },
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: TRoutes.learningPlan,
        page: () {
          final args = Get.arguments as Map<String, dynamic>;
          final result = args['result'];
          return LearningPlanScreen(result: result);
        },
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: TRoutes.moduleDetail,
        page: () {
          final args = Get.arguments as Map<String, dynamic>;
          final module = args['module'];
          return ModuleDetailScreen(module: module);
        },
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: TRoutes.recommendationDetail,
        page: () {
          final args = Get.arguments as Map<String, dynamic>;
          final recommendation = args['recommendation'];
          return RecommendationDetailScreen(recommendation: recommendation);
        },
        middlewares: [TRouteMiddleware()]),
    // Note: ScholarshipDetails requires a scholarship parameter, so it can't be
    // directly added as a route. It will be navigated to from ScholarshipList
    // using Navigator.push() with arguments.
  ];
}
