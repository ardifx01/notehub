import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/widgets/custom_big_button.dart';
import 'package:notehub/features/home/presentation/home_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 100, left: 25, right: 25),
              child: Column(
                children: [
                  Text(
                    "Selamat Datang!",
                    style: TextStyle(
                        fontSize: 36,
                        color: AppColors.textFieldColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Yuk mulai tulis ide atau cerita kamu secara global disini, atau cari motivasi dengan lihat note dari berbagai pengguna di dunia! ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: AppColors.textFieldColor),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Image.asset(
                'assets/images/deco_intro.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: CustomBigButton(
              text: 'Mulai',
              onPressed: () {
                Get.to(HomePage(), transition: Transition.fade);
              },
              backgroundColor: AppColors.buttonColor3,
              textColor: AppColors.surfaceColor)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
