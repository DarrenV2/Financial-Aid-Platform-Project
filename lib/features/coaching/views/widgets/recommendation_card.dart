import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/assessment_result.dart';

class RecommendationCard extends StatelessWidget {
  final Recommendation recommendation;

  const RecommendationCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: _getPriorityColor(recommendation.priority),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(recommendation.priority),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getPriorityLabel(recommendation.priority),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              recommendation.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Navigate to detailed view using GetX
                    Get.toNamed(
                      '/coaching/recommendation',
                      arguments: {'recommendation': recommendation},
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Learn More'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 5:
        return Colors.red;
      case 4:
        return Colors.deepOrange;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.amber;
      case 1:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 5:
        return 'High Priority';
      case 4:
        return 'Important';
      case 3:
        return 'Medium Priority';
      case 2:
        return 'Recommended';
      case 1:
        return 'Optional';
      default:
        return 'Priority $priority';
    }
  }
}
