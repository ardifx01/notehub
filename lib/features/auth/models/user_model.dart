import 'package:intl/intl.dart';

class UserModel {
  final int id;
  final String nama;
  final String email;
  final String foto;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.foto,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime createdAt;
    try {
      createdAt = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US')
          .parseUtc(json['tanggal_pembuatan_akun'])
          .toLocal();
    } catch (_) {
      createdAt = DateTime.now();
    }

    return UserModel(
        id: json['id'],
        nama: json['nama'],
        email: json['email'],
        foto: json['foto'] ?? '',
        createdAt: createdAt);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'foto': foto,
    };
  }

  UserModel copyWith({
    int? id,
    String? nama,
    String? email,
    String? foto,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      foto: foto ?? this.foto,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
