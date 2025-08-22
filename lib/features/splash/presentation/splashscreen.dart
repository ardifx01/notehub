import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notehub/features/auth/presentation/pages/error_page.dart';
import 'package:notehub/features/auth/presentation/pages/login_page.dart';
import 'package:notehub/features/home/presentation/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final start = DateTime.now();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("user_id"); // misalnya kamu simpan userId

      // Hitung sisa waktu agar minimal 5 detik
      final elapsed = DateTime.now().difference(start);
      final remaining = Duration(seconds: 5) - elapsed;
      if (remaining > Duration.zero) {
        await Future.delayed(remaining);
      }

      if (userId != null && userId.isNotEmpty) {
        Get.offAll(() => HomePage());
      } else {
        Get.offAll(() => LoginPage());
      }
    } catch (e) {
      Get.offAll(() => ErrorPage());
    }
  }

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
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon_vertical.png',
                width: 200,
                height: 200,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Color(0xFFFFF6D1),
              size: 40,
            ),
          ),
        ),
      ],
    ));
  }
}
