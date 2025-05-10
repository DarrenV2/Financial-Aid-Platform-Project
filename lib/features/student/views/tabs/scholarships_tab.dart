import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_aid_project/features/scholarship/controllers/scholarship_controllers.dart';
import 'package:financial_aid_project/features/scholarship/views/scholarship_overview.dart';

class ScholarshipsTab extends StatefulWidget {
  const ScholarshipsTab({super.key});

  @override
  State<ScholarshipsTab> createState() => _ScholarshipsTabState();
}

class _ScholarshipsTabState extends State<ScholarshipsTab> {
  final ScholarshipController _controller = Get.put(ScholarshipController());

  @override
  void initState() {
    super.initState();
    _controller.fetchScholarships();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScholarshipOverview(
        isEmbedded: true,
      ),
    );
  }
}
