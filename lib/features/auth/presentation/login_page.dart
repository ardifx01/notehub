import 'package:flutter/material.dart';
import 'package:notehub/core/const/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: AppColors.primaryColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: AppColors.backgroundColor,
                ),
              )
            ],
          ),

          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_horizontal.png',
                  width: 150,
                ),
                SizedBox(height: 30),

                // Login Container
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    height: 350,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox.expand(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Login',
                              style: TextStyle(
                                color: AppColors.primaryTextColor,
                                fontSize: 32,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 35),

                // Tombol sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun?',
                      style: TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to registration page
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColors.buttonColor3,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80),
              ],
            ),
          )
        ],
      ),
    );
  }
}
