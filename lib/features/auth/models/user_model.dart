class UserModel {
  final int id;
  final String nama;
  final String email;
  final String foto;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.foto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nama: json['nama'],
      email: json['email'],
      foto: json['foto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'foto': foto,
    };
  }

  // method copyWith untuk memudahkan update sebagian atribut
  UserModel copyWith({
    int? id,
    String? nama,
    String? email,
    String? foto,
  }) {
    return UserModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      foto: foto ?? this.foto,
    );
  }
}
