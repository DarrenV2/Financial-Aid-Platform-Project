//import 'package:financial_aid_project/features/scholarship/views/scholarship_list.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:financial_aid_project/features/authentication/controllers/signup_controller.dart';
import 'package:financial_aid_project/routes/routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  // Create local controller instance to avoid disposal issues
  late final SignupController controller;

  // Create a local form key in the view
  final _signupFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controller once
    controller = Get.put(SignupController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "SIGN UP",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Create your new account",
                style: TextStyle(
                  fontSize: 16,
                  color: TColors.textLightGray,
                ),
              ),
              const SizedBox(height: 24),
              _buildSignupForm(),
              const SizedBox(height: 16),
              _buildSignupButton(),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("or"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 15),
              _buildSocialLoginButtons(),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.toNamed(TRoutes.login),
                style: TextButton.styleFrom(
                  foregroundColor: TColors.primary,
                ),
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tablet Layout
  Widget _buildTabletLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: FractionallySizedBox(
          widthFactor: 0.7, // Set the width to 70% of the available space
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: TColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create your new account",
                  style: TextStyle(
                    fontSize: 16,
                    color: TColors.textLightGray,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSignupForm(),
                const SizedBox(height: 16),
                _buildSignupButton(),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 15),
                _buildSocialLoginButtons(),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.toNamed(TRoutes.login),
                  style: TextButton.styleFrom(
                    foregroundColor: TColors.primary,
                  ),
                  child: const Text(
                    "Already have an account? Login",
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

  // Desktop Layout
  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: FractionallySizedBox(
          widthFactor: 0.5, // Set the width to 50% of the available space
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: TColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create your new account",
                  style: TextStyle(
                    fontSize: 16,
                    color: TColors.textLightGray,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSignupForm(),
                const SizedBox(height: 16),
                _buildSignupButton(),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 15),
                _buildSocialLoginButtons(),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.toNamed(TRoutes.login),
                  style: TextButton.styleFrom(
                    foregroundColor: TColors.primary,
                  ),
                  child: const Text(
                    "Already have an account? Login",
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

  Widget _buildSignupForm() {
    return Form(
      key: _signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: controller.firstName,
                  label: "First name",
                  hintText: "Your first name",
                  prefixIcon: EvaIcons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: controller.lastName,
                  label: "Last name",
                  hintText: "Your last name",
                  prefixIcon: EvaIcons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: controller.email,
            label: "Email",
            hintText: "yourmail@gmail.com",
            prefixIcon: EvaIcons.email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          _buildPasswordField(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    IconData? prefixIcon,
    IconData? icon,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: TColors.primary)
            : null,
        suffixIcon: icon != null ? Icon(icon, color: TColors.primary) : null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => TextFormField(
        controller: controller.password,
        obscureText: controller.hidePassword.value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          if (!value.contains(RegExp(r'[A-Z]'))) {
            return 'Password must contain at least one capital letter';
          }
          if (!value.contains(RegExp(r'[0-9]'))) {
            return 'Password must contain at least one number';
          }
          if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
            return 'Password must contain at least one special character';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "Must include capital, number & special character",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: const Icon(EvaIcons.lock, color: TColors.primary),
          suffixIcon: IconButton(
            icon: Icon(
              controller.hidePassword.value ? EvaIcons.eyeOff : EvaIcons.eye,
              color: TColors.primary,
            ),
            onPressed: () {
              controller.hidePassword.value = !controller.hidePassword.value;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSignupButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Ensure the widget is still mounted
          if (!mounted) return;

          // Safely trim all input fields before validation
          final firstNameText = controller.firstName.text.trim();
          final lastNameText = controller.lastName.text.trim();
          final emailText = controller.email.text.trim();
          final passwordText = controller.password.text.trim();

          // Only update text controllers if widget is still mounted
          if (mounted) {
            controller.firstName.text = firstNameText;
            controller.lastName.text = lastNameText;
            controller.email.text = emailText;
            controller.password.text = passwordText;
          }

          if (_signupFormKey.currentState!.validate()) {
            controller.registerUser();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: TColors.primary,
          foregroundColor: TColors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "SIGN UP",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.white,
                foregroundColor: TColors.black,
                side: const BorderSide(color: TColors.grey),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              icon: const Icon(EvaIcons.google),
              onPressed: () {},
              label: const Text("Sign Up with Google"),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.black,
                foregroundColor: TColors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              icon: const Icon(Icons.apple),
              onPressed: () {},
              label: const Text("Sign Up with Apple"),
            ),
          ),
        ),
      ],
    );
  }
}
