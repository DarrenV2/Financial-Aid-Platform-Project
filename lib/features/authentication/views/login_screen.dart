import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:financial_aid_project/features/authentication/controllers/login_controller.dart';
import 'package:financial_aid_project/utils/validators/validation.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:financial_aid_project/routes/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // Use a local form key instead of one from controller
  final _loginFormKey = GlobalKey<FormState>();
  // Create local controller instance to avoid disposal issues
  late final LoginController loginController;

  // Create local text editing controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the controller here
    loginController = Get.find<LoginController>();

    // Initialize local controllers with remembered values from controller
    _emailController.text = loginController.rememberedEmail ?? '';
    _passwordController.text = loginController.rememberedPassword ?? '';
  }

  @override
  void dispose() {
    // Dispose local controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Don't get a new instance here
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1024) {
            return _buildDesktopLayout(context, loginController);
          } else if (constraints.maxWidth >= 768) {
            return _buildTabletLayout(context, loginController);
          } else {
            return _buildMobileLayout(context, loginController);
          }
        },
      ),
    );
  }

  // Mobile Layout
  Widget _buildMobileLayout(
      BuildContext context, LoginController loginController) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: TColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sign in to your account (Admin or User)",
                  style: TextStyle(
                    fontSize: 16,
                    color: TColors.textLightGray,
                  ),
                ),
                const SizedBox(height: 24),
                _buildLoginForm(context, loginController),
                const SizedBox(height: 16),
                _buildLoginButton(context, loginController),
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
                  onPressed: () => Get.toNamed(TRoutes.signup),
                  style: TextButton.styleFrom(
                    foregroundColor: TColors.primary,
                  ),
                  child: const Text(
                    "Don't have an account? Sign up",
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

  // Tablet Layout
  Widget _buildTabletLayout(
      BuildContext context, LoginController loginController) {
    return Center(
      child: SingleChildScrollView(
        child: FractionallySizedBox(
          widthFactor: 0.7, // Set the width to 70% of the available space
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: TColors.primary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sign in to your account (Admin or User)",
                    style: TextStyle(
                      fontSize: 16,
                      color: TColors.textLightGray,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLoginForm(context, loginController),
                  const SizedBox(height: 16),
                  _buildLoginButton(context, loginController),
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
                    onPressed: () => Get.toNamed(TRoutes.signup),
                    style: TextButton.styleFrom(
                      foregroundColor: TColors.primary,
                    ),
                    child: const Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Desktop Layout
  Widget _buildDesktopLayout(
      BuildContext context, LoginController loginController) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(80),
            color: TColors.primary,
            child: Image.asset(
              'assets/images/hero.png', // Path to your image
              height: 500, // Adjust height as needed
              width: 500, // Adjust width as needed
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: SingleChildScrollView(
              child: FractionallySizedBox(
                widthFactor: 0.6, // Set the width to 60% of the available space
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: TColors.primary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Sign in to your account (Admin or User)",
                        style: TextStyle(
                          fontSize: 16,
                          color: TColors.textLightGray,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildLoginForm(context, loginController),
                      const SizedBox(height: 16),
                      _buildLoginButton(context, loginController),
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
                        onPressed: () => Get.toNamed(TRoutes.signup),
                        style: TextButton.styleFrom(
                          foregroundColor: TColors.primary,
                        ),
                        child: const Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(
      BuildContext context, LoginController loginController) {
    return Column(
      children: [
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
        const SizedBox(height: 15),
        Obx(
          () => TextFormField(
            controller: _passwordController,
            obscureText: loginController.hidePassword.value,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "********",
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(EvaIcons.lock, color: TColors.primary),
              suffixIcon: IconButton(
                icon: Icon(
                  loginController.hidePassword.value
                      ? EvaIcons.eyeOff
                      : EvaIcons.eye,
                  color: TColors.primary,
                ),
                onPressed: () {
                  loginController.hidePassword.value =
                      !loginController.hidePassword.value;
                },
              ),
            ),
            validator: TValidator.validatePassword,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    value: loginController.rememberMe.value,
                    activeColor: TColors.primary,
                    onChanged: (value) {
                      if (mounted) {
                        loginController.rememberMe.value = value ?? false;
                        if (value == true) {
                          // Use the controller's method for saving credentials
                          loginController.saveCredentials(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                        } else {
                          // Use the controller's method for clearing credentials
                          loginController.clearCredentials();
                        }
                      }
                    },
                  ),
                ),
                const Text("Remember me"),
              ],
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(TRoutes.forgetPassword);
              },
              style: TextButton.styleFrom(
                foregroundColor: TColors.primary,
              ),
              child: const Text("Forgot Password?"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton(
      BuildContext context, LoginController loginController) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: TColors.primary,
          foregroundColor: TColors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () async {
          // Ensure the controller is still valid
          if (!mounted) return;

          // Safely trim input spaces before validation
          final emailText = _emailController.text.trim();
          final passwordText = _passwordController.text.trim();

          // Only modify the text controllers if widget is still mounted
          if (mounted) {
            _emailController.text = emailText;
            _passwordController.text = passwordText;
          }

          if (_loginFormKey.currentState!.validate()) {
            // Pass email and password directly to the sign in method
            await loginController.emailAndPasswordSignIn(
              emailText,
              passwordText,
            );
          }
        },
        child: const Text(
          "LOGIN",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return Padding(
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
        onPressed: () {
          // Ensure the controller is still valid
          if (mounted) {
            loginController.googleSignIn();
          }
        },
        label: const Text("Sign In with Google"),
      ),
    );
  }
}
