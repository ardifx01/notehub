import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/widgets/custom_button.dart';
import 'package:notehub/core/widgets/custom_textfield.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/auth/presentation/controllers/login_controller.dart'
    show LoginController;
import 'package:notehub/features/auth/presentation/pages/signup_page.dart';
import 'package:notehub/features/home/presentation/home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final controller = Get.find<LoginController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
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

                    // Login Container
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Judul
                            Text(
                              'Login',
                              style: TextStyle(
                                color: AppColors.secondaryTextColor,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
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

                            // Tombol login
                            Obx(
                              () => customButton(
                                text: authController.isLoading.value
                                    ? 'Sedang Masuk..'
                                    : 'Masuk',
                                color: authController.isLoading.value
                                    ? AppColors.disabledTextColor
                                    : AppColors.buttonColor3,
                                onPressed: () async {
                                  // Validasi input
                                  if (controller.emailController.text.isEmpty ||
                                      controller
                                          .passwordController.text.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Email dan password harus diisi',
                                      backgroundColor: AppColors.errorColor,
                                      colorText: AppColors.surfaceColor,
                                    );
                                    return;
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
                                      // Memulai proses login
                                      await authController.login(
                                        controller.emailController.text,
                                        controller.passwordController.text,
                                      );
                                      // Membersihkan controller
                                      controller.emailController.clear();
                                      controller.passwordController.clear();
                                      // Navigasi ke halaman home
                                      Get.off(() => HomePage());
                                    } catch (e) {
                                      Get.snackbar(
                                        'Error',
                                        'Gagal melakukan login: $e',
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

                    // Tombol sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun?',
                          style: TextStyle(
                            color: AppColors.secondaryTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(
                              SignupPage(),
                              duration: const Duration(milliseconds: 500),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: AppColors.buttonColor3,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
