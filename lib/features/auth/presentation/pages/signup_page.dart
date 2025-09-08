import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/widgets/custom_button.dart';
import 'package:notehub/core/widgets/custom_textfield.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/auth/presentation/controllers/signup_controller.dart';
import 'package:notehub/features/auth/presentation/pages/intro_page.dart';
import 'package:notehub/features/auth/presentation/pages/login_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final controller = Get.find<SignUpController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height, // min tinggi 1 layar
          ),
          child: Stack(
            children: [
              // Background
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.33,
                    color: AppColors.primaryColor,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.67,
                    color: AppColors.backgroundColor,
                  ),
                ],
              ),

              // Content
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 90),
                    Image.asset(
                      'assets/images/logo_horizontal.png',
                      width: 150,
                    ),
                    const SizedBox(height: 30),

                    // Form Container
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Judul
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColors.secondaryTextColor,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Input username
                            customTextfield(
                              controller: controller.usernameController,
                              hintText: 'Username',
                            ),
                            const SizedBox(height: 20),

                            // Input email
                            customTextfield(
                              controller: controller.emailController,
                              hintText: 'Email',
                            ),
                            const SizedBox(height: 20),

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
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Tombol sign Up
                            Obx(
                              () => customButton(
                                text: authController.isLoading.value
                                    ? 'Sedang Mendaftar..'
                                    : 'Daftar',
                                color: authController.isLoading.value
                                    ? AppColors.disabledTextColor
                                    : AppColors.buttonColor3,
                                onPressed: () async {
                                  // Validasi input terisi/tidak
                                  if (controller
                                          .usernameController.text.isEmpty ||
                                      controller.emailController.text.isEmpty ||
                                      controller
                                          .passwordController.text.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Semua field input harus diisi',
                                      backgroundColor: AppColors.errorColor,
                                      colorText: AppColors.surfaceColor,
                                    );
                                    return;
                                    // Validasi struktur email
                                  } else if (!EmailValidator.validate(
                                      controller.emailController.text)) {
                                    Get.snackbar(
                                      'Error',
                                      'Pastikan struktur email valid',
                                      backgroundColor: AppColors.errorColor,
                                      colorText: AppColors.surfaceColor,
                                    );
                                  } else {
                                    try {
                                      await authController.signUp(
                                        controller.usernameController.text,
                                        controller.emailController.text,
                                        controller.passwordController.text,
                                      );
                                      Get.off(() => IntroPage(),
                                          transition: Transition.native);
                                    } catch (e) {
                                      Get.snackbar(
                                        'Error',
                                        'Gagal melakukan sign up: $e',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: AppColors.errorColor,
                                        colorText: AppColors.surfaceColor,
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Tombol login
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
                                duration: const Duration(milliseconds: 500));
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.buttonColor3,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
