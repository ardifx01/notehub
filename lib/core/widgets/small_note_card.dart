// note_card.dart
import 'package:flutter/material.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/functions/warna_kategori.dart';
import 'package:notehub/features/note/models/note_model.dart';

class SmallNoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback? onTap;
  final Widget trailing;

  const SmallNoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.trailing = const Icon(Icons.person), // default
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: getKategoriColor(note.kategori),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // kategori pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                note.kategori,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.surfaceColor,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // judul
            Expanded(
              child: Column(
                children: [
                  Text(
                    note.judul,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.surfaceColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            // icon + tanggal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${note.tanggal.day}/${note.tanggal.month}/${note.tanggal.year}",
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                ),
                trailing
              ],
            ),
          ],
        ),
      ),
    );
  }
}
