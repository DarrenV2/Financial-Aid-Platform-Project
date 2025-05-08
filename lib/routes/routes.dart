class TRoutes {
  static const home = '/';
  static const login = '/login';
  static const signup = '/signup';

  // Route for the screen where users enter their email to request password reset
  static const forgetPassword = '/forgetPassword';

  // Not currently used - Firebase handles the reset UI externally
  // static const resetPassword = '/resetPassword';

  static const userDashboard = '/user-dashboard';

  // Admin dashboard routes
  static const adminDashboard = '/admin-dashboard';
  static const adminOverview = '/admin-dashboard/overview';
  static const adminScholarships = '/admin-dashboard/scholarships';
  static const adminManagement = '/admin-dashboard/admin-management';
  static const adminWebScraper = '/admin-dashboard/web-scraper';

  static const scholarshipList = '/scholarships';
  static const scholarshipDetails = '/scholarship-details';
}
