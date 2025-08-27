import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/widgets/custom_button.dart';
import 'package:notehub/core/widgets/custom_textfield.dart';
import 'package:notehub/core/widgets/dialog_confirmation.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/profile/presentation/controllers/edit_controller.dart';

class EditPage extends StatelessWidget {
  EditPage({super.key});

  final authController = Get.find<AuthController>();
  final controller = Get.find<EditController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_green.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.surfaceColor),
                  onPressed: () {
                    authController.fotoBaruPath.value = null;
                    Get.back();
                  },
                ),
                SizedBox(width: 10),
                Text("Edit Profile",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.surfaceColor)),
              ],
            ),
          ),

          // -------- container putih + konten utama scrollable
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 75, bottom: 50),
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(18),
              ),
              // konten utama scrollable
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          String? fotoPreview =
                              authController.fotoBaruPath.value;
                          String? fotoUser = authController.user.value?.foto;

                          ImageProvider avatarImage;

                          if (fotoPreview != null) {
                            avatarImage = FileImage(File(fotoPreview));
                          } else if (fotoUser != null && fotoUser.isNotEmpty) {
                            avatarImage = NetworkImage(fotoUser);
                          } else {
                            avatarImage =
                                AssetImage('assets/images/default_avatar.png');
                          }

                          return Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: AppColors.buttonColor2,
                                backgroundImage: avatarImage,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    authController.pilihFotoPreview();
                                  },
                                  child: CircleAvatar( 
                                    radius: 15,
                                    backgroundColor: AppColors
                                        .buttonColor3, // warna lingkaran
                                    child: Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Colors.white, // warna icon
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),

                    SizedBox(height: 30),

                    // Textfield untuk username, email, password
                    Text('Ubah Username',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    customTextfield(
                        hintText:
                            authController.user.value?.nama ?? 'Nama Kamu',
                        controller: controller.usernameController),
                    SizedBox(height: 15),
                    Text('Ubah Email',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    customTextfield(
                        hintText:
                            authController.user.value?.email ?? 'Email Kamu',
                        controller: controller.emailController),
                    SizedBox(height: 15),
                    Text('Ubah Password',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Obx(
                      () => customTextfield(
                          suffixIcon: IconButton(
                            icon: controller.obscurePassword.value
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              controller.togglePasswordVisibility();
                            },
                          ),
                          obscureText: controller.obscurePassword.value,
                          hintText: '',
                          controller: controller.passwordController),
                    ),
                    SizedBox(height: 30),

                    // Tombol konfirmasi
                    Obx(
                      () => customButton(
                        text: authController.isLoading.value
                            ? 'Menyimpan...'
                            : 'Simpan Perubahan',
                        color: authController.isLoading.value
                            ? AppColors.disabledTextColor
                            : AppColors.buttonColor3,
                        onPressed: () {
                          dialogConfirmation(
                            imagePath: 'assets/images/deco_quest.png',
                            title: "Konfirmasi Perubahan",
                            middleText:
                                "Apakah kamu yakin ingin menyimpan perubahan ini?",
                            onConfirm: () async {
                              try {
                                // Melakukan update profil
                                await authController.editUsercon(
                                  controller.usernameController.text
                                          .trim()
                                          .isEmpty
                                      ? authController.user.value?.nama ??
                                          'Nama Error'
                                      : controller.usernameController.text
                                          .trim(),
                                  controller.emailController.text.trim().isEmpty
                                      ? authController.user.value?.email ??
                                          'Email Error'
                                      : controller.emailController.text.trim(),
                                  controller.passwordController.text
                                          .trim()
                                          .isEmpty
                                      ? null
                                      : controller.passwordController.text
                                          .trim(),
                                );
                                // Membersihkan controller
                                controller.clearControllers();
                                // Navigasi kembali ke halaman profil
                                Get.back();
                                Get.snackbar(
                                  'Sukses',
                                  'Profil berhasil diperbarui',
                                );
                              } catch (e) {
                                Get.back(); // tutup dialog
                                Get.snackbar(
                                  'Error',
                                  'Gagal memperbarui profil: $e',
                                  backgroundColor: AppColors.errorColor,
                                  colorText: AppColors.surfaceColor,
                                );
                              }
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
