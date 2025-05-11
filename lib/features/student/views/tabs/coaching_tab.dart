import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_aid_project/features/coaching/views/screens/coaching_main_screen.dart';
import 'package:financial_aid_project/features/coaching/controllers/coaching_controller.dart';
import 'package:financial_aid_project/features/coaching/controllers/learning_controller.dart';

class CoachingTab extends StatefulWidget {
  const CoachingTab({Key? key}) : super(key: key);

  @override
  State<CoachingTab> createState() => _CoachingTabState();
}

class _CoachingTabState extends State<CoachingTab> {
  late final CoachingController coachingController;
  late final LearningController learningController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    coachingController = Get.put(CoachingController());
    learningController = Get.put(LearningController());

    // Refresh data after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    // Force refresh data from Firestore
    await coachingController.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return const CoachingMainScreen();
  }
}
