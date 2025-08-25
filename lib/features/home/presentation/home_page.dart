import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/auth/presentation/pages/login_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(authController.user.value?.nama?? 'No Name'),
            Text(authController.user.value?.email ?? 'No Email'),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  await authController.logout();
                  if (authController.isLoggedIn == false) {
                    Get.offAll(LoginPage());
                  } else {
                    Get.snackbar('Error', 'Logout failed');
                  }
                },
                child: Text('Logout')),
          ],
        ),
      ),
    );
  }
}
