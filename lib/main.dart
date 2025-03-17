import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//removed due to implemeting rounting
//import 'package:financial_aid_project/features/authentication/views/home_screen.dart';
import 'package:get/get.dart';
import 'package:financial_aid_project/data/repositories/authentication/authentication_repository.dart';
import 'package:financial_aid_project/routes/app_routes.dart';
import 'package:financial_aid_project/routes/routes.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:get_storage/get_storage.dart';
import 'package:financial_aid_project/features/authentication/controllers/login_controller.dart';
import "package:financial_aid_project/utils/helpers/general_bindings.dart";
import 'package:financial_aid_project/utils/scripts/create_default_admin.dart';

Future<void> main() async {
  // Remove # in url
  setPathUrlStrategy();

  // Initialize GetStorage
  await GetStorage.init();

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));

  // Register the LoginController globally
  Get.put(LoginController());

  // Create default admin account if not exists
  // This script checks if admin exists before attempting creation
  await DefaultAdminCreator.createDefaultAdmin();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Financial Aid Platform',
      theme: ThemeData(primarySwatch: Colors.blue),
      //home: HomeScreen(),//this isnt nessasary so removed, because of initial routing below, do same for new pages
      getPages: TAppRoute.pages, //expand on this
      initialBinding: GeneralBindings(), //------------------
      initialRoute: TRoutes.home, // Ensure initial route is set to home
      unknownRoute: GetPage(
          name: '/page-not-found',
          page: () =>
              const Scaffold(body: Center(child: Text('Page Not Found')))),
      //unknown route is a placeholder justin can add an appropriate gui
    );
  }
}
