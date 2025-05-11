import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:financial_aid_project/features/scholarship/models/scholarship.dart';
import 'package:intl/intl.dart';

// Define deadline status enum at top level
enum DeadlineStatus {
  soon, // Deadline within 14 days
  open, // Deadline in the future or no deadline (always open)
  closed, // Deadline has passed
  unknown // Could not parse deadline
}

class ScholarshipCard extends StatelessWidget {
  final Scholarship scholarship;
  final VoidCallback? onTap;
  final bool isSaved;
  final bool isEdited;
  final VoidCallback? onSaveToggle;

  const ScholarshipCard({
    super.key,
    required this.scholarship,
    this.onTap,
    this.isSaved = false,
    this.isEdited = false,
    this.onSaveToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Determine deadline status based on actual date comparison
    final DeadlineStatus deadlineStatus =
        _getDeadlineStatus(scholarship.deadline);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section with gradient header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getHeaderColors(deadlineStatus),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(77),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getDeadlineText(deadlineStatus),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            scholarship.amount,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white.withAlpha(77),
                      child: IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.white,
                        ),
                        onPressed: onSaveToggle,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scholarship content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            scholarship.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isEdited)
                          Tooltip(
                            message: 'This scholarship has been updated',
                            child: Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withAlpha(25),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.update,
                                size: 16,
                                color: Colors.amber.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            scholarship.deadline.isEmpty
                                ? 'Deadline: No Deadline'
                                : 'Deadline: ${scholarship.deadline}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        if (scholarship.meritBased)
                          _buildTag('Merit-Based', Colors.blue),
                        if (scholarship.needBased)
                          _buildTag('Need-Based', Colors.orange),
                        if (scholarship.requiredGpa != null)
                          _buildTag(
                              'GPA: ${scholarship.requiredGpa}', Colors.purple),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('View Details'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Get deadline status by comparing dates
  DeadlineStatus _getDeadlineStatus(String deadlineStr) {
    // Check if deadline is empty or null (no deadline/always open)
    if (deadlineStr.isEmpty) {
      return DeadlineStatus.open;
    }

    // Try to parse the deadline string into a DateTime
    DateTime? deadlineDate = _tryParseDate(deadlineStr);

    // If we couldn't parse a date
    if (deadlineDate == null) {
      return DeadlineStatus.unknown;
    }

    // Get current date (without time component)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Compare dates
    if (deadlineDate.isBefore(today)) {
      return DeadlineStatus.closed;
    }

    // Calculate days until deadline
    final daysUntilDeadline = deadlineDate.difference(today).inDays;

    // If deadline is within 14 days, consider it "soon"
    if (daysUntilDeadline <= 14) {
      return DeadlineStatus.soon;
    }

    return DeadlineStatus.open;
  }

  // Helper method to try parsing dates in different formats
  DateTime? _tryParseDate(String dateStr) {
    // List of common date formats to try
    final dateFormats = [
      'yyyy-MM-dd',
      'MM/dd/yyyy',
      'MMMM d, yyyy',
      'MMM d, yyyy',
      'd MMMM yyyy',
      'yyyy.MM.dd',
    ];

    // Try parsing with each format
    for (final format in dateFormats) {
      try {
        return DateFormat(format).parse(dateStr);
      } catch (e) {
        // Continue to next format if this one fails
      }
    }

    // If no formats work, return null
    return null;
  }

  // Get text to display based on deadline status
  String _getDeadlineText(DeadlineStatus status) {
    switch (status) {
      case DeadlineStatus.soon:
        return 'Deadline Soon';
      case DeadlineStatus.open:
        return 'Open';
      case DeadlineStatus.closed:
        return 'Closed';
      case DeadlineStatus.unknown:
        return 'Open'; // Default to open if we can't determine
    }
  }

  // Get header gradient colors based on deadline status
  List<Color> _getHeaderColors(DeadlineStatus status) {
    switch (status) {
      case DeadlineStatus.soon:
        return [
          Colors.orange.shade700,
          Colors.orange.shade400
        ]; // Urgent orange
      case DeadlineStatus.open:
        return [
          Colors.green.shade600,
          Colors.green.shade400
        ]; // Green for open/no deadline
      case DeadlineStatus.closed:
        return [Colors.grey.shade700, Colors.grey.shade500]; // Grey for closed
      case DeadlineStatus.unknown:
        return [
          TColors.primary,
          TColors.primary.withAlpha(180)
        ]; // Default to primary color
    }
  }
}
