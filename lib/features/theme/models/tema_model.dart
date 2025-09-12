class TemaModel {
  final String noteId;
  final String fotoUrl;

  TemaModel({required this.noteId, required this.fotoUrl});

  Map<String, dynamic> toJson() {
    return {
      'note_id': noteId,
      'foto_url': fotoUrl, // ✅ pastikan key yg dipakai backend
    };
  }

  factory TemaModel.fromJs(Map<String, dynamic> data) {
    return TemaModel(
      noteId: data['note_id'],
      fotoUrl: data['tema_link'], // ✅ ambil dari tema_link JS
    );
  }
}
