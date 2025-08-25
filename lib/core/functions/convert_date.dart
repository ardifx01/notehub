String formatTanggal(DateTime tgl) {
  const namaBulan = [
    '', // supaya index 1 = januari
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];

  final hari = tgl.day;
  final bulan = namaBulan[tgl.month];
  final tahun = tgl.year;

  return '$hari $bulan $tahun';
}
