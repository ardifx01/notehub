import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/widgets/custom_button.dart';
import 'package:notehub/core/widgets/custom_textfield.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/auth/presentation/controllers/signup_controller.dart';
import 'package:notehub/features/auth/presentation/pages/login_page.dart';
import 'package:notehub/features/home/presentation/home_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final controller = Get.find<SignUpController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: AppColors.primaryColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: AppColors.backgroundColor,
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_horizontal.png',
                  width: 150,
                ),
                SizedBox(height: 30),

                // Login Container
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    height: 420,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: SizedBox.expand(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Judul
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: AppColors.secondaryTextColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),

                            // Input username
                            customTextfield(
                              controller: controller.usernameController,
                              hintText: 'Username',
                            ),
                            SizedBox(height: 20),

                            // Input email
                            customTextfield(
                              controller: controller.emailController,
                              hintText: 'Email',
                            ),
                            SizedBox(height: 20),

                            // Input password
                            Obx(
                              () => customTextfield(
                                hintText: 'Password',
                                controller: controller.passwordController,
                                obscureText: controller.obscurePassword.value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscurePassword.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    controller.togglePasswordVisibility();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 70),

                            // Tombol sign Up
                            Obx(
                              () => customButton(
                                  text: 'Daftar',
                                  color: authController.isLoading.value
                                      ? AppColors.disabledTextColor
                                      : AppColors.buttonColor3,
                                  onPressed: () async {
                                    try {
                                      await authController.signUp(
                                        controller.usernameController.text,
                                        controller.emailController.text,
                                        controller.passwordController.text,
                                      );
                                      Get.off(() => HomePage());
                                    } catch (e) {
                                      Get.snackbar(
                                        'Error',
                                        'Gagal melakukan sign up: $e',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: AppColors.errorColor,
                                        colorText: AppColors.surfaceColor,
                                      );
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 35),

                // Tombol sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(LoginPage(),
                            duration: Duration(milliseconds: 500));
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: AppColors.buttonColor3,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
              ],
            ),
          )
        ],
      ),
    );
  }
}
