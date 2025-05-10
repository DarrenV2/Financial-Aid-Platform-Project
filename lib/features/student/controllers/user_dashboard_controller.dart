import 'package:get/get.dart';

class UserDashboardController extends GetxController {
  final RxString activeTab = 'scholarships'.obs;

  void setActiveTab(String tab) {
    activeTab.value = tab;
  }
}
