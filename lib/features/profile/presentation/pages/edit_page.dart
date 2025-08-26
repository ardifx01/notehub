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
                  onPressed: () => Get.back(),
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
          Padding(
            padding: EdgeInsetsGeometry.only(
                left: 30, right: 30, top: 75, bottom: 50),
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: AppColors.disabledTextColor,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text('Ubah Username',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  customTextfield(
                      hintText: authController.user.value?.nama ?? 'Nama Kamu',
                      controller: controller.usernameController),
                  SizedBox(height: 15),
                  Text('Ubah Email',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  customTextfield(
                      hintText:
                          authController.user.value?.email ?? 'Email Kamu',
                      controller: controller.emailController),
                  SizedBox(height: 15),
                  Text('Ubah Password',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  Expanded(child: SizedBox()),
                  customButton(
                    text: "Konfirmasi",
                    onPressed: () {
                      dialogConfirmation(
                        imagePath: 'assets/images/deco_quest.png',
                        title: "Konfirmasi Perubahan",
                        middleText:
                            "Apakah kamu yakin ingin menyimpan perubahan ini?",
                        onConfirm: () async {
                          // await authController.editUser(
                          //   controller.usernameController.text.trim(),
                          //   controller.usernameController.text.trim()
                          // );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
