import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:notehub/core/const/colors.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Stack(
          children: [    
          Text("Selamat Datang!", style: TextStyle(fontSize: 50, color: AppColors.textFieldColor),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/deco_intro.png',
                width: 500,
                height: 800,
              ),
            ),
          ],
        ),
        floatingActionButton: SizedBox(
          width: 350,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {},
            elevation: 0,
            highlightElevation: 0,
            child: const Text(
              "Mulai",
              style: TextStyle(
                fontSize: 25,
                color: AppColors.tertiaryTextColor,
              ),
            ),
            backgroundColor: AppColors.buttonColor3,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: IntroPage(),
//   ));
// }
