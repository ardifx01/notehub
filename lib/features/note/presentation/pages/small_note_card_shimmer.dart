// Shimmer List Notes
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SmallNoteCardShimmer extends StatelessWidget {
  const SmallNoteCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // warna dasar
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(18),
                ),
              ));
        });
  }
}
