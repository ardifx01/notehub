// note_repository.dart

import 'package:notehub/features/note/models/note_model.dart';

/// abstraksi repository untuk manajemen catatan
abstract class NoteRepository {
  /// unggah catatan baru
  Future<NoteModel> uploadNote(
      int userId, String judul, String isi, String kategori);

  /// ambil semua catatan milik user
  Future<List<NoteModel>> getUserNotes(int userId);

  /// ambil semua catatan
  Future<List<NoteModel>> getAllNotes();

  /// hapus catatan
  Future<void> deleteNote(int noteId);

  /// simpan catatan ke favorit
  Future<void> saveNote(int userId, int noteId);

  /// hapus dari favorit
  Future<void> unsaveNote(int userId, int noteId);

  /// ambil catatan yang disimpan
  Future<List<NoteModel>> getSavedNotes(int userId);
}
