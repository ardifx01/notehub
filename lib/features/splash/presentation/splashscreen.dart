import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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

    // TODO: Inisialisasi aplikasi, misalnya memuat data awal, konfigurasi, dll.

    // Hitung sisa waktu agar minimal 5 detik
    final elapsed = DateTime.now().difference(start);
    final remaining = Duration(seconds: 5) - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    // // Pindah ke halaman utama (Main akan handle isi user kosong / tidak)
    // Get.offAll(() => Main());
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
