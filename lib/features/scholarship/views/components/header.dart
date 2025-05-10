import 'package:flutter/material.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';

class Header extends StatelessWidget {
  final String activePage;

  const Header({
    super.key,
    required this.activePage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Logo or title
              Text(
                'ScholarsHub',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
              ),
              const Spacer(),

              // Navigation links
              if (MediaQuery.of(context).size.width > 600)
                Row(
                  children: [
                    _buildNavLink('Home', activePage == 'home'),
                    _buildNavLink('Scholarships', activePage == 'scholarships'),
                    _buildNavLink('Resources', activePage == 'resources'),
                    _buildNavLink('About', activePage == 'about'),
                  ],
                ),

              // User profile icon
              IconButton(
                icon: const Icon(Icons.account_circle),
                iconSize: 32,
                color: TColors.primary,
                onPressed: () {
                  // Navigate to profile
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavLink(String title, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextButton(
        onPressed: () {
          // Navigation would go here
        },
        style: TextButton.styleFrom(
          foregroundColor: isActive ? TColors.primary : Colors.black54,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
