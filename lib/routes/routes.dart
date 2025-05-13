class TRoutes {
  static const home = '/';
  static const login = '/login';
  static const signup = '/signup';

  // Route for the screen where users enter their email to request password reset
  static const forgetPassword = '/forgetPassword';

  // Not currently used - Firebase handles the reset UI externally
  // static const resetPassword = '/resetPassword';

  // User dashboard routes
  static const userDashboard = '/user-dashboard';
  static const userScholarships = '/user-dashboard/scholarships';
  static const userApplications = '/user-dashboard/applications';
  static const userProfile = '/user-dashboard/profile';
  static const userCoaching = '/user-dashboard/coaching';

  // Admin dashboard routes
  static const adminDashboard = '/admin-dashboard';
  static const adminOverview = '/admin-dashboard/overview';
  static const adminScholarships = '/admin-dashboard/scholarships';
  static const adminManagement = '/admin-dashboard/admin-management';
  static const adminWebScraper = '/admin-dashboard/web-scraper';

  static const scholarshipList = '/scholarships';
  static const scholarshipDetails = '/scholarship-details';
  static const savedScholarships = '/saved-scholarships';

  // Coaching routes
  static const coaching = '/coaching';
  static const coachingAssessment = '/coaching/assessment';
  static const coachingResults = '/coaching/results';
  static const learningPlan = '/coaching/learning-plan';
  static const moduleDetail = '/coaching/module';
  static const recommendationDetail = '/coaching/recommendation';

  // Post-assessment routes
  static const postAssessment = '/coaching/post-assessment';
  static const postResults = '/coaching/post-results';
}
