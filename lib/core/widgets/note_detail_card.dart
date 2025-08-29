import 'package:flutter/material.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/functions/convert_date.dart';
import 'package:notehub/core/functions/warna_kategori.dart';
import 'package:notehub/features/note/models/note_model.dart';

class NoteDetailCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback? onIconPressed;
  final IconData icon;
  final Color iconColor;

  const NoteDetailCard({
    super.key,
    required this.note,
    this.onIconPressed,
    this.icon = Icons.delete, // default delete
    this.iconColor = AppColors.buttonColor3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- kategori pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: getKategoriColor(note.kategori).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: getKategoriColor(note.kategori)),
              ),
              child: Text(
                note.kategori,
                style: TextStyle(
                  fontSize: 12,
                  color: getKategoriColor(note.kategori),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ---------- judul
            Text(
              note.judul,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ---------- isi (scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  note.isi,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------- tanggal + tombol aksi
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Diunggah: ${formatTanggal(note.tanggal)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  IconButton(
                    onPressed: onIconPressed,
                    icon: Icon(icon, color: iconColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
