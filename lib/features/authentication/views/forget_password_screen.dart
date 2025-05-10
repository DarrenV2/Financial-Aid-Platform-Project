import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:financial_aid_project/utils/validators/validation.dart';
import 'package:financial_aid_project/routes/routes.dart';
import 'package:financial_aid_project/data/repositories/authentication/authentication_repository.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ForgetPasswordScreenState createState() => ForgetPasswordScreenState();
}

class ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: 'ForgetPasswordFormKey');
  final TextEditingController _emailController = TextEditingController();
  final isLoading = false.obs;

  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        await AuthenticationRepository.instance
            .resetPassword(_emailController.text.trim());

        isLoading.value = false;

        Get.snackbar(
          'Email Sent',
          'Password reset link has been sent to your email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: TColors.success.withAlpha(179),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Navigate back to login after a delay
        Future.delayed(const Duration(seconds: 3), () {
          Get.offNamed(TRoutes.login);
        });
      } catch (e) {
        isLoading.value = false;

        String errorMessage =
            'Failed to send reset email. Please try again later.';

        // More specific error messages based on common error cases
        if (e.toString().contains('user-not-found')) {
          errorMessage = 'No account found with this email address.';
        } else if (e.toString().contains('invalid-email')) {
          errorMessage = 'The email address is not valid.';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your connection.';
        }

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: TColors.error.withAlpha(179),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TColors.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 768) {
            return _buildWideLayout(context);
          } else {
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "FORGOT PASSWORD",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Don't worry, we'll help you recover your password",
                style: TextStyle(
                  fontSize: 16,
                  color: TColors.textLightGray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildForgetPasswordForm(),
              const SizedBox(height: 16),
              _buildSendButton(),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.toNamed(TRoutes.login),
                style: TextButton.styleFrom(
                  foregroundColor: TColors.primary,
                ),
                child: const Text(
                  "Remember your password? Login",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: FractionallySizedBox(
          widthFactor: 0.6, // Set the width to 60% of the available space
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "FORGOT PASSWORD",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: TColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Don't worry, we'll help you recover your password",
                  style: TextStyle(
                    fontSize: 16,
                    color: TColors.textLightGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildForgetPasswordForm(),
                const SizedBox(height: 16),
                _buildSendButton(),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.toNamed(TRoutes.login),
                  style: TextButton.styleFrom(
                    foregroundColor: TColors.primary,
                  ),
                  child: const Text(
                    "Remember your password? Login",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgetPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'To reset your password, enter the email address you use to sign in. '
            'We will send you a link to reset your password.',
            style: TextStyle(
              fontSize: 14,
              color: TColors.textGray,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "yourmail@gmail.com",
              border: OutlineInputBorder(),
              prefixIcon: Icon(EvaIcons.email, color: TColors.primary),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: TValidator.validateEmail,
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          onPressed: isLoading.value ? null : resetPassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: TColors.primary,
            foregroundColor: TColors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            disabledBackgroundColor: TColors.primary.withAlpha(128),
          ),
          child: isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "SEND RESET LINK",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
