import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/widgets/heatmap_callendar.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/profile/presentation/pages/profile_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bagian atas hijau dengan ilustrasi dan avatar
            Container(
              width: double.infinity,
              color: AppColors.primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: Obx(
                          () => CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            backgroundImage: authController.user.value?.foto !=
                                    null
                                ? NetworkImage(authController.user.value!.foto)
                                : const AssetImage(
                                    'assets/images/avatar_placeholder.png'),
                          ),
                        ),
                        onTap: () {
                          Get.to(ProfilePage());
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      'assets/images/deco_home.png',
                      height: 230,
                    ),
                  ],
                ),
              ),
            ),

            // Bagian putih dengan konten
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Ide hebat apa yang ingin kamu\ntulis hari ini?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon:
                          const Icon(Icons.add, color: AppColors.surfaceColor),
                      label: const Text(
                        "Buat Note",
                        style: TextStyle(
                            color: AppColors.surfaceColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor3,
                        foregroundColor: AppColors.surfaceColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Tiga kotak menu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              // aksi ketika "Jelajahi Notes" ditekan
                              print("Jelajahi Notes ditekan");
                            },
                            child: Container(
                              height: 210,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/fyp.png',
                                      height: 60,
                                    ),
                                    Text(
                                      "Jelajahi Notes",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // aksi ketika "Notes Disimpan" ditekan
                                  print("Notes Disimpan ditekan");
                                },
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.buttonColor2,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/notes.png',
                                            height: 50,
                                          ),
                                          Text(
                                            "Daftar Notes\nKamu",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  // aksi ketika "Notes Disimpan" ditekan
                                  print("Notes Disimpan ditekan");
                                },
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.buttonColor3,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/bookmark.png',
                                            height: 50,
                                          ),
                                          Text(
                                            "Notes\nDisimpan",
                                            
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                    // Judul kalender heatmap
                    const SizedBox(height: 30),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Kalender Heatmap",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Kalender ini nunjukin frekuensi kamu nulis note tiap hari!",
                        style: TextStyle(
                            fontSize: 12, color: AppColors.disabledTextColor),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Kalender heatmap
                    HeatmapCalendar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
