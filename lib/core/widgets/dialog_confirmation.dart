import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notehub/core/const/colors.dart';

void dialogConfirmation({
    required String imagePath,
    required String title,
    required String middleText,
    required VoidCallback onConfirm,
  }) {
    Get.defaultDialog(
      backgroundColor: AppColors.surfaceColor,
      title: '',
      titleStyle: TextStyle(fontSize: 0),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // Gambar
          Image.asset(
            imagePath,
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 10),

          // Judul dan deskripsi
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryTextColor,
            ),
          ),
          Text(
            middleText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.disabledTextColor,
            ),
          ),
          const SizedBox(height: 30),

          // 2 Tombol validasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // batal
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.surfaceColor,
                    foregroundColor:
                        AppColors.buttonColor3, // warna teks & icon
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        // warna outline
                        color: AppColors.buttonColor3,
                        width: 1.5, // bisa diatur tebal tipisnya
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Batal",
                    style: TextStyle(
                      color: AppColors.buttonColor3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onConfirm();
                    Get.back(); // tutup dialog
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.buttonColor3,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // kotak dengan radius kecil
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Iya",
                    style: TextStyle(
                      color: AppColors.surfaceColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }