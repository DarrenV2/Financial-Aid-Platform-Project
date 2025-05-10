import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_aid_project/routes/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1024) {
            return _buildDesktopLayout(context);
          } else if (constraints.maxWidth >= 768) {
            return _buildTabletLayout(context);
          } else {
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  // Mobile Layout
  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SCHOLARSHIP & GRANT LOCATOR AND COACHING SYSTEM",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: TColors.textBlue,
              fontFamily: 'Poppins',
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/background.png',
              height: 300, // Adjust for mobile
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Our goal is to make online education work for everyone",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 30),
          _buildActionButtons(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Tablet Layout
  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SCHOLARSHIP & GRANT LOCATOR AND COACHING SYSTEM",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: TColors.textBlue,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Our goal is to make online education work for everyone",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 30),
                _buildActionButtons(context),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Image.asset(
                'assets/images/background.png',
                height: 400, // Adjust for tablet
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Desktop Layout
  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SCHOLARSHIP & GRANT LOCATOR AND COACHING SYSTEM",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: TColors.textBlue,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Our goal is to make online education work for everyone",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 50),
                _buildActionButtons(context),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Image.asset(
                'assets/images/background.png',
                height: 500, // Adjust for desktop
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Action Buttons (Sign Up and Login)
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.textBlue,
              padding: const EdgeInsets.symmetric(vertical: 20),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Get.toNamed(TRoutes.signup),
            child: Text(
              "SIGN UP",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: TColors.borderPrimary),
            ),
            onPressed: () => Get.toNamed(TRoutes.login),
            child: Text(
              "LOGIN",
              style: TextStyle(color: TColors.textBlue),
            ),
          ),
        ),
      ],
    );
  }
}
