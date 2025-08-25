import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:notehub/core/const/colors.dart';

class HeatmapCalendar extends StatelessWidget {
  const HeatmapCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      datasets: {
        DateTime(2025, 7, 6): 3,
        DateTime(2025, 7, 7): 7,
        DateTime(2025, 8, 8): 10,
        DateTime(2025, 8, 9): 13,
        DateTime(2025, 8, 13): 6,
      },
      size: 25,
      startDate: DateTime.now().subtract(const Duration(days: 70)),
      endDate: DateTime.now(),
      colorMode: ColorMode.opacity,
      showText: false,
      scrollable: true,
      colorsets: {
        1: AppColors.primaryColor,
      },
      onClick: (value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value.toString()), backgroundColor: AppColors.primaryColor,));
      },
    );
  }
}
