import 'package:flutter/material.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';

class Filters extends StatelessWidget {
  final bool meritBased;
  final bool needBased;
  final double gpa;
  final Function(bool) onMeritBasedChanged;
  final Function(bool) onNeedBasedChanged;
  final Function(double) onGpaChanged;

  const Filters({
    super.key,
    required this.meritBased,
    required this.needBased,
    required this.gpa,
    required this.onMeritBasedChanged,
    required this.onNeedBasedChanged,
    required this.onGpaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Filters',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                onMeritBasedChanged(false);
                onNeedBasedChanged(false);
                onGpaChanged(0.0);
              },
              tooltip: 'Reset Filters',
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Merit-based filter
        SwitchListTile(
          title: const Text('Merit-Based'),
          subtitle: const Text('Scholarships based on academic achievements'),
          value: meritBased,
          onChanged: onMeritBasedChanged,
          dense: true,
          activeColor: TColors.primary,
        ),

        // Need-based filter
        SwitchListTile(
          title: const Text('Need-Based'),
          subtitle: const Text('Scholarships based on financial need'),
          value: needBased,
          onChanged: onNeedBasedChanged,
          dense: true,
          activeColor: TColors.primary,
        ),

        // GPA filter
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Minimum GPA: ${gpa.toStringAsFixed(1)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Slider(
                value: gpa,
                min: 0.0,
                max: 4.0,
                divisions: 8,
                label: gpa.toStringAsFixed(1),
                onChanged: onGpaChanged,
                activeColor: TColors.primary,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('0.0'),
                  Text('1.0'),
                  Text('2.0'),
                  Text('3.0'),
                  Text('4.0'),
                ],
              ),
            ],
          ),
        ),

        const Divider(),

        // Filter note
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Note: More filters will be available soon.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
