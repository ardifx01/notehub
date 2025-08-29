import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String kategori;
  final String judul;
  final String isi;
  final String tanggal;
  final Color Function(String) getKategoriColor;
  final VoidCallback onTap; 

  const NoteCard({
    super.key,
    required this.kategori,
    required this.judul,
    required this.isi,
    required this.tanggal,
    required this.getKategoriColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 230,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: getKategoriColor(kategori),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // kategori pill
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                kategori,
                style: TextStyle(
                  fontSize: 12,
                  color: getKategoriColor(kategori),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // judul
            Text(
              judul,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            // isi singkat
            Text(
              isi,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70),
            ),
            const Spacer(),
            // tanggal
            Text(
              "Tanggal: $tanggal",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
