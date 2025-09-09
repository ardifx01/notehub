import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/functions/convert_date.dart';
import 'package:notehub/core/widgets/dialog_confirmation.dart';
import 'package:notehub/core/widgets/heatmap_callendar.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/auth/presentation/pages/login_page.dart';
import 'package:notehub/features/note/presentation/controllers/note_controller.dart';
import 'package:notehub/features/profile/presentation/pages/edit_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final authController = Get.find<AuthController>();
  final noteController = Get.find<NoteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor, // warna background utama
      body: Column(
        children: [
          // konten utama scrollable
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ================= HEADER HIJAU DENGAN GAMBAR =================
                  Stack(
                    children: [
                      // background header
                      SizedBox(
                        height: 170,
                        width: double.infinity,
                        child: Image.asset(
                          "assets/images/header_prof.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),

                      // tombol kembali (back)
                      Positioned(
                        top: 40,
                        left: 10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.surfaceColor,
                          ),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ],
                  ),

                  // ================= CONTAINER PUTIH BERISI PROFIL =================
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // container putih untuk konten profil
                      Container(
                        margin: const EdgeInsets.only(
                            top: 60), // ruang untuk avatar
                        padding: const EdgeInsets.only(top: 50, bottom: 20),
                        width: double.infinity,
                        color: AppColors.surfaceColor,
                        child: Column(
                          children: [
                            // nama user
                            SelectableText(
                              authController.user.value?.nama ?? "Loading...",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // tombol edit profil
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonColor3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0),
                              onPressed: () {
                                Get.to(EditPage());
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: AppColors.surfaceColor,
                              ),
                              label: const Text(
                                "Edit Profil",
                                style: TextStyle(
                                  color: AppColors.surfaceColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ================= INFO BOX (Sejak, Notes, Disimpan) =================
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () {
                                      final createdAt =
                                          authController.user.value?.createdAt;
                                      return _InfoBox(
                                        title: "Sejak",
                                        value: createdAt != null
                                            ? formatTanggal(createdAt)
                                            : "-", // fallback kalau null
                                      );
                                    },
                                  ),
                                  Obx(() {
                                    final jumlahNotes =
                                        noteController.notes.length;
                                    return _InfoBox(
                                        title: "Notes",
                                        value: jumlahNotes.toString());
                                  }),
                                  Obx(() {
                                    final jumlahSavedNotes =
                                        noteController.savedNotes.length;
                                    return _InfoBox(
                                        title: "Disimpan",
                                        value: jumlahSavedNotes.toString());
                                  }),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                            const Divider(
                              color: AppColors.backgroundColor,
                            ),
                            const SizedBox(height: 20),

                            // Kalender heatmap
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: HeatmapCalendar(),
                            ),

                            const SizedBox(height: 30),

                            // tombol logout
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.buttonColor3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 12,
                                      ),
                                      elevation: 0),
                                  onPressed: () async {
                                    dialogConfirmation(
                                      imagePath:
                                          'assets/images/deco_logout.png',
                                      title: "Yakin Ingin Logout?",
                                      middleText: "",
                                      onConfirm: () async {
                                        try {
                                          await authController.logout();
                                          noteController.clear();
                                          Get.offAll(LoginPage());
                                          Get.snackbar(
                                            "Success",
                                            "Berhasil logout",
                                          );
                                        } catch (e) {
                                          Get.snackbar(
                                            "Error",
                                            "Gagal logout: $e",
                                            backgroundColor:
                                                AppColors.errorColor,
                                            colorText: AppColors.surfaceColor,
                                          );
                                        }
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.logout,
                                    color: AppColors.surfaceColor,
                                  ),
                                  label: const Text(
                                    "Logout",
                                    style: TextStyle(
                                      color: AppColors.surfaceColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // avatar profile overlap
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Obx(
                          () => CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.buttonColor2,
                            // note pengalaman error: mencegah foto zoom terlalu besar dengan gambar sebagai child bukan backgroundImage
                            child: authController.user.value?.foto != null
                                ? ClipOval(
                                    child: Image.network(
                                      authController.user.value!.foto!.trim(),
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/images/default_avatar.png",
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        );
                                      },
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.asset(
                                      "assets/images/default_avatar.png",
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// InfoBox Widget: menampilkan judul dan value (Sejak, Notes, Disimpan)
class _InfoBox extends StatelessWidget {
  final String title;
  final String value;

  const _InfoBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.disabledTextColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        SelectableText(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }
}
