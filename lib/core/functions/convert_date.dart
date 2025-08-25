import 'package:intl/intl.dart';

/// parsing tanggal dari API HTTP date format
DateTime parseHttpDate(String tglStr) {
  try {
    return DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US')
        .parseUtc(tglStr)
        .toLocal();
  } catch (_) {
    return DateTime.now(); // fallback kalau format salah
  }
}

/// format DateTime ke "20 Des 2025"
String formatTanggal(DateTime tgl) {
  return DateFormat('d MMM yyyy', 'id_ID').format(tgl);
}