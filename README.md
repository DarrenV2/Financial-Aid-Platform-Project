# Financial Aid Platform

A comprehensive Flutter application designed to help students find, apply for, and manage scholarships while providing personalized coaching for academic and financial success.

## Features

### User Features

- **Scholarship Discovery**: Browse, search, and filter available scholarships
- **Personalized Dashboard**: Track applications, saved scholarships, and progress
- **Financial Coaching**: Take assessments and receive personalized learning plans
- **User Profile**: Manage personal information and application preferences

### Administrative Features

- **Dashboard Overview**: Monitor platform metrics and user engagement
- **Scholarship Management**: Add, edit, and manage scholarship listings

## Tech Stack

- **Frontend**: Flutter with GetX state management
- **Backend**: Firebase (Authentication, Cloud Firestore, Storage)
- **AI Integration**: Google Generative AI for chatbot
- **Authentication**: Email/password and Google Sign-In

## Getting Started

### Prerequisites

- Flutter SDK (^3.6.2)
- Dart SDK
- Firebase account
- Google Cloud Platform account (for Generative AI features)

### Installation

1. Clone the repository

   ```
   git clone https://github.com/DarrenV2/financial_aid_project.git
   ```

2. Navigate to the project directory

   ```
   cd financial_aid_project
   ```

3. Install dependencies

   ```
   flutter pub get
   ```

4. Run the app
   ```
   flutter run
   ```

### Firebase Setup

1. Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/)
2. Add your app to the Firebase project
3. Download the `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) file
4. Place the configuration files in the appropriate directories

## Project Structure

- `lib/features/` - Contains different modules of the application
  - `authentication/` - User authentication flows
  - `scholarship/` - Scholarship listing and management
  - `student/` - Student dashboard and profile management
  - `coaching/` - Assessment and personalized coaching features
  - `administration/` - Admin dashboard and management tools
- `lib/data/` - Data models and repositories
- `lib/utils/` - Utility functions and helpers
- `lib/routes/` - Navigation routes
- `lib/shared_components/` - Reusable UI components

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter and Dart team for the amazing framework
- Firebase for backend services
- Contributors and testers who helped improve this platform
