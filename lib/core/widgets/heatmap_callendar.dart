import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/features/note/presentation/controllers/note_controller.dart';
import 'package:notehub/core/functions/convert_date.dart';

class HeatmapCalendar extends StatelessWidget {
  HeatmapCalendar({super.key});

  final noteController = Get.find<NoteController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => HeatMap(
        datasets: noteController.notesCount,
        size: 25,
        startDate: DateTime.now().subtract(const Duration(days: 70)),
        endDate: DateTime.now(),
        colorMode: ColorMode.color,
        showText: false,
        scrollable: true,
        colorsets: {
          1: const Color.fromARGB(255, 209, 240, 138),
          2: const Color.fromARGB(255, 191, 219, 127),
          3: const Color.fromARGB(255, 178, 202, 122),
          4: const Color.fromARGB(255, 166, 189, 113),
          5: AppColors.primaryColor,
        },
        onClick: (value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(formatTanggal(value)),
            backgroundColor: AppColors.primaryColor,
          ));
        },
      ),
    );
  }
}
