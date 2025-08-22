import 'package:flutter/material.dart';
import 'package:notehub/core/const/colors.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background_green.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Container(
              height: 330,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/deco_quest.png',
                        scale: 4,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Ada Yang Salah',
                        style: TextStyle(
                            color: AppColors.secondaryTextColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                          textAlign: TextAlign.center,
                          'Terjadi kesalahan saat ambil data, pastikan kamu tersambung dengan internet.',
                          style: TextStyle(
                            color: AppColors.disabledTextColor,
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
