import 'dart:io';

class NoteModel {
  final int id;
  final int userId;
  final String judul;
  final String isi;
  final String kategori;
  final DateTime tanggal;
  final String tema;

  NoteModel({
    required this.id,
    required this.userId,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.tanggal,
    required this.tema,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      judul: json['judul'] ?? '',
      isi: json['isi'] ?? '',
      kategori: json['kategori'] ?? 'Random',
      tanggal: json['tanggal'] != null
          ? HttpDate.parse(json['tanggal'])
          : DateTime.now(),
      tema: json['tema'] ?? 'default',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "judul": judul,
      "isi": isi,
      "kategori": kategori,
      "tanggal": HttpDate.format(tanggal),
      "tema": tema,
    };
  }
}
