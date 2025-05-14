import 'package:get/get.dart';
import 'package:financial_aid_project/data/models/admin/admin_model.dart';
import 'package:financial_aid_project/data/repositories/admin/admin_repository.dart';
import 'package:financial_aid_project/data/repositories/authentication/authentication_repository.dart';
import 'package:financial_aid_project/utils/popups/loaders.dart';

class AdminProfileController extends GetxController {
  static AdminProfileController get instance => Get.find();

  final adminRepository = Get.put(AdminRepository());
  final _authRepo = AuthenticationRepository.instance;

  // Observable admin data
  final Rx<AdminModel> admin = AdminModel.empty().obs;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdminProfile();
  }

  // Fetch the current admin's profile data
  Future<void> fetchAdminProfile() async {
    try {
      isLoading.value = true;

      // If user is authenticated, get their details
      if (_authRepo.isAuthenticated) {
        final uid = _authRepo.authUser!.uid;
        final adminData = await adminRepository.fetchAdminDetails(uid);
        admin.value = adminData;
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to load admin profile: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Handle logout
  Future<void> logout() async {
    try {
      await _authRepo.logout();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Logout Failed',
        message: e.toString(),
      );
    }
  }

  // Get admin initials for avatar
  String get adminInitials {
    String initials = 'A';
    if (admin.value.firstName?.isNotEmpty == true) {
      initials = admin.value.firstName![0];

      if (admin.value.lastName?.isNotEmpty == true) {
        initials += admin.value.lastName![0];
      }
    }
    return initials.toUpperCase();
  }
}
