import 'package:get/get.dart';
import 'network_manager.dart'; // Ensure these are correct
import 'package:financial_aid_project/features/authentication/controllers/user_controller.dart'; // Ensure these are correct
import 'package:financial_aid_project/features/authentication/controllers/login_controller.dart';
import 'package:financial_aid_project/features/authentication/controllers/signup_controller.dart';
import 'package:financial_aid_project/features/authentication/controllers/admin_controller.dart';
import 'package:financial_aid_project/data/repositories/admin/admin_repository.dart';
import 'package:financial_aid_project/features/coaching/controllers/coaching_controller.dart';
import 'package:financial_aid_project/features/coaching/controllers/learning_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    /// -- Core
    Get.lazyPut(() => NetworkManager(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => SignupController(), fenix: true);
    Get.put(AdminRepository());
    Get.lazyPut(() => AdminController(), fenix: true);

    /// -- Feature Controllers
    Get.lazyPut(() => CoachingController(), fenix: true);
    Get.lazyPut(() => LearningController(), fenix: true);
  }
}
