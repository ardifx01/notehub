class TemaModel {
  final String noteId;
  final String link;

  TemaModel({required this.noteId, required this.link});

  Map<String, dynamic> toJson() {
    return {
      'note_id': noteId,
      'tema_link': link,
    };
  }
}
