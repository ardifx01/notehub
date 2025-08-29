// controller
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:notehub/core/const/colors.dart';

class BuatNoteController extends GetxController {
  
  var judulController = TextEditingController();
  var isiNoteController = TextEditingController();
  var kategoriDipilih = 'Random'.obs;

  final List<Map<String, dynamic>> kategoriList = [
    {
      "label": "Belajar",
      "warna": AppColors.belajarColor,
      "icon": AppColors.belajarColor
    },
    {
      "label": "Cerita",
      "warna": AppColors.ceritaColor,
      "icon": AppColors.ceritaColor
    },
    {
      "label": "Random",
      "warna": AppColors.randomColor,
      "icon": AppColors.randomColor
    },
  ];
}
