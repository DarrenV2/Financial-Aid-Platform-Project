import 'package:flutter/material.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Example notifications
            _buildNotificationList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    // This would typically be populated from a database or API
    // For now, we'll use placeholder data
    final notifications = [
      _NotificationItem(
        title: 'New Scholarship Available',
        message: 'A new scholarship matching your profile is available.',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        type: _NotificationType.alert,
        isRead: false,
      ),
      _NotificationItem(
        title: 'Application Status',
        message: 'Your application for Technology Grant has been received.',
        time: DateTime.now().subtract(const Duration(days: 1)),
        type: _NotificationType.info,
        isRead: true,
      ),
      _NotificationItem(
        title: 'Profile Update',
        message: 'Please complete your profile to improve scholarship matches.',
        time: DateTime.now().subtract(const Duration(days: 3)),
        type: _NotificationType.reminder,
        isRead: true,
      ),
    ];

    if (notifications.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications_none, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No notifications yet',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'When you receive notifications, they will appear here',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: _buildNotificationIcon(notification.type),
            title: Text(
              notification.title,
              style: TextStyle(
                fontWeight:
                    notification.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(notification.message),
                const SizedBox(height: 4),
                Text(
                  _formatNotificationTime(notification.time),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(12),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildNotificationIcon(_NotificationType type) {
    IconData icon;
    Color color;

    switch (type) {
      case _NotificationType.alert:
        icon = Icons.notifications_active;
        color = Colors.red;
        break;
      case _NotificationType.info:
        icon = Icons.info;
        color = Colors.blue;
        break;
      case _NotificationType.reminder:
        icon = Icons.schedule;
        color = Colors.orange;
        break;
    }

    return CircleAvatar(
      backgroundColor: color.withAlpha(51),
      child: Icon(icon, color: color, size: 20),
    );
  }

  String _formatNotificationTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
    }
  }
}

// Simple enum for notification types
enum _NotificationType { alert, info, reminder }

// Simple class to represent a notification
class _NotificationItem {
  final String title;
  final String message;
  final DateTime time;
  final _NotificationType type;
  final bool isRead;

  _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });
}
