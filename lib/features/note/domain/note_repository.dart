// note_repository.dart

import 'package:notehub/features/note/models/note_model.dart';

abstract class NoteRepository {
  Future<NoteModel> uploadNote(
      int userId, String judul, String isi, String kategori);
  Future<List<NoteModel>> getUserNotes(int userId);
  Future<List<NoteModel>> getAllNotes();
  Future<void> deleteNote(int noteId);
  Future<void> saveNote(int userId, int noteId);
  Future<void> unsaveNote(int userId, int noteId);
  Future<List<NoteModel>> getSavedNotes(int userId);
}
