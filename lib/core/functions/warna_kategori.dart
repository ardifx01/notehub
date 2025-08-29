 
  import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notehub/core/const/colors.dart';

 // fungsi untuk pilih warna background card berdasarkan kategori
Color getKategoriColor(String kategori) {
    switch (kategori.toLowerCase()) {
      case "random":
        return AppColors.randomColor;
      case "belajar":
        return AppColors.belajarColor;
      case "cerita":
        return AppColors.ceritaColor;
      default:
        return Colors.grey.shade400;
    }
  }