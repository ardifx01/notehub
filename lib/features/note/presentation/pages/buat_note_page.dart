import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/widgets/custom_big_button.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/note/presentation/controllers/buat_note_controller.dart';
import 'package:notehub/features/note/presentation/controllers/note_controller.dart';

class BuatNotePage extends StatefulWidget {
  const BuatNotePage({super.key});

  @override
  State<BuatNotePage> createState() => _BuatNotePageState();
}

class _BuatNotePageState extends State<BuatNotePage> {
  final controller = Get.find<BuatNoteController>();
  final noteController = Get.find<NoteController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // tombol back
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Get.back();
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Text(
                "Buat Note",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.surfaceColor,
                ),
              ),
            ),
            // konten putih dengan rounded
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // judul
                        const Text(
                          "Judul",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: controller.judulController,
                          decoration: InputDecoration(
                            hintText: "Apa judul note ini?",
                            hintStyle: TextStyle(color: Colors.grey.shade300),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // note
                        const Text(
                          "Note",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          maxLines: 6,
                          controller: controller.isiNoteController,
                          decoration: InputDecoration(
                            hintText: "Tulis ide hebat mu disini!",
                            hintStyle: TextStyle(color: Colors.grey.shade300),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // kategori
                        const Text(
                          "Kategori",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: controller.kategoriList.map((kategori) {
                            return Obx(
                              () => KategoriChip(
                                label: kategori["label"],
                                warna: kategori["warna"],
                                iconColor: kategori["icon"],
                                aktif: controller.kategoriDipilih.value ==
                                    kategori["label"],
                                onTap: () {
                                  setState(() {
                                    controller.kategoriDipilih.value =
                                        kategori["label"];
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 30),

                        // tombol unggah
                        Obx(
                          () => CustomBigButton(
                              text: noteController.isLoading.value
                                  ? 'Sedang Upload..'
                                  : '⬆️ Upload',
                              onPressed: () async {
                                if (controller.judulController.text.isEmpty ||
                                    controller.isiNoteController.text.isEmpty) {
                                  Get.snackbar('Peringatan',
                                      'Judul dan isi note tidak boleh kosong',
                                      backgroundColor: AppColors.errorColor,
                                      colorText: AppColors.surfaceColor);
                                } else {
                                  var userId = authController.user.value!.id;
                                  var judul =
                                      controller.judulController.text.trim();
                                  var isi =
                                      controller.isiNoteController.text.trim();
                                  var kategori =
                                      controller.kategoriDipilih.value;
                                  try {
                                    await noteController.addNote(
                                        userId, judul, isi, kategori);

                                    // Reset textfield controller
                                    controller.judulController.clear();
                                    controller.isiNoteController.clear();
                                    controller.kategoriDipilih.value = 'Random';

                                    Get.back();
                                  } catch (e) {
                                    Get.snackbar(
                                      'Error',
                                      'Gagal membuat note, $e',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: AppColors.errorColor,
                                      colorText: AppColors.surfaceColor,
                                    );
                                  }
                                }
                              },
                              backgroundColor: AppColors.buttonColor3,
                              textColor: AppColors.surfaceColor),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// =============================
// Widget KategoriChip Reusable
// =============================
class KategoriChip extends StatelessWidget {
  final String label;
  final Color warna;
  final Color iconColor;
  final bool aktif;
  final VoidCallback onTap;

  const KategoriChip({
    super.key,
    required this.label,
    required this.warna,
    required this.iconColor,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: aktif ? warna.withOpacity(0.6) : warna.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: aktif ? iconColor : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            // ignore: deprecated_member_use
            color: aktif ? iconColor : iconColor.withOpacity(1),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
