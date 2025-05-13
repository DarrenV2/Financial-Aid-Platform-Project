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
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(77),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getDeadlineText(deadlineStatus),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            scholarship.amount,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white.withAlpha(77),
                      child: IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.white,
                          size: 24,
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with update indicator
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            scholarship.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isEdited)
                          Tooltip(
                            message: 'This scholarship has been updated',
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withAlpha(40),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.update,
                                size: 18,
                                color: Colors.amber.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      scholarship.description ?? 'No description available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),

                    // Deadline information
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              scholarship.deadline.isEmpty
                                  ? 'No Deadline'
                                  : 'Deadline: ${scholarship.deadline}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
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

                    // View Details button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(100), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.withOpacity(0.8),
          fontSize: 12,
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
